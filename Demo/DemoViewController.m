//
//  DemoViewController.m
//  Demo
//
//  Created by 赵秋实 on 2018/9/3.
//  Copyright © 2018年 赵秋实. All rights reserved.
//

#import "DemoViewController.h"
#import "SelectAreaView.h"

@interface DemoViewController ()
@property (nonatomic, strong) SelectAreaView * selector;
@property (nonatomic, strong) NSArray * currentPoints;
@end

@implementation DemoViewController

- (instancetype)initWithPoints:(NSArray *)points {
  self = [super init];
  if (self) {
    _currentPoints = points;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:true animated:nil];
  self.view.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupSelector];
}

- (void)setupSelector {
  UIImageView * imageView = [[UIImageView alloc] init];
  imageView.image = [UIImage imageNamed:@"image"];
  [self.view addSubview:imageView];
  imageView.translatesAutoresizingMaskIntoConstraints = false;
  NSLayoutConstraint * imageLeft = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
  NSLayoutConstraint * imageRight = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
  NSLayoutConstraint * imageTop = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
  NSLayoutConstraint * imageBottom = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
  [self.view addConstraints:@[imageLeft, imageRight, imageTop, imageBottom]];
  
  if (_currentPoints) {
    _selector = [[SelectAreaView alloc] initWithPoints:_currentPoints];
  } else {
    _selector = [[SelectAreaView alloc] init];
  }
  [self.view addSubview:_selector];
  
  _selector.translatesAutoresizingMaskIntoConstraints = false;
  NSLayoutConstraint * selectorLeft = [NSLayoutConstraint constraintWithItem:_selector attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
  NSLayoutConstraint * selectorRight = [NSLayoutConstraint constraintWithItem:_selector attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
  NSLayoutConstraint * selectorTop = [NSLayoutConstraint constraintWithItem:_selector attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
  NSLayoutConstraint * selectorBottom = [NSLayoutConstraint constraintWithItem:_selector attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
  [self.view addConstraints:@[selectorLeft, selectorRight, selectorTop, selectorBottom]];
  
  
  UIButton * conformButton = [[UIButton alloc] init];
  [_selector addSubview:conformButton];
  [conformButton setTitle:@"Conform" forState:UIControlStateNormal];
  [conformButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [conformButton addTarget:self action:@selector(conformButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
  
  conformButton.translatesAutoresizingMaskIntoConstraints = false;
  NSLayoutConstraint * conformTop = [NSLayoutConstraint constraintWithItem:conformButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_selector attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
  NSLayoutConstraint * conformRight = [NSLayoutConstraint constraintWithItem:conformButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_selector attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
  NSLayoutConstraint * conformWidth = [NSLayoutConstraint constraintWithItem:conformButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60.0];
  NSLayoutConstraint * conformHeight = [NSLayoutConstraint constraintWithItem:conformButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40.0];
  [_selector addConstraints:@[conformTop, conformRight]];
  [conformButton addConstraints:@[conformWidth, conformHeight]];
  
  UIButton * reset = [[UIButton alloc] init];
  [_selector addSubview:reset];
  [reset setTitle:@"Reset" forState:UIControlStateNormal];
  [reset.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
  
  reset.translatesAutoresizingMaskIntoConstraints = false;
  NSLayoutConstraint * resetBottom = [NSLayoutConstraint constraintWithItem:reset attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_selector attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
  NSLayoutConstraint * resetRight = [NSLayoutConstraint constraintWithItem:reset attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_selector attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
  NSLayoutConstraint * resetWidth = [NSLayoutConstraint constraintWithItem:reset attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60.0];
  NSLayoutConstraint * resetHeight = [NSLayoutConstraint constraintWithItem:reset attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40.0];
  [_selector addConstraints:@[resetBottom, resetRight]];
  [reset addConstraints:@[resetWidth, resetHeight]];
  
}

- (void)conformButtonClicked:(UIButton *)confirmButton {
  NSArray * points = [_selector getPoints];
  NSLog(@"Points: %@", points);
}

- (void)reset {
  NSArray * subViews = self.view.subviews;
  for (UIView * subView in subViews) {
    [subView removeFromSuperview];
  }
  [self setupSelector];
}

- (BOOL)prefersStatusBarHidden {
  return true;
}

@end
