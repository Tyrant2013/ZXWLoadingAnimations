//
//  ZXWLoadingView.m
//  ZXWLoadingAnimations
//
//  Created by 庄晓伟 on 16/10/27.
//  Copyright © 2016年 Zhuang Xiaowei. All rights reserved.
//

#import "ZXWLoadingView.h"

static CGFloat const kPointWidth                            = 30.0f;
static CGFloat const kPointHeight                           = 30.0f;

@interface ZXWLoadingView ()

@property (nonatomic, strong) NSMutableArray                *points;
@property (nonatomic, strong) UIColor                       *firstPointColor;
@property (nonatomic, strong) UIColor                       *secondPointColor;
@property (nonatomic, strong) UIColor                       *thirdPointColor;

@end

@implementation ZXWLoadingView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _points = [[NSMutableArray alloc] initWithCapacity:3];
        _firstPointColor = [UIColor greenColor];
        _secondPointColor = [UIColor redColor];
        _thirdPointColor = [UIColor blueColor];
        [self __addThreeCirclePoint];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self startAnimation];
//        });
        [self startAnimation];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)__addThreeCirclePoint {
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat centerOriginX = width / 2 - kPointWidth / 2;
    CGFloat originY = 200.0f;
    
    CALayer *firstPoint = [CALayer layer];
    firstPoint.backgroundColor = self.firstPointColor.CGColor;
    firstPoint.cornerRadius = kPointHeight / 2;
    firstPoint.frame = (CGRect){centerOriginX - kPointWidth * 2, originY, kPointWidth, kPointHeight};
    [self.layer addSublayer:firstPoint];
    
    CALayer *secondPoint = [CALayer layer];
    secondPoint.backgroundColor = self.secondPointColor.CGColor;
    secondPoint.cornerRadius = kPointHeight / 2;
    secondPoint.frame = (CGRect){centerOriginX, originY, kPointWidth, kPointHeight};
    [self.layer addSublayer:secondPoint];
    
    CALayer *thirdPoint = [CALayer layer];
    thirdPoint.backgroundColor = self.thirdPointColor.CGColor;
    thirdPoint.cornerRadius = kPointHeight / 2;
    thirdPoint.frame = (CGRect){centerOriginX + kPointWidth * 2, originY, kPointWidth, kPointHeight};
    [self.layer addSublayer:thirdPoint];
    
    [self.points addObject:firstPoint];
    [self.points addObject:secondPoint];
    [self.points addObject:thirdPoint];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *drawPath = [self firstPointPath];
//    UIBezierPath *drawPath = [self secondPointPath];
//    UIBezierPath *drawPath = [self thirdPointPath];
//    UIBezierPath *drawPath = [self testPath];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, drawPath.CGPath);
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 1.0f);
    CGContextStrokePath(context);
}

- (void)startAnimation {
    [self setAnimationForPoint:self.points.firstObject
                          path:[self firstPointPath]
                    startColor:self.firstPointColor
                      endColor:self.thirdPointColor];
    [self setAnimationForPoint:self.points[1]
                          path:[self secondPointPath]
                    startColor:self.secondPointColor
                      endColor:self.firstPointColor];
    [self setAnimationForPoint:self.points.lastObject
                          path:[self thirdPointPath]
                    startColor:self.thirdPointColor
                      endColor:self.secondPointColor];
}

- (void)setAnimationForPoint:(CALayer *)layer path:(UIBezierPath *)path startColor:(UIColor *)sColor endColor:(UIColor *)eColor {
    NSTimeInterval duration = 1.0f;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.duration = duration;
    animation.repeatCount = INT_MAX;
    animation.removedOnCompletion = NO;
//    animation.calculationMode = kCAAnimationCubic;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:@"position"];
    
    CABasicAnimation *bgAnim = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bgAnim.fromValue = (__bridge id _Nullable)(sColor.CGColor);
    bgAnim.toValue = (__bridge id _Nullable)(eColor.CGColor);
    bgAnim.duration = duration;
    bgAnim.repeatCount = INT_MAX;
    [layer addAnimation:bgAnim forKey:@"backgroundColor"];
}

- (UIBezierPath *)firstPointPath {
    CALayer *firstPoint = self.points.firstObject;
    CGFloat centerX = CGRectGetMaxX(firstPoint.frame) + kPointWidth / 2;
    CGFloat centerY = CGRectGetMinY(firstPoint.frame) + kPointHeight / 2;
    UIBezierPath *firstPath = [UIBezierPath bezierPath];
    
    [firstPath addArcWithCenter:(CGPoint){centerX, centerY}
                         radius:30.0f
                     startAngle:M_PI
                       endAngle:0.0f
                      clockwise:YES];
    [firstPath addArcWithCenter:(CGPoint){centerX + kPointWidth * 2, centerY}
                         radius:30.0f
                     startAngle:M_PI
                       endAngle:0.0f
                      clockwise:NO];
    
    return firstPath;
}

- (UIBezierPath *)secondPointPath {
    CALayer *firstPoint = self.points.firstObject;
    CGFloat centerX = CGRectGetMaxX(firstPoint.frame) + kPointWidth / 2;
    CGFloat centerY = CGRectGetMinY(firstPoint.frame) + kPointHeight / 2;
    UIBezierPath *secondPath = [UIBezierPath bezierPath];
    [secondPath addArcWithCenter:(CGPoint){centerX, centerY}
                          radius:30.0f
                      startAngle:0.0f
                        endAngle:M_PI
                       clockwise:YES];
    return secondPath;
}

- (UIBezierPath *)thirdPointPath {
    CALayer *thirdPoint = self.points.lastObject;
    CGFloat centerX = CGRectGetMinX(thirdPoint.frame) - kPointWidth / 2;
    CGFloat centerY = CGRectGetMinY(thirdPoint.frame) + kPointHeight / 2;
    UIBezierPath *thirdPath = [UIBezierPath bezierPath];
    [thirdPath addArcWithCenter:(CGPoint){centerX, centerY}
                         radius:30.0f
                     startAngle:0.0f
                       endAngle:M_PI
                      clockwise:NO];
    return thirdPath;
}

- (UIBezierPath *)testPath {
    CALayer *firstPoint = self.points.firstObject;
    CGFloat centerX = CGRectGetMaxX(firstPoint.frame) + kPointWidth / 2;
    CGFloat centerY = CGRectGetMinY(firstPoint.frame) + kPointHeight / 2;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPoint){centerX - kPointWidth, centerY}];
    [path addCurveToPoint:(CGPoint){centerX + kPointWidth * 3, centerY}
            controlPoint1:(CGPoint){centerX, CGRectGetMinY(firstPoint.frame) - 30.0f}
            controlPoint2:(CGPoint){centerX + kPointWidth * 1.5, CGRectGetMaxY(firstPoint.frame) + 30.0f}];
    return path;
}

@end
