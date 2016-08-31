#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GooglePlacesDemos/DemoListViewController.h"

#import <GooglePlaces/GooglePlaces.h>

// The cell reuse identifier we are going to use.
static NSString *const kCellIdentifier = @"DemoCellIdentifier";

@implementation DemoListViewController {
  DemoData *_demoData;
}

- (instancetype)initWithDemoData:(DemoData *)demoData {
  if ((self = [self init])) {
    _demoData = demoData;
    NSString *titleFormat =
        NSLocalizedString(@"App.NameAndVersion",
                          @"The name of the app to display in a navigation bar along with a "
                          @"placeholder for the SDK version number");
    self.title = [NSString stringWithFormat:titleFormat, [GMSPlacesClient SDKVersion]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Register a plain old UITableViewCell as this will be sufficient for our list.
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}

/**
 * Private method which is called when a demo is selected. Constructs the demo view controller and
 * displays it.
 *
 * @param demo The demo to show.
 */
- (void)showDemo:(Demo *)demo {
  // Ask the demo to give us the view controller which contains the demo.
  UIViewController *viewController =
      [demo createViewControllerForSplitView:self.splitViewController];

  // Check to see if we are on iOS 7.
  if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0) {
    // We are on iOS 8+, just call the real -showDetailViewControllerMethod. UIKit will
    // automatically either push onto the navigation stack on a small screen, or present it on the
    // left side of the |UISplitViewController| if there is enough space.
    [self showDetailViewController:viewController sender:self];
  } else {
    [self iOS7showDetailViewController:viewController sender:self];
  }
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _demoData.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _demoData.sections[section].demos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Dequeue a table view cell to use.
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];

  // Grab the demo object.
  Demo *demo = _demoData.sections[indexPath.section].demos[indexPath.row];

  // Configure the demo title on the cell.
  cell.textLabel.text = demo.title;

  return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return _demoData.sections[section].title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Get the demo which was selected.
  Demo *demo = _demoData.sections[indexPath.section].demos[indexPath.row];

  [self showDemo:demo];
}

#pragma mark - iOS 7 Support

//
// NOTE! All the following code is probably not required in your own app, it is just to enable iOS 7
// support of this demo app.
//

- (void)iOS7showDetailViewController:(UIViewController *)vc sender:(id)sender {
  // We are on iOS 7, so we are going to have to do some stuff to mimic the behavior that
  // -showDetailViewControllerMethod has on iOS 8+.

  // Check to see if we have a split view controller.
  if (self.splitViewController) {
    // If we do then update its .viewControllers property, -showDetailViewController:sender:
    // didn't exist in iOS 7.
    self.splitViewController.viewControllers = @[ self.splitViewController.viewControllers[0], vc ];
  } else {
    // If there is not a split view controller then we must be on an iPhone, which means we should
    // just use the navigation stack. However, the view controller we are given might be a
    // UINavigationController, in which case we should only push the thing(s) *in* the navigation
    // controller, rather than the navigation controller itself as UIKit does not allow this.
    NSMutableArray<UIViewController *> *viewControllers =
        [self.navigationController.viewControllers mutableCopy];
    if ([vc isKindOfClass:[UINavigationController class]]) {
      UINavigationController *navigationController = (UINavigationController *)vc;
      [viewControllers addObjectsFromArray:navigationController.viewControllers];
    } else {
      [viewControllers addObject:vc];
    }
    [self.navigationController setViewControllers:viewControllers animated:YES];
  }
}

@end
