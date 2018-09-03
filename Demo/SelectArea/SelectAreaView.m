#import "SelectAreaView.h"

@interface SelectAreaView()
@property (nonatomic, strong) UIView * rotateView;
@property (nonatomic, strong) UIView * scaleView;

@property (nonatomic, strong) UIImageView * rotateImageView;
@property (nonatomic, strong) UIView * topDragView;
@property (nonatomic, strong) UIView * leftDragView;
@property (nonatomic, strong) UIView * rightDragView;
@property (nonatomic, strong) UIView * bottomDragView;

@property (nonatomic, strong) UIImageView * yellowImageView;
@property (nonatomic, strong) UIImageView * blueImageView;
@property (nonatomic, assign) CGFloat ang;

@property (nonatomic, strong) NSArray * points;
@end

@implementation SelectAreaView {
  UIView * dragView;
  CGPoint centerPoint;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self = [super init];
    [self setupCustomSelectView];
  }
  return self;
}

- (instancetype)initWithPoints:(NSArray *)points {
  self = [super init];
  if (self) {
    _points = points;
    [self setupCustomSelectView];
  }
  return self;
}

- (void)setupCustomSelectView {
  self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
  
  CGFloat width = [UIScreen mainScreen].bounds.size.height;
  CGFloat height = [UIScreen mainScreen].bounds.size.width;
  
  CGPoint point0 = CGPointMake(0.5 * width - 100, 0.5 * height - 100);
  CGPoint point1 = CGPointMake(0.5 * width + 100, 0.5 * height - 100);
  CGPoint point2 = CGPointMake(0.5 * width + 100, 0.5 * height);
  CGPoint point3 = CGPointMake(0.5 * width - 100, 0.5 * height);
  CGPoint point4 = CGPointMake(0.5 * width - 100, 0.5 * height + 100);
  CGPoint point5 = CGPointMake(0.5 * width + 100, 0.5 * height + 100);
  if (_points) {
    point0 = [_points[0] CGPointValue];
    point1 = [_points[1] CGPointValue];
    point2 = [_points[2] CGPointValue];
    point3 = [_points[3] CGPointValue];
    point4 = [_points[4] CGPointValue];
    point5 = [_points[5] CGPointValue];
  }
  
  _ang = [self angleForPoint:CGPointMake(point0.x, point0.y+1) point:point3 center:point0];
  
  CGPoint center = CGPointMake((point0.x + point5.x)/2, (point0.y + point5.y)/2);
  
  _rotateView = [[UIView alloc] initWithFrame:CGRectMake(-width, -height, 3*width, 3*height)];
  [self addSubview:_rotateView];
  _rotateView.transform = CGAffineTransformMakeRotation(_ang);
  _rotateView.center = center;
  
  CGFloat x = [self distanceFromPoint:point0 toPoint:point1];
  CGFloat y1 = [self distanceFromPoint:point0 toPoint:point3];
  CGFloat y2 = [self distanceFromPoint:point3 toPoint:point4];
  
  _scaleView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                        0,
                                                        x + 30,
                                                        y1 + y2 + 30)];
  [_rotateView addSubview:_scaleView];
  _scaleView.center = [self convertPoint:center toView:_rotateView];
  
  _yellowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, x, y1)];
  [_scaleView addSubview:_yellowImageView];
  _yellowImageView.image = [[UIImage imageNamed:@"yellow_selector"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
  
  _blueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15 + y1, x, y2)];
  [_scaleView addSubview:_blueImageView];
  _blueImageView.image = [[UIImage imageNamed:@"blue_selector"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
  
  _rotateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 30, 30)];
  [_scaleView addSubview:_rotateImageView];
  _rotateImageView.image = [UIImage imageNamed:@"rotate_selector"];
  _rotateImageView.contentMode = UIViewContentModeCenter;
  
  _topDragView = [[UIView alloc] initWithFrame:CGRectMake((x+30-50)/2, 5, 50, 20)];
  [_scaleView addSubview:_topDragView];

  UIView * topDragShow = [[UIView alloc] initWithFrame:CGRectMake(10, 8.5, 30, 3)];
  [_topDragView addSubview:topDragShow];
  topDragShow.backgroundColor = [UIColor whiteColor];

  _leftDragView = [[UIView alloc] initWithFrame:CGRectMake(5, y1 + 15 - 25, 20, 50)];
  [_scaleView addSubview:_leftDragView];

  UIButton * leftDragShow = [[UIButton alloc] initWithFrame:CGRectMake(8.5, 10, 3, 30)];
  [_leftDragView addSubview:leftDragShow];
  leftDragShow.backgroundColor = [UIColor whiteColor];

  _rightDragView = [[UIView alloc] initWithFrame:CGRectMake(x + 15 - 10, y1 + 15 - 25, 20, 50)];
  [_scaleView addSubview:_rightDragView];

  UIButton * rightDragShow = [[UIButton alloc] initWithFrame:CGRectMake(8.5, 10, 3, 30)];
  [_rightDragView addSubview:rightDragShow];
  rightDragShow.backgroundColor = [UIColor whiteColor];

  _bottomDragView = [[UIView alloc] initWithFrame:CGRectMake((x + 30 - 50)/2, y1 + y2 + 15 - 10, 50, 20)];
  [_scaleView addSubview:_bottomDragView];

  UIButton * bottomDragShow = [[UIButton alloc] initWithFrame:CGRectMake(10, 8.5, 30, 3)];
  [_bottomDragView addSubview:bottomDragShow];
  bottomDragShow.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (touches.count > 1) {
    return ;
  }
  //判断touch是否在某个view内
  UITouch * touch = [touches anyObject];
  CGPoint touchPoint = [touch locationInView:_rotateImageView];
  NSLog(@"touchPoint in RotateView: (%f, %f)", touchPoint.x, touchPoint.y);
  //rotate
  if (touchPoint.x >= 0 &&
      touchPoint.x <= 30 &&
      touchPoint.y >= 0 &&
      touchPoint.y <= 30) {
    //算一下center在哪里
    NSLog(@"touch in rotate");
    centerPoint = [_rotateView convertPoint:_scaleView.center toView:self];
    dragView = _rotateImageView;
    return ;
  }
  
  touchPoint = [touch locationInView:_bottomDragView];
  NSLog(@"touchPoint in BottomDragView: (%f, %f)", touchPoint.x, touchPoint.y);
  if (touchPoint.x >= 0 &&
      touchPoint.x <= 50 &&
      touchPoint.y >= 0 &&
      touchPoint.y <= 30) {
    dragView = _bottomDragView;
    return ;
  }
  
  touchPoint = [touch locationInView:_topDragView];
  NSLog(@"touchPoint in TopDragView: (%f, %f)", touchPoint.x, touchPoint.y);
  if (touchPoint.x >= 0 &&
      touchPoint.x <= 50 &&
      touchPoint.y >= 0 &&
      touchPoint.y <= 30) {
    dragView = _topDragView;
    return ;
  }
  
  touchPoint = [touch locationInView:_leftDragView];
  NSLog(@"touchPoint in LeftDragView: (%f, %f)", touchPoint.x, touchPoint.y);
  if (touchPoint.x >= 0 &&
      touchPoint.x <= 30 &&
      touchPoint.y >= 0 &&
      touchPoint.y <= 50) {
    dragView = _leftDragView;
    return ;
  }
  
  touchPoint = [touch locationInView:_rightDragView];
  NSLog(@"touchPoint in RightDragView: (%f, %f)", touchPoint.x, touchPoint.y);
  if (touchPoint.x >= 0 &&
      touchPoint.x <= 30 &&
      touchPoint.y >= 0 &&
      touchPoint.y <= 50) {
    dragView = _rightDragView;
    return ;
  }
  
  touchPoint = [touch locationInView:_yellowImageView];
  NSLog(@"touchPoint in YellowImageView: (%f, %f)", touchPoint.x, touchPoint.y);
  if (touchPoint.x >= 0 &&
      touchPoint.x <= _yellowImageView.frame.size.width &&
      touchPoint.y >= 0 &&
      touchPoint.y <= _yellowImageView.frame.size.height) {
    dragView = _yellowImageView;
    return ;
  }
  
  
  touchPoint = [touch locationInView:_blueImageView];
  NSLog(@"touchPoint in BlueImageView: (%f, %f)", touchPoint.x, touchPoint.y);
  if (touchPoint.x >= 0 &&
      touchPoint.x <= _blueImageView.frame.size.width &&
      touchPoint.y >= 0 &&
      touchPoint.y <= _blueImageView.frame.size.height) {
    dragView = _blueImageView;
    return ;
  }
  
  dragView = nil;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch * touch = [touches anyObject];
  CGPoint prePoint = [touch previousLocationInView:self];
  CGPoint curPoint = [touch locationInView:self];
  
  //旋转，计算角度
  if (dragView == _rotateImageView) {
    CGFloat newAng =  [self angleForPoint:prePoint
                                    point:curPoint
                                   center:centerPoint];
    if (newAng == newAng) {
      _ang += newAng;
      _rotateView.transform = CGAffineTransformMakeRotation(_ang);
    }
  } else if (dragView == _bottomDragView) {
    CGVector vectorMeta = CGVectorMake(-sinf(_ang), cosf(_ang));;
    CGVector vectorMove = CGVectorMake(curPoint.x - prePoint.x, curPoint.y - prePoint.y);
    CGFloat difLen = (vectorMeta.dx * vectorMove.dx + vectorMeta.dy * vectorMove.dy) / sqrtf(vectorMeta.dx * vectorMeta.dx + vectorMeta.dy * vectorMeta.dy);
    if (_blueImageView.frame.size.height + difLen < 15) {
      difLen = _blueImageView.frame.size.height - 15;
    }
    _bottomDragView.center = CGPointMake(_bottomDragView.center.x,
                                         _bottomDragView.center.y + difLen);
    _blueImageView.frame = CGRectMake(_blueImageView.frame.origin.x,
                                      _blueImageView.frame.origin.y,
                                      _blueImageView.frame.size.width,
                                      _blueImageView.frame.size.height + difLen);
    _scaleView.frame = CGRectMake(_scaleView.frame.origin.x,
                                  _scaleView.frame.origin.y,
                                  _scaleView.frame.size.width,
                                  _scaleView.frame.size.height + difLen);
  } else if (dragView == _topDragView) {
    CGVector vectorMeta = CGVectorMake(sinf(_ang), -cosf(_ang));
    CGVector vectorMove = CGVectorMake(curPoint.x - prePoint.x, curPoint.y - prePoint.y);
    CGFloat difLen = (vectorMeta.dx * vectorMove.dx + vectorMeta.dy * vectorMove.dy) / sqrtf(vectorMeta.dx * vectorMeta.dx + vectorMeta.dy * vectorMeta.dy);
    if (_yellowImageView.frame.size.height + difLen < 15) {
      difLen = _yellowImageView.frame.size.height - 15;
    }
    _leftDragView.center = CGPointMake(_leftDragView.center.x,
                                       _leftDragView.center.y + difLen);
    _rightDragView.center = CGPointMake(_rightDragView.center.x,
                                        _rightDragView.center.y + difLen);
    _bottomDragView.center = CGPointMake(_bottomDragView.center.x,
                                         _bottomDragView.center.y + difLen);
    _yellowImageView.frame = CGRectMake(_yellowImageView.frame.origin.x,
                                        _yellowImageView.frame.origin.y,
                                        _yellowImageView.frame.size.width,
                                        _yellowImageView.frame.size.height + difLen);
    _blueImageView.frame = CGRectMake(_blueImageView.frame.origin.x,
                                      _blueImageView.frame.origin.y + difLen,
                                      _blueImageView.frame.size.width,
                                      _blueImageView.frame.size.height);
    _scaleView.frame = CGRectMake(_scaleView.frame.origin.x,
                                  _scaleView.frame.origin.y - difLen,
                                  _scaleView.frame.size.width,
                                  _scaleView.frame.size.height + difLen);
  } else if (dragView == _leftDragView) {
    CGVector vectorMeta = CGVectorMake(-cosf(_ang), -sinf(_ang));
    CGVector vectorMove = CGVectorMake(curPoint.x - prePoint.x, curPoint.y - prePoint.y);
    CGFloat difLen = (vectorMeta.dx * vectorMove.dx + vectorMeta.dy * vectorMove.dy) / sqrtf(vectorMeta.dx * vectorMeta.dx + vectorMeta.dy * vectorMeta.dy);
    if (_yellowImageView.frame.size.width + difLen < 45) {
      difLen = _yellowImageView.frame.size.width - 45;
    }
    _topDragView.center = CGPointMake(_topDragView.center.x + difLen / 2,
                                      _topDragView.center.y);
    _bottomDragView.center = CGPointMake(_bottomDragView.center.x + difLen / 2,
                                         _bottomDragView.center.y);
    _rightDragView.center = CGPointMake(_rightDragView.center.x + difLen,
                                        _rightDragView.center.y);
    _rotateImageView.center = CGPointMake(_rotateImageView.center.x + difLen,
                                          _rotateImageView.center.y);
    _yellowImageView.frame = CGRectMake(_yellowImageView.frame.origin.x,
                                        _yellowImageView.frame.origin.y,
                                        _yellowImageView.frame.size.width + difLen,
                                        _yellowImageView.frame.size.height);
    _blueImageView.frame = CGRectMake(_blueImageView.frame.origin.x,
                                      _blueImageView.frame.origin.y,
                                      _blueImageView.frame.size.width + difLen,
                                      _blueImageView.frame.size.height);
    _scaleView.frame = CGRectMake(_scaleView.frame.origin.x - difLen,
                                  _scaleView.frame.origin.y,
                                  _scaleView.frame.size.width + difLen,
                                  _scaleView.frame.size.height);
  } else if (dragView == _rightDragView) {
    CGVector vectorMeta = CGVectorMake(cosf(_ang), sinf(_ang));
    CGVector vectorMove = CGVectorMake(curPoint.x - prePoint.x, curPoint.y - prePoint.y);
    CGFloat difLen = (vectorMeta.dx * vectorMove.dx + vectorMeta.dy * vectorMove.dy) / sqrtf(vectorMeta.dx * vectorMeta.dx + vectorMeta.dy * vectorMeta.dy);
    if (_yellowImageView.frame.size.width + difLen < 45) {
      difLen = _yellowImageView.frame.size.width - 45;
    }
    _rightDragView.center = CGPointMake(_rightDragView.center.x + difLen,
                                        _rightDragView.center.y);
    _topDragView.center = CGPointMake(_topDragView.center.x + difLen / 2,
                                      _topDragView.center.y);
    _bottomDragView.center = CGPointMake(_bottomDragView.center.x + difLen / 2,
                                         _bottomDragView.center.y);
    _yellowImageView.frame = CGRectMake(_yellowImageView.frame.origin.x,
                                        _yellowImageView.frame.origin.y,
                                        _yellowImageView.frame.size.width + difLen,
                                        _yellowImageView.frame.size.height);
    _blueImageView.frame = CGRectMake(_blueImageView.frame.origin.x,
                                      _blueImageView.frame.origin.y,
                                      _blueImageView.frame.size.width + difLen,
                                      _blueImageView.frame.size.height);
    _rotateImageView.frame = CGRectMake(_rotateImageView.frame.origin.x + difLen,
                                        _rotateImageView.frame.origin.y,
                                        _rotateImageView.frame.size.width,
                                        _rotateImageView.frame.size.height);
    _scaleView.frame = CGRectMake(_scaleView.frame.origin.x,
                                  _scaleView.frame.origin.y,
                                  _scaleView.frame.size.width + difLen,
                                  _scaleView.frame.size.height);
  } else if (dragView == _yellowImageView || dragView == _blueImageView) {
    CGPoint diffPoint = CGPointMake(curPoint.x - prePoint.x, curPoint.y - prePoint.y);
    _rotateView.center = CGPointMake(_rotateView.center.x + diffPoint.x, _rotateView.center.y + diffPoint.y);
//    _scaleView.center = CGPointMake(_scaleView.center.x + diffPoint.x, _scaleView.center.y + diffPoint.y);
  }
  
  CGPoint scaleViewCenterInSelf = [_rotateView convertPoint:_scaleView.center toView:self];
  _rotateView.center = scaleViewCenterInSelf;
  CGPoint newScaleViewCenter = [self convertPoint:scaleViewCenterInSelf toView:_rotateView];
  _scaleView.center = newScaleViewCenter;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch Ended");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touch cancelled");
}

- (CGFloat)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB {
  return sqrtf((pointA.x - pointB.x)*(pointA.x - pointB.x) + (pointA.y - pointB.y)*(pointA.y - pointB.y));
}

- (CGFloat)angleForPoint:(CGPoint)pointA point:(CGPoint)pointB center:(CGPoint)center {
  CGFloat x1 = pointA.x - center.x;
  CGFloat y1 = pointA.y - center.y;
  CGFloat x2 = pointB.x - center.x;
  CGFloat y2 = pointB.y - center.y;
  if (x1*y2 - x2*y1 > 0) {
    return acosf(((x1 * x2 +y1 * y2) / (sqrtf(x1 * x1 + y1 * y1) * sqrtf(x2 * x2 + y2 * y2))));
  } else {
    return -acosf(((x1 * x2 +y1 * y2) / (sqrtf(x1 * x1 + y1 * y1) * sqrtf(x2 * x2 + y2 * y2))));
  }
}

- (CGFloat)angleForVector:(CGPoint)vectorA vector:(CGPoint)vectorB {
  if (vectorA.x * vectorB.y - vectorB.x * vectorA.y > 0) {
    return acosf(((vectorA.x * vectorB.x + vectorA.y * vectorB.y) / (sqrtf(vectorA.x * vectorA.x + vectorA.y * vectorA.y) * sqrtf(vectorB.x * vectorB.x + vectorB.y * vectorB.y))));
  } else {
    return -acosf(((vectorA.x * vectorB.x +vectorA.y * vectorB.y) / (sqrtf(vectorA.x * vectorA.x + vectorA.y * vectorA.y) * sqrtf(vectorB.x * vectorB.x + vectorB.y * vectorB.y))));
  }
}

- (NSArray *)getPoints {
  /*
   0------1
   |Yellow|
   3------2
   | Blue |
   4------5
   按照这个顺序返回点的数组
   */
  CGPoint point0 = CGPointMake(_yellowImageView.frame.origin.x,
                               _yellowImageView.frame.origin.y);
  point0 = [_scaleView convertPoint:point0 toView:self];
  
  CGPoint point1 = CGPointMake(_yellowImageView.frame.origin.x + _yellowImageView.frame.size.width,
                               _yellowImageView.frame.origin.y);
  point1 = [_scaleView convertPoint:point1 toView:self];
  
  CGPoint point2 = CGPointMake(_blueImageView.frame.origin.x + _blueImageView.frame.size.width,
                               _blueImageView.frame.origin.y);
  point2 = [_scaleView convertPoint:point2 toView:self];
  
  CGPoint point3 = CGPointMake(_blueImageView.frame.origin.x,
                               _blueImageView.frame.origin.y);
  point3 = [_scaleView convertPoint:point3 toView:self];
  
  CGPoint point4 = CGPointMake(_blueImageView.frame.origin.x,
                               _blueImageView.frame.origin.y + _blueImageView.frame.size.height);
  point4 = [_scaleView convertPoint:point4 toView:self];
  
  CGPoint point5 = CGPointMake(_blueImageView.frame.origin.x + _blueImageView.frame.size.width,
                               _blueImageView.frame.origin.y + _blueImageView.frame.size.height);
  point5 = [_scaleView convertPoint:point5 toView:self];
  
  NSLog(@"Test Point6: (%f, %f)", point0.x, point0.y);
  NSLog(@"Test Point1: (%f, %f)", point1.x, point1.y);
  NSLog(@"Test Point2: (%f, %f)", point2.x, point2.y);
  NSLog(@"Test Point3: (%f, %f)", point3.x, point3.y);
  NSLog(@"Test Point4: (%f, %f)", point4.x, point4.y);
  NSLog(@"Test Point5: (%f, %f)", point5.x, point5.y);
  
  NSValue * value0 = [NSValue valueWithCGPoint:point0];
  NSValue * value1 = [NSValue valueWithCGPoint:point1];
  NSValue * value2 = [NSValue valueWithCGPoint:point2];
  NSValue * value3 = [NSValue valueWithCGPoint:point3];
  NSValue * value4 = [NSValue valueWithCGPoint:point4];
  NSValue * value5 = [NSValue valueWithCGPoint:point5];
  
  return @[value0, value1, value2, value3, value4, value5];
}

- (CGPoint)getPointInArray:(NSArray *)array atIndex:(NSInteger)index {
  if (array.count < index) {
    return CGPointZero;
  }
  NSValue * value = [array objectAtIndex:index];
  return [value CGPointValue];
}

@end
