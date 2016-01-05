//
//  TCLoadingView.h
//  Collectionview
//
//  Created by TonyChan on 15/12/28.
//  Copyright © 2015年 TonyChan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCLoadingView : UIView

/**
 *  显示loading view
 *
 *  @param view 父视图
 */
+ (void)showWithView:(UIView *)view;

/**
 *  显示loading view pro
 *
 *  @param frame      坐标大小  必要
 *  @param wide       线条宽度  默认4.0f
 *  @param startColor 渐变开始颜色    默认 lightGrayColor
 *  @param endColor   渐变结束颜色    默认 whiteColor
 *  @param duration   动画时长  默认1.5f
 *  @param view   父视图
 */
+ (void)showloadWithFrame:(CGRect)frame
                 lineWide:(CGFloat)wide
               startColor:(UIColor *)startColor
                 endColor:(UIColor *)endColor
                 duration:(NSTimeInterval)duration
                     view:(UIView *)view;
/**
 *  设置线条宽度
 */
+ (void)setLineWide:(CGFloat)wide;

/**
 *  设置渐变开始颜色
 */
+ (void)setStartColor:(UIColor *)color;

/**
 *  设置渐变结束颜色
 */
+ (void)setEndColor:(UIColor *)color;

/**
 *  设置动画间隔时间
 */
+ (void)setAnimationDuration:(NSTimeInterval)duration;

/**
 *  隐藏loading view
 */
+ (void)dismiss;

@end
