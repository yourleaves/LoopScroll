//
//  RBBannerView.m
//  RBBannerView
//
//  Created by ren on 8/31/16.
//  Copyright © 2016 ren. All rights reserved.
//

#import "RBBannerView.h"
#import "RBBannerScrollView.h"
#import "RBPageControl.h"

@interface RBBannerView ()

@property (nonatomic, strong) RBBannerScrollView        *bannerScrollView;
@property (nonatomic, strong) RBPageControl             *pageControl;
@property (nonatomic, assign, readonly) NSInteger       curPage;
/**
 图片切换时间
 */
@property (nonatomic, assign, readonly) CGFloat         time;
@property (nonatomic, strong, readonly) NSMutableArray  *items;

@end

@implementation RBBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addPageControl];
        [self addScrollView];
        [self addSubview:_pageControl];
        [self addTapGesture];
    }
    return self;
}

- (void)addTapGesture
{
    UITapGestureRecognizer *panGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    panGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:panGesture];
}

#pragma mark - set data

- (void)setItems:(NSMutableArray *)items time:(CGFloat)time
{
    if (![_items isEqual:items] || _time != time) {
        _curPage = 0;
        _items = items;
        _time = time;
        [self.bannerScrollView setItems:self.items time:time];
        [_pageControl setNumberOfPages:[self.items count]];
    }
}

#pragma mark - add views

- (void)addScrollView
{
    self.bannerScrollView = [[RBBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    __weak typeof(self) weakSelf = self;
    self.bannerScrollView.currentPage = ^(NSInteger currentPage){
        __strong typeof(self) strongSelf = weakSelf;
        _curPage = currentPage;
        if (strongSelf.pageControl) {
            [strongSelf.pageControl setCurrentPage:currentPage];
        }
    };
    [self addSubview:self.bannerScrollView];
}
- (void)addPageControl
{
    _pageControl = [[RBPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 8)];
    [_pageControl setSize:CGSizeMake(6, 6)];
    [_pageControl setCurrentSelectColor:[UIColor whiteColor]];
    [_pageControl setCurrentUnSelectColor:[UIColor grayColor]];
    [_pageControl setIsHasBorder:NO];
    [_pageControl setHidesForSinglePage:YES];
    [_pageControl setUserInteractionEnabled:NO];
    [_pageControl setCurrentPage:0];
}

#pragma mark - click action

- (void)clickAction
{
    if (self.currentClick) {
        self.currentClick(_curPage);
    }
}

@end
