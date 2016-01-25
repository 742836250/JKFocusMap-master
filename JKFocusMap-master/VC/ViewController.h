//
//  ViewController.h
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/3.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTBView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *setBtn;

- (IBAction)showSetView:(id)sender;

@end

