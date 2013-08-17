//
//  KBaseTableView.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/16/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseTableView.h"

@implementation KBaseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    [_egoRefreshHeadView release];
    [super dealloc];
}

#pragma mark -ego

- (void)createEGOHead {
	CGRect rect = CGRectMake(0, 0 - self.bounds.size.height, self.frame.size.width, self.bounds.size.height);
	if (!_egoRefreshHeadView) {
		_egoRefreshHeadView = [[EGORefreshTableHeaderView alloc] initWithFrame:rect];
		_egoRefreshHeadView.hidden = NO;
		self.tableHeaderView.hidden = NO;
		_egoRefreshHeadView.delegate = self;
		[self addSubview:_egoRefreshHeadView];
	}
}

- (void)createEGOHead:(id<EGORefreshTableHeaderDelegate>)delegate
{
	[self createEGOHead];
	_egoRefreshHeadView.delegate = delegate;
}

- (void)removeEGOHead {
	[_egoRefreshHeadView removeFromSuperview];
	self.egoRefreshHeadView = nil;
}

#pragma mark - UISCrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_egoRefreshHeadView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_egoRefreshHeadView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)finishEGOHead {
	[_egoRefreshHeadView performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:self afterDelay:0.05];
}


#pragma mark - EGOHeader EGOTail Delegate
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	return [self.kdelegate shouldEgoHeadLoading:self];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	[self.kdelegate triggerEgoHead:self];
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
	return [NSDate date];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
