//
//  DMQY_WebViewController.m
//  DMQYWebImage
//
//  Created by zqlt on 15/6/18.
//  Copyright (c) 2015年 zqlt. All rights reserved.
//

#import "JKWebViewController.h"
#import "NJKWebViewProgressView.h"

@interface JKWebViewController ()

{
    UIWebView *_webView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic, strong) BackBtnCallBack backBtnCallBack;

@end

@implementation JKWebViewController

- (id)initWithPopCallBack:(BackBtnCallBack)aBackBtnCallBack
{
    if (self = [super init])
    {
        self.backBtnCallBack = aBackBtnCallBack;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.backBtnCallBack)
    {
        self.backBtnCallBack ();
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:_webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    __block NJKWebViewProgressView *temp = _progressView;
    _progressProxy.progressBlock = ^(float progress) {
        [temp setProgress:progress animated:NO];
    };

    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.webURL];
    [_webView loadRequest:request];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
