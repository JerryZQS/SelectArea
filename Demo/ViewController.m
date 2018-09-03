#import "ViewController.h"
#import "DemoViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define CellIdentifier @"Cell"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray * funcs;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupProperties];
  [self setupCustomView];
  [self addContraints];
}

- (void)setupProperties {
  _funcs = @[@"Default points", @"Init with points"];
}

- (void)setupCustomView {
  self.title = @"Demo";
  self.view.backgroundColor = [UIColor whiteColor];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [self.view addSubview:_tableView];
}

- (void)processClickForTitle:(NSString *)title {
  if ([title isEqualToString:@"Default points"]) {
    [self.navigationController pushViewController:[[DemoViewController alloc] init] animated:true];
  } else if ([title isEqualToString:@"Init with points"]) {
    NSArray * points = @[
                         [NSValue valueWithCGPoint:CGPointMake(59.065370541807191, 196.12226827395162)],
                         [NSValue valueWithCGPoint:CGPointMake(337.3308783015467, 12.042390879082802)],
                         [NSValue valueWithCGPoint:CGPointMake(416.90238051266181, 132.32715409893481)],
                         [NSValue valueWithCGPoint:CGPointMake(138.6368727529223, 316.40703149380363)],
                         [NSValue valueWithCGPoint:CGPointMake(193.80971865398635, 399.80941200645714)],
                         [NSValue valueWithCGPoint:CGPointMake(472.07522641372589, 215.72953461158829)]
                         ];
    DemoViewController * demoVC = [[DemoViewController alloc] initWithPoints:points];
    [self.navigationController pushViewController:demoVC animated:true];
  }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _funcs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.textLabel.text = _funcs[indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];
  NSString * str = _funcs[indexPath.row];
  [self processClickForTitle:str];
}

#pragma mark - layout

- (void)addContraints {
  _tableView.translatesAutoresizingMaskIntoConstraints = false;
  NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_tableView
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0.1];
  NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:_tableView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.view
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant:0.1];
  NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.1];
  NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:_tableView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0.1];
  [self.view addConstraints:@[left, right, top, bottom]];
  
}

@end
