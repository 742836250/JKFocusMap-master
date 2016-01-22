//
//  TypeSecondVC.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/15.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "TypeSecondVC.h"

@interface TypeSecondVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *textTBView;

@end

static NSString *textTBViewCellZeroCellReuseIdentifier = @"textTBViewCellZeroCellReuseIdentifier";
static NSString *textTBViewCellOtherCellReuseIdentifier = @"textTBViewCellOtherCellReuseIdentifier";




@implementation TypeSecondVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.textTBView reloadData];
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
    UITableViewCell *cell = nil;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:textTBViewCellZeroCellReuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:textTBViewCellZeroCellReuseIdentifier];
            [cell.contentView addSubview:self.focusMapView];
        }
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:textTBViewCellOtherCellReuseIdentifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:textTBViewCellOtherCellReuseIdentifier];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"section %ld index %ld",(long)indexPath.section,(long)indexPath.row];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return CGRectGetHeight(self.focusMapView.frame);
    }
    else
    {
        return 64;
    }
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
