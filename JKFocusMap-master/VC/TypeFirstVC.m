//
//  TypeFirstVC.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/15.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "TypeFirstVC.h"
#import "JKFocusMapView.h"
#import "JKTextModelHeader.h"
#import "JKWebViewController.h"

@interface TypeFirstVC ()<UIGestureRecognizerDelegate>

@end

@implementation TypeFirstVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.focusMapView.frame;
    frame = CGRectMake(0, 64, CGRectGetWidth(frame), CGRectGetHeight(frame));
    self.focusMapView.frame = frame;
    [self.view addSubview:self.focusMapView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [self.focusMapView destroyTimer];
    NSLog(@"%@ dealloc",[self class]);
}

@end
