#import <UIKit/UIKit.h>

@interface SelectAreaView : UIView
//返回points, [NSValue valueWithCGPoint:(x, y)]
- (instancetype)initWithPoints:(NSArray *)points;
- (NSArray *)getPoints;
@end
