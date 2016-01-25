//
//  JKFocusMapSetView.h
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/22.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKFocusMapSetView : UIView
@property (weak, nonatomic) IBOutlet UISegmentedControl *imageTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *showPageControlControl;
@property (weak, nonatomic) IBOutlet UIButton *timerPlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *timerMinusSignBtn;
@property (weak, nonatomic) IBOutlet UIButton *animatePlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *animateMinusSignBtn;
@property (weak, nonatomic) IBOutlet UITextField *timerTF;
@property (weak, nonatomic) IBOutlet UITextField *animateTF;

@end
