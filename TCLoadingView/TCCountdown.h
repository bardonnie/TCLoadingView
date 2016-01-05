//
//  TCCountdown.h
//  Collectionview
//
//  Created by TonyChan on 16/1/4.
//  Copyright © 2016年 TonyChan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Once)(NSInteger second);
typedef void (^Finished)(NSInteger second);

@interface TCCountdown : NSObject

/**
 *  默认倒计时方法 -> 总时间60秒 时间间隔1秒
 *
 *  @param once     每秒回调
 *  @param finished 完成回调
 */
+ (void)timeCountdownOnce:(Once)once
                 finished:(Finished)finished;
/**
 *  GCD 倒计时方法
 *
 *  @param time     总时间 －> 默认60秒
 *  @param interval 时间间隔 -> 默认1秒
 *  @param once     每次间隔回调
 *  @param finished 总时间完成回调
 */

+ (void)timeCountdown:(NSTimeInterval)time
             interval:(NSTimeInterval)interval
                 once:(Once)once
             finished:(Finished)finished;

@end
