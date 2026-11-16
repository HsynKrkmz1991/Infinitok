#import "ContributorsViewController.h"
#import "../Localization.h"
#import "../InfinitokLog.h"

static NSString *const kInfinitokContributorsRepoSlug = @"SideloadLabs/Infinitok-public";
static NSString *const kInfinitokContributorsBranch = @"main";

static NSString *InfinitokContributorsJSONURLString(void) {
    return [NSString stringWithFormat:@"https://raw.githubusercontent.com/%@/refs/heads/%@/contributors.json",
            kInfinitokContributorsRepoSlug, kInfinitokContributorsBranch];
}

#pragma mark - Avatar cache

@interface InfinitokAvatarCache : NSObject
+ (instancetype)shared;
- (void)imageForUsername:(NSString *)username completion:(void (^)(UIImage * _Nullable image))completion;
@end

@implementation InfinitokAvatarCache {
    NSCache<NSString *, UIImage *> *_cache;
}

+ (instancetype)shared {
    static InfinitokAvatarCache *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [InfinitokAvatarCache new];
        instance->_cache = [NSCache new];
    });
    return instance;
}

- (void)imageForUsername:(NSString *)username completion:(void (^)(UIImage * _Nullable))completion {
    UIImage *cached = [_cache objectForKey:username];
    if (cached) {
        completion(cached);
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/%@.png", username]];
    if (!url) {
        completion(nil);
        return;
    }
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        if (image) {
            [self->_cache setObject:image forKey:username];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];
}

@end

#pragma mark - Cell

@interface ContributorCell : UITableViewCell
@property (nonatomic, copy) NSString *avatarUsername;
- (void)configureWithContributor:(NSDictionary *)contributor;
@end

@implementation ContributorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        self.imageView.layer.cornerRadius = 20;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.backgroundColor = [UIColor systemGray5Color];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.avatarUsername = nil;
}

- (void)configureWithContributor:(NSDictionary *)contributor {
    NSArray<NSString *> *usernames = contributor[@"usernames"];
    NSString *displayName = contributor[@"displayName"];
    NSArray<NSString *> *roles = contributor[@"roles"];
    NSString *firstUsername = usernames.firstObject;

    if (usernames.count > 1) {
        self.textLabel.text = [usernames componentsJoinedByString:@" & "];
    } else {
        self.textLabel.text = displayName ?: firstUsername ?: @"?";
    }
    self.detailTextLabel.text = [roles componentsJoinedByString:@", "];

    self.imageView.image = [UIImage systemImageNamed:@"person.crop.circle.fill"];
    self.avatarUsername = firstUsername;

    if (firstUsername) {
        __weak ContributorCell *weakSelf = self;
        [[InfinitokAvatarCache shared] imageForUsername:firstUsername completion:^(UIImage * _Nullable image) {
            __strong ContributorCell *strongSelf = weakSelf;

            if (!strongSelf || !image || ![strongSelf.avatarUsername isEqualToString:firstUsername]) {
                return;
            }
            UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
            UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(40, 40) format:format];
            UIImage *resized = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
                [image drawInRect:CGRectMake(0, 0, 40, 40)];
            }];
            strongSelf.imageView.image = resized;
            [strongSelf setNeedsLayout];
        }];
    }
}

@end

#pragma mark - ContributorsViewController

@interface ContributorsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) NSArray<NSDictionary *> *sections;
@end

@implementation ContributorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = IKLocalize(@"settings.contributors.title");
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor systemBackgroundColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        appearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.compactAppearance = appearance;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSelf)];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.spinner];

    self.errorLabel = [UILabel new];
    self.errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.errorLabel.numberOfLines = 0;
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.textColor = [UIColor secondaryLabelColor];
    self.errorLabel.hidden = YES;
    [self.view addSubview:self.errorLabel];

    self.retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.retryButton setTitle:IKLocalize(@"common.retry") forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(loadContributors) forControlEvents:UIControlEventTouchUpInside];
    self.retryButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.retryButton.hidden = YES;
    [self.view addSubview:self.retryButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],

        [self.errorLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.errorLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-20],
        [self.errorLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:32],
        [self.errorLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-32],

        [self.retryButton.topAnchor constraintEqualToAnchor:self.errorLabel.bottomAnchor constant:12],
        [self.retryButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ]];

    [self loadContributors];
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadContributors {
    self.tableView.hidden = YES;
    self.errorLabel.hidden = YES;
    self.retryButton.hidden = YES;
    [self.spinner startAnimating];

    NSURL *url = [NSURL URLWithString:InfinitokContributorsJSONURLString()];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner stopAnimating];

            if (error) {
                ITError("contributors", @"failed to fetch contributors.json: %@", error.localizedDescription);
                [self fallBackToBundledContributorsWithReason:error.localizedDescription];
                return;
            }

            NSHTTPURLResponse *httpResponse = [response isKindOfClass:[NSHTTPURLResponse class]] ? (NSHTTPURLResponse *)response : nil;
            if (httpResponse && httpResponse.statusCode != 200) {

                ITError("contributors", @"contributors.json fetch returned HTTP %ld", (long)httpResponse.statusCode);
                [self fallBackToBundledContributorsWithReason:[NSString stringWithFormat:@"HTTP %ld", (long)httpResponse.statusCode]];
                return;
            }

            NSError *jsonError = nil;
            id parsed = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError] : nil;
            if (jsonError || ![parsed isKindOfClass:[NSArray class]]) {
                ITError("contributors", @"failed to parse contributors.json: %@", jsonError.localizedDescription ?: @"unexpected format");
                [self fallBackToBundledContributorsWithReason:IKLocalize(@"settings.contributors.parse_error")];
                return;
            }

            ITLog("contributors", @"loaded contributors.json from GitHub");
            [self applyParsedContributorsJSON:parsed sourceDescription:@"GitHub"];
        });
    }];
    [task resume];
}

- (void)fallBackToBundledContributorsWithReason:(NSString *)reason {
    NSBundle *bundle = InfinitokBundle();
    NSString *path = [bundle pathForResource:@"contributors" ofType:@"json"];
    NSData *data = path ? [NSData dataWithContentsOfFile:path] : nil;
    id parsed = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;

    if (![parsed isKindOfClass:[NSArray class]]) {
        ITError("contributors", @"bundled contributors.json also unavailable, giving up");
        [self showErrorWithMessage:reason];
        return;
    }

    ITLog("contributors", @"live fetch failed (%@) — using bundled contributors.json instead", reason);
    [self applyParsedContributorsJSON:parsed sourceDescription:@"bundle"];
}

- (void)applyParsedContributorsJSON:(id)parsed sourceDescription:(NSString *)sourceDescription {
    NSArray<NSDictionary *> *rawSections = (NSArray<NSDictionary *> *)parsed;
    NSMutableArray<NSDictionary *> *processedSections = [NSMutableArray array];
    for (NSDictionary *section in rawSections) {
        NSArray<NSDictionary *> *contributors = section[@"contributors"];
        if (![contributors isKindOfClass:[NSArray class]] || contributors.count == 0) {
            continue;
        }
        if ([section[@"shuffled"] boolValue]) {
            NSMutableArray *shuffled = [contributors mutableCopy];
            for (NSUInteger i = shuffled.count; i > 1; i--) {
                [shuffled exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((uint32_t)i)];
            }
            contributors = shuffled;
        }
        [processedSections addObject:@{@"title": section[@"title"] ?: @"", @"contributors": contributors}];
    }

    ITLog("contributors", @"loaded %lu contributor sections from %@", (unsigned long)processedSections.count, sourceDescription);
    self.sections = processedSections;

    if (processedSections.count == 0) {
        [self showErrorWithMessage:IKLocalize(@"settings.contributors.empty")];
        return;
    }

    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (void)showErrorWithMessage:(NSString *)message {
    self.errorLabel.text = message;
    self.errorLabel.hidden = NO;
    self.retryButton.hidden = NO;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contributors = self.sections[section][@"contributors"];
    return contributors.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ContributorCell";
    ContributorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ContributorCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *contributor = self.sections[indexPath.section][@"contributors"][indexPath.row];
    [cell configureWithContributor:contributor];
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *contributor = self.sections[indexPath.section][@"contributors"][indexPath.row];
    NSString *username = [contributor[@"usernames"] firstObject];
    if (!username) {
        return;
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/%@", username]];
    if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
