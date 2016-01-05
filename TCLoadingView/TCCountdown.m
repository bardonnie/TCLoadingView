//
//  TCCountdown.m
//  Collectionview
//
//  Created by TonyChan on 16/1/4.
//  Copyright © 2016年 TonyChan. All rights reserved.
//

#import "TCCountdown.h"

@implementation TCCountdown

+ (void)timeCountdownOnce:(Once)once
                 finished:(Finished)finished
{
    [self timeCountdown:0
               interval:0
                   once:^(NSInteger second) {
                       once(second);
                   } finished:^(NSInteger second) {
                       finished(second);
                   }];
}

+ (void)timeCountdown:(NSTimeInterval)time
             interval:(NSTimeInterval)interval
                 once:(Once)once
             finished:(Finished)finished
{
    if (!time) {
        time = 60.0f;
    }
    if (!interval) {
        interval = 1.0f;
    }
    __block NSInteger timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),interval*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout == INFINITY) {
            NSLog(@"INFINITY");
        }
        
        if(timeout <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                finished(timeout);
            });
        } else{
            int seconds = timeout % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                once(seconds);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
