//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLCycleScrollViewDelegate;
@protocol XLCycleScrollViewDatasource;
//@class GrayPageControl;

@interface XLCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<XLCycleScrollViewDelegate> _delegate;
    id<XLCycleScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,assign) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) id<XLCycleScrollViewDatasource> datasource;
@property (nonatomic,assign) id<XLCycleScrollViewDelegate> delegate;

@property (nonatomic) BOOL isPageControlHidden;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
// perform在界面释放前要先取消掉
- (void)cancelPerform;

@end

@protocol XLCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol XLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
