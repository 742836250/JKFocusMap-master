//
//  BaseVC.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/15.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self)
    {
        // View is disappearing because a new view controller was pushed onto the stack
        NSLog(@"New view controller was pushed");
    }
    else if ([viewControllers indexOfObject:self] == NSNotFound)
    {
        // View is disappearing because it was popped from the stack
        NSLog(@"View controller was popped");
    }
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if (self.imageType == JKFocusMapVCImageTypeNet)
    {
        JKTestModel *model = [[JKTestModel alloc] initWithDictionary:[self readLocalModels]];
        self.items = model.data;
    }
    else
    {
        self.items = [self readLocalModels];
    }
    self.focusMapView = [self createFocusMapViewWithItems:self.items];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        if (gestureRecognizer ==  self.navigationController.interactivePopGestureRecognizer)
        {
            if ([touch.view isKindOfClass:[JKFocusMapView class]])
            {
                
                return NO;
                
            }
            
            return YES;
            
        }
        
    }
    return YES;
}
- (id)readLocalModels
{
    if (self.imageType == JKFocusMapVCImageTypeNet)
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"NetTextModel" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:fileName];
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error)
        {
            return nil;
        }
        return dic;
    }
    else
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"LocalImageName" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
        
        return array;
    }
   
}

- (JKFocusMapView *)createFocusMapViewWithItems:(NSArray *)aItems
{
    WEAKSELF
    JKFocusMapView *focusMapView = [[JKFocusMapView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) imageType:self.imageType items:aItems imageClickCallBack:^(JKTestData * _Nullable obj,JKFocusMapView *itself) {
        
        JKWebViewController *webVC = [[JKWebViewController alloc] initWithPopCallBack:^{
            
            [itself continueTimer];
            
        }];
        webVC.webURL = [NSURL URLWithString:obj.skipURL];
        [itself pauseTimer];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }];
    focusMapView.timerInterval = self.timerInterval;
    focusMapView.showPageControl = self.showPageControl;
    focusMapView.timerAnimateDuration = self.timerAnimateDuration;
    return focusMapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}
- (void)dealloc
{
    [self.focusMapView destroyTimer];
    self.focusMapView = nil;
    [self.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    NSLog(@"%@ dealloc",[self class]);
}

@end
