//
//  JKFocusMapView.h
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/14.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKTestData;
@class JKFocusMapView;

// 加载图片的类型
typedef NS_ENUM(NSUInteger, JKFocusMapVCImageType) {
    
    JKFocusMapVCImageTypeLocal,
    JKFocusMapVCImageTypeNet,
};

// 点击图片所在的cell的回调
typedef void(^ImageClickCallBack)(JKTestData *__nullable obj,JKFocusMapView *__nullable itself);


@interface JKFocusMapView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * _Nonnull focusMapCollectionView;

@property (nonatomic, assign) BOOL showPageControl;

// 定时器间隔
@property (nonatomic, assign) NSTimeInterval timerInterval;

// 定时器滚动UICollectionView动画间隔
@property (nonatomic, assign) NSTimeInterval timerAnimateDuration;

// 初始化方法
- (nonnull id)initWithFrame:(CGRect)frame
                  imageType:(JKFocusMapVCImageType)aImageType
                          items:(nonnull NSArray*)aItems
             imageClickCallBack:(nullable ImageClickCallBack)aImageClickCallBack;

// 刷新focusMapView
- (void)reloadFocusMapView;

// 创建定时器
- (void)createTimer;

// 定时器由暂停转为继续
- (void)continueTimer;

// 暂停定时器
- (void)pauseTimer;

//销毁定时器
- (void)destroyTimer;

@end


@interface JKFocusMapCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *_Nonnull focusMapIamgeView;

@property (nonatomic, strong) UILabel *_Nonnull textLab;

@end
