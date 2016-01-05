//
//  ViewController.m
//  TCLoadingViewDemo
//
//  Created by TonyChan on 16/1/5.
//  Copyright © 2016年 TonyChan. All rights reserved.
//

#import "ViewController.h"

#import "TCLoadingView.h"
#import "TCCountdown.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [TCLoadingView setLineWide:1.0f];
    [TCLoadingView setStartColor:[UIColor redColor]];
    [TCLoadingView setEndColor:[UIColor yellowColor]];
    [TCLoadingView setAnimationDuration:0.5f];
    [TCLoadingView showWithView:self.view];
    
//    [TCLoadingView showloadWithFrame:CGRectMake(100, 100, 100, 100)
//                            lineWide:6.0f
//                          startColor:[UIColor blueColor]
//                            endColor:[UIColor whiteColor]
//                            duration:1.0f
//                                view:self.view];
    
    [TCCountdown timeCountdown:30
                      interval:1
                          once:^(NSInteger second) {
                              
                          } finished:^(NSInteger second) {
                              [TCLoadingView dismiss];
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
