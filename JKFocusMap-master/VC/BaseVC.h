//
//  BaseVC.h
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/15.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKFocusMapView.h"
#import "JKTextModelHeader.h"
#import "JKWebViewController.h"

#define WEAKSELF __weak __typeof(&*self)weakSelf = self;

@interface BaseVC : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) JKFocusMapView *focusMapView;

@property (nonatomic, assign) JKFocusMapVCImageType imageType;

@property (nonatomic, assign) BOOL showPageControl;

@property (nonatomic, assign) NSInteger timerInterval;

@property (nonatomic, assign) CGFloat timerAnimateDuration;

@end
