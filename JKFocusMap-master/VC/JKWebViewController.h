//
//  DMQY_WebViewController.h
//  DMQYWebImage
//
//  Created by zqlt on 15/6/18.
//  Copyright (c) 2015年 zqlt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

typedef void(^BackBtnCallBack)();

@interface JKWebViewController : UIViewController<UIWebViewDelegate,NJKWebViewProgressDelegate>


@property (nonatomic, strong) NSURL *webURL;

- (id)initWithPopCallBack:(BackBtnCallBack)aBackBtnCallBack;

@end
