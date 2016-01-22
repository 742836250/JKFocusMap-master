//
//  ViewController.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/3.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "ViewController.h"
#import "BaseVC.h"
#import "JKFocusMapSetView.h"

#define IMAGE_CONTROL_TAG 1008611
#define PAGECONTROL_TAG 10010

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) JKFocusMapVCImageType imageType;
@property (nonatomic, assign) BOOL showPageControl;
@property (nonatomic, assign) NSInteger timerInterval;
@property (nonatomic, assign) CGFloat timerAnimateDuration;
@property (nonatomic, assign) BOOL isBack;
@property (nonatomic, strong) JKFocusMapSetView *setView;

@end

static NSString *listTBViewCellReuseIdentifier = @"listTBViewCellReuseIdentifier";

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageType = JKFocusMapVCImageTypeNet;
    self.showPageControl = YES;
    [self.listTBView registerClass:[UITableViewCell class] forCellReuseIdentifier:listTBViewCellReuseIdentifier];
    self.listTBView.tableFooterView = [[UIView alloc] init];
    self.dataArray = [self readLocalModels];
}
- (NSArray *)readLocalModels
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"VCName" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
    return array;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listTBViewCellReuseIdentifier];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [[dic allKeys] objectAtIndex:0];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:25];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcName = [[[self.dataArray objectAtIndex:indexPath.row] allValues] objectAtIndex:0];
    Class viewController = [NSClassFromString(vcName) class];
    UIViewController *testVC = [viewController new];
    BaseVC *baseVC = (BaseVC *)testVC;
    baseVC.imageType = self.imageType;
    baseVC.showPageControl = self.showPageControl;
    baseVC.timerInterval = self.timerInterval;
    baseVC.timerAnimateDuration = self.timerAnimateDuration;
    [self.navigationController pushViewController:testVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isBack)
    {
        [self.setBtn setTitle:@"设置"];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.setView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.setView.frame));
        } completion:^(BOOL finished) {
            
            self.setView.hidden = YES;
        }];
        self.isBack = NO;
    }

}
- (IBAction)showSetView:(id)sender
{
    CGFloat setView_height = 230;
    self.isBack = !self.isBack;
    if (self.isBack)
    {
        if (self.setView)
        {
            self.setView.hidden = NO;
        }
        else
        {
            NSArray *nib =  [[NSBundle mainBundle]loadNibNamed:@"JKFocusMapSetView" owner:self options:nil];
            self.setView = (JKFocusMapSetView *)[nib objectAtIndex:0];
            [self configureSetView];
            [self.view addSubview:self.setView];
        }
        [self.setBtn setTitle:@"返回"];
        
        self.setView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, setView_height);
        [UIView animateWithDuration:0.2 animations:^{
            
            self.setView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - setView_height    , self.view.bounds.size.width,setView_height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        
        [self.setBtn setTitle:@"设置"];
        
        [UIView animateWithDuration:0.2 animations:^{
            
           self.setView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, setView_height);
        } completion:^(BOOL finished) {
            
            self.setView.hidden = YES;
        }];
        
    }
    
  
}

- (void)configureSetView
{
    self.setView.backgroundColor = [[UIColor alloc] initWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.3];
    self.timerInterval = [self.setView.timerTF.text
                          integerValue];
    self.timerAnimateDuration = [self.setView.animateTF.text floatValue];
    
    self.setView.imageTypeControl.tag = IMAGE_CONTROL_TAG;
    self.setView.showPageControlControl.tag = PAGECONTROL_TAG;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,  [UIFont fontWithName:@"SnellRoundhand-Bold"size:25],NSFontAttributeName,nil];
    [self.setView.imageTypeControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self.setView.showPageControlControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    [self setSetViewSubViewsTarget];

}
- (void)setSetViewSubViewsTarget
{
    [self.setView.timerPlusBtn addTarget:self action:@selector(timerPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setView.timerMinusSignBtn addTarget:self action:@selector(timerMinusSignBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setView.animatePlusBtn addTarget:self action:@selector(animatePlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setView.animateMinusSignBtn addTarget:self action:@selector(animateMinusSignBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.setView.imageTypeControl addTarget:self action:@selector(imageTypeControlClick:) forControlEvents:UIControlEventValueChanged];
    [self.setView.showPageControlControl addTarget:self action:@selector(imageTypeControlClick:) forControlEvents:UIControlEventValueChanged];
}

- (void)timerPlusBtnClick:(UIButton *)sender
{
    if (self.timerInterval<10)
    {
        self.timerInterval++;
        self.setView.timerTF.text = [NSString stringWithFormat:@"%ld",(long)self.timerInterval];
    }
}

- (void)timerMinusSignBtnClick:(UIButton *)sender
{
    if (self.timerInterval>2)
    {
        self.timerInterval--;
         self.setView.timerTF.text = [NSString stringWithFormat:@"%ld",(long)self.timerInterval];
    }
    
}

- (void)animatePlusBtnClick:(UIButton *)sender
{
    if (self.timerAnimateDuration<self.timerInterval)
    {
        self.timerAnimateDuration+=0.2;
        self.setView.animateTF.text = [NSString stringWithFormat:@"%.2f",self.timerAnimateDuration];
    }
}

- (void)animateMinusSignBtnClick:(UIButton *)sender
{
    if (self.timerAnimateDuration>0.4)
    {
        self.timerAnimateDuration-=0.2;
        self.setView.animateTF.text = [NSString stringWithFormat:@"%.2f",self.timerAnimateDuration];
    }
    
}

- (void)imageTypeControlClick:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        if (segmentedControl.tag == IMAGE_CONTROL_TAG)
        {
            self.imageType = JKFocusMapVCImageTypeNet;
        }
        else
        {
            self.showPageControl = YES;
        }
    }
    else
    {
        if (segmentedControl.tag == IMAGE_CONTROL_TAG)
        {
            self.imageType = JKFocusMapVCImageTypeLocal;
        }
        else
        {
            self.showPageControl = NO;
            
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
