#import "AppIconViewController.h"
#import "../Localization.h"
#import "../InfinitokLog.h"

static NSString *const kInfinitokPrimaryIconKey = @"__primary__";
static NSString *const kInfinitokSelectedIconDefaultsKey = @"infinitok_selected_app_icon";

@interface InfinitokIconEntry : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy, nullable) NSString *alternateIconName;
@property (nonatomic, copy) NSArray<NSString *> *iconFiles;
@end
@implementation InfinitokIconEntry
@end

@interface AppIconViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<InfinitokIconEntry *> *icons;
@property (nonatomic, copy) NSString *selectedKey;
@end

@implementation AppIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = IKLocalize(@"settings.app_icon.title");
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

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];

    [self loadIcons];
}

- (void)loadIcons {
    NSMutableArray<InfinitokIconEntry *> *entries = [NSMutableArray array];

    NSDictionary *bundleIcons = [[NSBundle mainBundle] infoDictionary][@"CFBundleIcons"];
    NSDictionary *primary = bundleIcons[@"CFBundlePrimaryIcon"];
    NSArray<NSString *> *primaryFiles = primary[@"CFBundleIconFiles"] ?: @[@"AppIcon60x60"];

    InfinitokIconEntry *primaryEntry = [InfinitokIconEntry new];
    primaryEntry.key = kInfinitokPrimaryIconKey;
    primaryEntry.displayName = IKLocalize(@"settings.app_icon.default_name");
    primaryEntry.alternateIconName = nil;
    primaryEntry.iconFiles = primaryFiles;
    [entries addObject:primaryEntry];

    NSDictionary<NSString *, NSDictionary *> *alternates = bundleIcons[@"CFBundleAlternateIcons"];
    NSArray<NSString *> *sortedKeys = [alternates.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *key in sortedKeys) {
        NSDictionary *info = alternates[key];
        NSArray<NSString *> *files = info[@"CFBundleIconFiles"] ?: @[key];

        InfinitokIconEntry *entry = [InfinitokIconEntry new];
        entry.key = key;
        entry.displayName = [self prettifiedName:key];

        entry.alternateIconName = key;
        entry.iconFiles = files;
        [entries addObject:entry];
    }

    self.icons = entries;
    self.selectedKey = [self currentSelectedKey];
    [self.tableView reloadData];
}

- (NSString *)prettifiedName:(NSString *)key {
    return [key stringByReplacingOccurrencesOfString:@"_" withString:@" "];
}

- (NSString *)currentSelectedKey {
    NSString *saved = [[NSUserDefaults standardUserDefaults] stringForKey:kInfinitokSelectedIconDefaultsKey];
    if (saved.length > 0) {
        return saved;
    }
    NSString *current = [UIApplication sharedApplication].alternateIconName;
    if (current.length > 0) {
        return current;
    }
    return kInfinitokPrimaryIconKey;
}

- (void)applyIcon:(InfinitokIconEntry *)icon {
    if (![UIApplication sharedApplication].supportsAlternateIcons) {
        [self showErrorWithMessage:IKLocalize(@"settings.app_icon.unsupported")];
        return;
    }

    if (icon.alternateIconName) {
        NSString *bundlePath = [NSBundle mainBundle].bundlePath;
        for (NSString *stem in icon.iconFiles) {
            for (NSString *suffix in @[@"@2x.png", @"@3x.png"]) {
                NSString *path = [bundlePath stringByAppendingPathComponent:[stem stringByAppendingString:suffix]];
                BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
                ITLog("boot", @"pre-flight check: %@ exists=%@", path.lastPathComponent, exists ? @"YES" : @"NO");
            }
        }
    }

    NSString *previous = self.selectedKey;
    self.selectedKey = icon.key;
    [[NSUserDefaults standardUserDefaults] setObject:icon.key forKey:kInfinitokSelectedIconDefaultsKey];
    [self.tableView reloadData];

    __weak AppIconViewController *weakSelf = self;
    [[UIApplication sharedApplication] setAlternateIconName:icon.alternateIconName completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong AppIconViewController *strongSelf = weakSelf;
            if (!strongSelf || !error) {
                return;
            }
            strongSelf.selectedKey = previous;
            [[NSUserDefaults standardUserDefaults] setObject:previous forKey:kInfinitokSelectedIconDefaultsKey];
            [strongSelf.tableView reloadData];

            ITError("boot", @"setAlternateIconName failed: domain=%@ code=%ld description=%@", error.domain, (long)error.code, error.localizedDescription);

            BOOL isFileNotFound = [error.domain isEqualToString:NSCocoaErrorDomain] && error.code == 4;
            BOOL isResourceUnavailable = [error.localizedDescription rangeOfString:@"temporarily unavailable" options:NSCaseInsensitiveSearch].location != NSNotFound;
            NSString *message = (isFileNotFound || isResourceUnavailable) ? IKLocalize(@"settings.app_icon.signing_error") : error.localizedDescription;
            [strongSelf showErrorWithMessage:message];
        });
    }];
}

- (void)showErrorWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:IKLocalize(@"settings.app_icon.title")
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:IKLocalize(@"common.ok") style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (nullable UIImage *)previewImageForIcon:(InfinitokIconEntry *)icon {
    NSInteger scale = (NSInteger)[UIScreen mainScreen].scale;
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    NSMutableArray<NSString *> *stems = [icon.iconFiles mutableCopy];
    if (icon.alternateIconName) {
        [stems addObject:icon.alternateIconName];
    }
    for (NSString *stem in stems) {
        NSArray<NSString *> *candidates = @[
            [NSString stringWithFormat:@"%@@%ldx.png", stem, (long)scale],
            [NSString stringWithFormat:@"%@@3x.png", stem],
            [NSString stringWithFormat:@"%@@2x.png", stem],
            [NSString stringWithFormat:@"%@.png", stem],
        ];
        for (NSString *candidate in candidates) {
            NSString *path = [bundlePath stringByAppendingPathComponent:candidate];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                if (image) {
                    return image;
                }
            }
        }
    }
    return nil;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.icons.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return IKLocalize(@"settings.app_icon.footer");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AppIconCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    InfinitokIconEntry *icon = self.icons[indexPath.row];
    BOOL isSelected = [icon.key isEqualToString:self.selectedKey];

    cell.textLabel.text = icon.displayName;
    cell.detailTextLabel.text = isSelected ? IKLocalize(@"settings.app_icon.selected") : IKLocalize(@"settings.app_icon.tap_to_apply");
    cell.detailTextLabel.textColor = isSelected ? [UIColor systemBlueColor] : [UIColor secondaryLabelColor];
    cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    UIImage *preview = [self previewImageForIcon:icon];
    if (preview) {
        CGSize targetSize = CGSizeMake(40, 40);
        UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:targetSize format:format];
        UIImage *resized = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, targetSize.width, targetSize.height) cornerRadius:9];
            [path addClip];
            [preview drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
        }];
        cell.imageView.image = resized;
    } else {
        cell.imageView.image = [UIImage systemImageNamed:@"app.fill"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self applyIcon:self.icons[indexPath.row]];
}

@end
