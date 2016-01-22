//
//  JKFocusMapView.m
//  JKFocusMap-master
//
//  Created by 王锐锋 on 16/1/14.
//  Copyright © 2016年 jack_wang. All rights reserved.
//

#import "JKFocusMapView.h"
#import "JKTextModelHeader.h"
#import "UIImageView+WebCache.h"

// 定时器默认时间间隔
#define DEFAULT_TIMERINTERVAL 5

// 定时器滚动UICollectionView动画默认时间间隔
#define DEFAULT_TIMER_ANIMATE_DURATION 0.4

@interface JKFocusMapView ()

@property (nonatomic, strong) ImageClickCallBack imageClickCallBack;
@property (nonatomic, assign) JKFocusMapVCImageType imageType;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UIPageControl *cyclePageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL responseScrollViewDidScroll;
@property (nonatomic, assign) BOOL isGesture;
@property (nonatomic, assign) NSInteger dynamicPage;

@end

static NSString *focusMapCollectionViewCellReuseIdentifier = @"focusMapCollectionViewCellReuseIdentifier";

@implementation JKFocusMapView

#pragma mark Public Method
- (nonnull id)initWithFrame:(CGRect)frame
                  imageType:(JKFocusMapVCImageType)aImageType
                      items:(nonnull NSArray*)aItems
         imageClickCallBack:(nullable ImageClickCallBack)aImageClickCallBack
{
    if (self = [super initWithFrame:frame])
    {
        self.timerAnimateDuration = DEFAULT_TIMER_ANIMATE_DURATION;
        self.items = [aItems mutableCopy];
        self.imageType = aImageType;
        self.imageType = aImageType;
        self.imageClickCallBack = aImageClickCallBack;
        self.focusMapCollectionView = [self createFocusMapCollectionView];
        [self configureFocusMapCollectionView];
        self.cyclePageControl = [self createPageControlWithItems:aItems];
    }
    return self;
}
- (void)reloadFocusMapView
{
    if (self.focusMapCollectionView)
    {
        [self.focusMapCollectionView reloadData];
    }
}
#pragma mark Private Method
- (UICollectionView *)createFocusMapCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[JKFocusMapCollectionViewCell class] forCellWithReuseIdentifier:focusMapCollectionViewCellReuseIdentifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.directionalLockEnabled = YES;
    collectionView.pagingEnabled = YES;
    [self addSubview:collectionView];
    return collectionView;
}
- (void)configureFocusMapCollectionView
{
    [self performSelector:@selector(scrollToIndexPath) withObject:nil afterDelay:0];
}
- (void)scrollToIndexPath
{
    self.responseScrollViewDidScroll = YES;
    self.items = [self handleDateSourceWith:self.items];
    [self.focusMapCollectionView reloadData];
    [self.focusMapCollectionView setContentOffset:CGPointMake(self.focusMapCollectionView.frame.size.width, 0) animated:NO];
    self.timerInterval = DEFAULT_TIMERINTERVAL;
   
}
- (NSMutableArray *)handleDateSourceWith:(NSArray *)aItems
{
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObjectsFromArray:aItems];
    [temp insertObject:[aItems lastObject] atIndex:0];
    [temp addObject:[aItems firstObject]];
    return temp;
}
- (UIPageControl *)createPageControlWithItems:(NSArray *)aItems
{
    UIPageControl *cyclePageControl = [[UIPageControl alloc] init];
    CGSize minimumSize = [cyclePageControl sizeForNumberOfPages:aItems.count];
    minimumSize = CGSizeMake(minimumSize.width+20, minimumSize.height);
    
    UIView *pageControlBackView = [[UIView alloc] initWithFrame:CGRectMake( CGRectGetWidth(self.frame)-minimumSize.width, CGRectGetHeight(self.frame)-minimumSize.height, minimumSize.width, minimumSize.height)];
    [self addSubview:pageControlBackView];
    
    cyclePageControl.frame = CGRectMake(0, 0,CGRectGetWidth(pageControlBackView.frame), CGRectGetHeight(pageControlBackView.frame));
    cyclePageControl.numberOfPages = aItems.count;
    cyclePageControl.currentPage = 0;
    cyclePageControl.currentPageIndicatorTintColor = [UIColor redColor];
    cyclePageControl.pageIndicatorTintColor = [UIColor blueColor];
    cyclePageControl.enabled = NO;
    [pageControlBackView addSubview:cyclePageControl];
    
    return cyclePageControl;
}

#pragma mark UICollectionView Method
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JKFocusMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:focusMapCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    id obj = [self.items objectAtIndex:indexPath.row];
    if (self.imageType == JKFocusMapVCImageTypeLocal)
    {
        if ([obj isKindOfClass:[NSString class]])
        {
            cell.focusMapIamgeView.image = [UIImage imageNamed:obj];
            cell.textLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        }
    }
    else if (self.imageType == JKFocusMapVCImageTypeNet)
    {
        if ([obj isKindOfClass:[JKTestData class]])
        {
            JKTestData *model = [self.items objectAtIndex:indexPath.row];
            [cell.focusMapIamgeView sd_setImageWithURL:[NSURL URLWithString:model.imageURL] placeholderImage:[UIImage imageNamed:@"newsDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (!error)
                {
                    model.netImageNoError = YES;
                }
            }];
            cell.textLab.text = model.infor;
        }
        
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //必须在 CGSizeMake(CGRectGetWidth(self.frame) 后加一个数,如果不加调用contentOffset方法时cell会立马重用
    return CGSizeMake(CGRectGetWidth(self.frame)+0.000001, CGRectGetHeight(self.frame));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = [self.items objectAtIndex:indexPath.row];
    if (self.imageType == JKFocusMapVCImageTypeLocal)
    {
      
    }
    else if (self.imageType == JKFocusMapVCImageTypeNet)
    {
        JKTestData *model = (JKTestData *)obj;
        if (model.netImageNoError)
        {
            if (self.imageClickCallBack)
            {
                self.imageClickCallBack (model,self);
            }
            
        }
    }

}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isGesture = YES;
    [self pauseTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.responseScrollViewDidScroll)
    {
        self.dynamicPage = self.focusMapCollectionView.contentOffset.x/self.focusMapCollectionView.frame.size.width;
        //偏移到最后一个视图时,设置一个视图宽度的偏移量强制回到页面刚进来后偏移后的视图(第一张图片)
        if (self.dynamicPage == self.items.count-1)
        {
            if (self.isGesture)
            {
                self.focusMapCollectionView.contentOffset=CGPointMake(self.focusMapCollectionView.frame.size.width, 0);
            }
        }
        //当偏移量为0时强制偏移回到倒数第二个视图(最后一个图片,加小于0为了防止第一张图片向右拖没结束导致下一张拖不出来)
        if (self.focusMapCollectionView.contentOffset.x<=0)
        {
            self.focusMapCollectionView.contentOffset=CGPointMake(self.focusMapCollectionView.frame.size.width*(self.items.count-2), 0);
            
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //在翻页之后变化cyclePageControl.currentPage,往左或右面拖拽一点cyclePageControl.currentPage不会不会变化,但是若连续拖动,直到翻页结束cyclePageControl.currentPage才变化
    NSInteger page =  self.focusMapCollectionView.contentOffset.x/self.frame.size.width;
    self.cyclePageControl.currentPage = page-1;
    [self continueTimer];
}
#pragma mark NSTimer

- (void)createTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval: self.timerInterval target:self selector:@selector(rycleFocusMapCollectionView) userInfo:nil repeats:YES];
}
- (void)pauseTimer
{
    //若timer无效return
    if (![self.timer isValid])
    {
        return ;
    }
    NSLog(@"pauseTimer");
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)continueTimer
{
    //若timer无效return
    if (![self.timer isValid])
    {
        return ;
    }
    NSLog(@"continueTimer");
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.timerInterval]];
}
- (void)destroyTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)rycleFocusMapCollectionView
{
    self.isGesture = NO;
    [UIView animateWithDuration:self.timerAnimateDuration animations:^{
        self.focusMapCollectionView.contentOffset = CGPointMake(self.focusMapCollectionView.contentOffset.x+CGRectGetWidth(self.focusMapCollectionView.frame), 0);
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            if (self.dynamicPage == self.items.count-1)
            {
                self.focusMapCollectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
                self.cyclePageControl.currentPage = 0;
            }
            else
            {
                NSInteger page = self.focusMapCollectionView.contentOffset.x/self.focusMapCollectionView.frame.size.width;
                self.cyclePageControl.currentPage = page-1;
            }
        }
        
    }];
    
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    if (self.cyclePageControl)
    {
        self.cyclePageControl.hidden = !_showPageControl;
    }
   
   
}

- (void)setTimerInterval:(NSTimeInterval)timerInterval
{
    _timerInterval = timerInterval;
    if (self.timer)
    {
        [self destroyTimer];
        [self createTimer];
    }
    else
    {
        [self createTimer];
    }
}

- (void)setTimerAnimateDuration:(NSTimeInterval)timerAnimateDuration
{
    _timerAnimateDuration = timerAnimateDuration;
    if (_timerAnimateDuration == 0)
    {
        _timerAnimateDuration = DEFAULT_TIMER_ANIMATE_DURATION;
    }
}
- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end


@implementation JKFocusMapCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.focusMapIamgeView = [[UIImageView alloc] init];
        self.focusMapIamgeView.contentMode = UIViewContentModeScaleToFill;
        
        self.textLab = [[UILabel alloc] init];
        self.textLab.backgroundColor = [UIColor clearColor];
        self.textLab.textColor = [UIColor blackColor];
        self.textLab.textAlignment = NSTextAlignmentLeft;
        self.textLab.font = [UIFont systemFontOfSize:16.0];
        
        [self.contentView addSubview:self.focusMapIamgeView];
        [self.contentView addSubview:self.textLab];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.focusMapIamgeView.frame = self.contentView.bounds;
    CGFloat textLab_width = 150;
    CGFloat textLab_height = 20;
    CGFloat textLab_bottom = 8;
    CGFloat textLab_left = 8;
    self.textLab.frame = CGRectMake(textLab_left, CGRectGetHeight(self.frame)-textLab_height-textLab_bottom, textLab_width, textLab_height);
}

@end

