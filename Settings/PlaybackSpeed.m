
#import "PlaybackSpeed.h"

@interface PlaybackSpeed ()
@property (nonatomic, strong) UITableView *staticTable;
@property (nonatomic, strong) NSArray <NSNumber *> *speeds;
@end

@implementation PlaybackSpeed

- (void)viewDidLoad {
    [super viewDidLoad];
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

    self.speeds = @[@0.25, @0.5, @1.0, @1.25, @1.5, @2.0];
    self.title = @"Select Speed";
    self.staticTable = [[UITableView alloc] initWithFrame:CGRectZero];
    self.staticTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.staticTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];

    [self.view addSubview:self.staticTable];
    [NSLayoutConstraint activateConstraints:@[
        [self.staticTable.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.staticTable.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.staticTable.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.staticTable.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    self.staticTable.dataSource = self;
    self.staticTable.delegate = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ x", self.speeds[indexPath.row]];
        cell.tag = [self.speeds[indexPath.row] floatValue];
        return cell;

}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.speeds.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *selectedSpeed = self.speeds[indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:selectedSpeed forKey:@"playback_speed"];
    [defaults synchronize];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Live Option Selected" message:[NSString stringWithFormat:@"You selected: %@", selectedSpeed]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionSelectedNotification"
                                                        object:nil
                                                      userInfo:@{@"selected Speed": selectedSpeed}];
    NSLog(@"%@",selectedSpeed);
}
    @end
