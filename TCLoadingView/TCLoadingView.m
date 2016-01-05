//
//  TCLoadingView.m
//  Collectionview
//
//  Created by TonyChan on 15/12/28.
//  Copyright © 2015年 TonyChan. All rights reserved.
//

#import "TCLoadingView.h"

#define AnimationFunctionName kCAMediaTimingFunctionLinear

static CGFloat TCLoadingViewLineWide;
static UIColor *TCLoadingViewStartColor;
static UIColor *TCLoadingViewEndColor;
static NSTimeInterval TCLoadingViewDuration;

@interface TCLoadingView ()

@end

@implementation TCLoadingView

static TCLoadingView *_shareLoadingView = nil;

+ (TCLoadingView *)shareLoadingView
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shareLoadingView = [[self alloc] initWithFrame:CGRectZero];
        TCLoadingViewLineWide = 2.0f;
        TCLoadingViewStartColor = [UIColor grayColor];
        TCLoadingViewEndColor = [UIColor whiteColor];
        TCLoadingViewDuration = 1.5f;
    });
    return _shareLoadingView;
}

+ (void)setLineWide:(CGFloat)wide
{
    [self shareLoadingView];
    TCLoadingViewLineWide = wide;
}

+ (void)setStartColor:(UIColor *)color
{
    [self shareLoadingView];
    TCLoadingViewStartColor = color;
}

+ (void)setEndColor:(UIColor *)color
{
    [self shareLoadingView];
    TCLoadingViewEndColor = color;
}

+ (void)setAnimationDuration:(NSTimeInterval)duration
{
    [self shareLoadingView];
    TCLoadingViewDuration = duration;
}

+ (void)dismiss
{
    TCLoadingView *loadingView = [TCLoadingView shareLoadingView];
    [loadingView removeFromSuperview];
    loadingView = nil;
}

+ (void)showWithView:(UIView *)view
{
    [self shareLoadingView];

    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat x = CGRectGetWidth(rect)/2.0f - 22.0f;
    CGFloat y = CGRectGetHeight(rect)/2.0f - 22.0f;
    [self showloadWithFrame:CGRectMake(x, y, 44.0f, 44.0f)
                   lineWide:TCLoadingViewLineWide
                 startColor:TCLoadingViewStartColor
                   endColor:TCLoadingViewEndColor
                   duration:TCLoadingViewDuration
                       view:view];
}

+ (void)showloadWithFrame:(CGRect)frame
                 lineWide:(CGFloat)wide
               startColor:(UIColor *)startColor
                 endColor:(UIColor *)endColor
                 duration:(NSTimeInterval)duration
                     view:(UIView *)view
{
    TCLoadingView *loadingView = [self shareLoadingView];
    loadingView.frame = frame;
    
    TCLoadingViewLineWide = wide;
    TCLoadingViewStartColor = startColor;
    TCLoadingViewEndColor = endColor;
    TCLoadingViewDuration = duration;
    if (!view) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    NSArray * colors = [loadingView graintFromColor:startColor ToColor:endColor Count:4.0];
    for (int i = 0; i < colors.count -1; i++) {
        CAGradientLayer *graint = [CAGradientLayer layer];
        graint.backgroundColor = [[UIColor clearColor] CGColor];
        graint.bounds = CGRectMake(0,0,CGRectGetWidth(frame)/2,CGRectGetHeight(frame)/2);
        NSValue *valuePoint = [[loadingView positionArrayWithMainBounds:loadingView.bounds] objectAtIndex:i];
        graint.position = valuePoint.CGPointValue;
        UIColor *fromColor = colors[i];
        UIColor *toColor = colors[i+1];
        NSArray *colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, toColor.CGColor, nil];
        NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
        NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
        NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
        graint.colors = colors;
        graint.locations = locations;
        graint.startPoint = ((NSValue *)[[loadingView startPoints] objectAtIndex:i]).CGPointValue;
        graint.endPoint = ((NSValue *)[[loadingView endPoints] objectAtIndex:i]).CGPointValue;
        [loadingView.layer addSublayer:graint];
    }
    
    CAShapeLayer * shapelayer = [CAShapeLayer layer];
    shapelayer.backgroundColor = [[UIColor clearColor] CGColor];
    CGRect rect = CGRectMake(0,0,CGRectGetWidth(loadingView.bounds) - 2 * wide, CGRectGetHeight(loadingView.bounds) - 2 * wide);
    shapelayer.bounds = rect;
    shapelayer.position = CGPointMake(CGRectGetWidth(loadingView.bounds)/2, CGRectGetHeight(loadingView.bounds)/2);
    shapelayer.strokeColor = [UIColor blueColor].CGColor;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
    shapelayer.lineWidth = wide;
    shapelayer.lineCap = kCALineCapRound;
    shapelayer.strokeStart = 0.015f;
    shapelayer.strokeEnd = 0.985f;
    [loadingView.layer setMask:shapelayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:AnimationFunctionName];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.015f];
    pathAnimation.toValue = [NSNumber numberWithFloat:0.985f];
    pathAnimation.duration = duration*1.5;
    pathAnimation.autoreverses = YES;
    pathAnimation.repeatCount = INFINITY;
//    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    [shapelayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
//    shapelayer.strokeEnd = 0.985f;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:AnimationFunctionName];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0 ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = NO;
    rotationAnimation.repeatCount = INFINITY;
    rotationAnimation.removedOnCompletion = NO;
    
    [loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [view addSubview:loadingView];
}

- (NSArray *)positionArrayWithMainBounds:(CGRect)bounds
{
    CGPoint first = CGPointMake(CGRectGetWidth(bounds)/4 *3, CGRectGetHeight(bounds)/4 *1);
    CGPoint second = CGPointMake(CGRectGetWidth(bounds)/4 *3, CGRectGetHeight(bounds)/4 *3);
    CGPoint thrid = CGPointMake(CGRectGetWidth(bounds)/4 *1, CGRectGetHeight(bounds)/4 *3);
    CGPoint fourth = CGPointMake(CGRectGetWidth(bounds)/4 *1, CGRectGetHeight(bounds)/4 *1);
    return @[[NSValue valueWithCGPoint:first],
             [NSValue valueWithCGPoint:second],
             [NSValue valueWithCGPoint:thrid],
             [NSValue valueWithCGPoint:fourth]];
}

- (NSArray *)startPoints
{
    return @[[NSValue valueWithCGPoint:CGPointMake(0,0)],
             [NSValue valueWithCGPoint:CGPointMake(1,0)],
             [NSValue valueWithCGPoint:CGPointMake(1,1)],
             [NSValue valueWithCGPoint:CGPointMake(0,1)]];
}

- (NSArray *)endPoints
{
    return @[[NSValue valueWithCGPoint:CGPointMake(1,1)],
             [NSValue valueWithCGPoint:CGPointMake(0,1)],
             [NSValue valueWithCGPoint:CGPointMake(0,0)],
             [NSValue valueWithCGPoint:CGPointMake(1,0)]];
}

- (NSArray *)graintFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Count:(NSInteger)count
{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (int i = (int)count; i >= 0; i--) {
        CGFloat oneR = fromR + (toR - fromR)/count * i;
        CGFloat oneG = fromG + (toG - fromG)/count * i;
        CGFloat oneB = fromB + (toB - fromB)/count * i;
        CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha)/count * i;
        UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
        [result addObject:onecolor];
    }
    return result;
}

-(UIColor *)midColorWithFromColor:(UIColor *)fromColor ToColor:(UIColor*)toColor Progress:(CGFloat)progress{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    CGFloat oneR = fromR + (toR - fromR) * progress;
    CGFloat oneG = fromG + (toG - fromG) * progress;
    CGFloat oneB = fromB + (toB - fromB) * progress;
    CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
    return onecolor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}

@end
