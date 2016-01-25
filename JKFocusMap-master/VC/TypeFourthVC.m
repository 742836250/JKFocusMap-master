//
//  TestVC.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/14.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "TypeFourthVC.h"
#import "JKFocusMapView.h"
#import "JKTextModelHeader.h"
#import "JKWebViewController.h"

#define WEAKSELF __weak __typeof(&*self)weakSelf = self;

@interface TypeFourthVC ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>



@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) JKFocusMapView *focusMapView;

@property (weak, nonatomic) IBOutlet UITableView *textTBView;

@end

static NSString *textTBViewCellReuseIdentifier = @"textTBViewCellReuseIdentifier";

static NSString *headerFooterReuseIdentifier = @"HeaderFooterReuseIdentifier";

@implementation TypeFourthVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    JKTestModel *model = [[JKTestModel alloc] initWithDictionary:[self readLocalModels]];
    
    self.items = model.data;
    
    [self performSelector:@selector(showFocusMapViewWithItems:) withObject:model.data afterDelay:0.2];
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
- (NSDictionary *)readLocalModels
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"TextModel" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error)
    {
        return nil;
    }
    return dic;
}

#pragma mark UITableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
            if (!cell)
            {
                WEAKSELF
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell0"];
                JKFocusMapView *focusMapView =  (JKFocusMapView*)[[JKFocusMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),200) imageType:JKFocusMapVCImageTypeNet items:self.items imageClickCallBack:^(JKTestData * _Nullable obj,JKFocusMapView *itself) {
                    
                    
                    JKWebViewController *webVC = [[JKWebViewController alloc] init];
                    webVC.webURL = [NSURL URLWithString:obj.skipURL];
                    [weakSelf.navigationController pushViewController:webVC animated:YES];
                }];
                [cell.contentView addSubview:focusMapView];
            }
            
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"section %ld index %ld",(long)indexPath.section,(long)indexPath.row];
            
        }

    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"section %ld index %ld",(long)indexPath.section,(long)indexPath.row];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [[UIView alloc] init];
    }
    else
    {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterReuseIdentifier];
        if (!headerView)
        {
            WEAKSELF
            headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerFooterReuseIdentifier];
            
            JKFocusMapView *focusMapView = [[JKFocusMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),200) imageType:JKFocusMapVCImageTypeNet items:self.items imageClickCallBack:^(JKTestData * _Nullable obj,JKFocusMapView *itself) {
                
                
                JKWebViewController *webVC = [[JKWebViewController alloc] init];
                webVC.webURL = [NSURL URLWithString:obj.skipURL];
                [weakSelf.navigationController pushViewController:webVC animated:YES];
            }];
            [headerView addSubview:focusMapView];
        }
        return headerView;

    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 200;
        }
        else
        {
            return 64;
        }
    }
    else
    {
        return 64;
    }
   
}

- (void)showFocusMapViewWithItems:(NSArray *)aItems
{
    WEAKSELF
    self.focusMapView = [[JKFocusMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 200) imageType:JKFocusMapVCImageTypeNet items:aItems imageClickCallBack:^(JKTestData * _Nullable obj,JKFocusMapView *itself) {
        
        
        JKWebViewController *webVC = [[JKWebViewController alloc] init];
        webVC.webURL = [NSURL URLWithString:obj.skipURL];
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }];
    self.focusMapView.showPageControl = NO;
    self.focusMapView.timeInterval = 10;
    [self.view addSubview:self.focusMapView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
    [self.focusMapView destroyTimer];
}

@end
