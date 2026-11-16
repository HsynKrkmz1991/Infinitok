#import "LiveActions.h"

@interface LiveActions () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *liveFuncValues;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *liveFuncTitles;

@end

@implementation LiveActions

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Live Button Actions";
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

    self.liveFuncTitles = @[@"Default", @"Infinitok Settings", @"Playback Speed"];
    self.liveFuncValues = @[@0, @1, @2];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.liveFuncValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor systemBackgroundColor];

    cell.textLabel.text = self.liveFuncTitles[indexPath.row];

    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSNumber *selectedLiveOption = self.liveFuncTitles[indexPath.row];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.liveFuncValues[indexPath.row] forKey:@"live_action"];
    [defaults synchronize];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Live Option Selected" message:[NSString stringWithFormat:@"You selected: %@", self.liveFuncTitles[indexPath.row]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionSelectedNotification"
                                                        object:nil
                                                      userInfo:@{@"selected action": selectedLiveOption}];
}

@end
