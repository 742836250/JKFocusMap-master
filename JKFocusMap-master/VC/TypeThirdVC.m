//
//  TypeThirdVC.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/15.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "TypeThirdVC.h"

@interface TypeThirdVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *textTBView;

@end

static NSString *headerFooterReuseIdentifier = @"HeaderFooterReuseIdentifier";
static NSString *textTBViewCellReuseIdentifier = @"textTBViewCellReuseIdentifier";

@implementation TypeThirdVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textTBView registerClass:[UITableViewCell class] forCellReuseIdentifier:textTBViewCellReuseIdentifier];
}
#pragma mark UITableView Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textTBViewCellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"section %ld index %ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterReuseIdentifier];
    if (!headerView)
    {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerFooterReuseIdentifier];
        [headerView addSubview:self.focusMapView];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGRectGetHeight(self.focusMapView.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.focusMapView pauseTimer];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.focusMapView continueTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.focusMapView continueTimer];
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
