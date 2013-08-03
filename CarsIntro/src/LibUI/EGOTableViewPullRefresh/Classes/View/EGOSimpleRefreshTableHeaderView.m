//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOSimpleRefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define TRIGER_HEIGHT 70.0f
#define CIRCLE_FRAME_Y 20.0f

@interface EGOSimpleRefreshTableHeaderView (Private)
- (void)setState:(EGOSimplePullRefreshState)aState;
@end

@implementation EGOSimpleRefreshTableHeaderView

@synthesize delegate=_delegate;
@synthesize _scrollView;
@synthesize offsetHeight = _offsetHeight;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		self.backgroundColor = [UIColor clearColor];
	
		_circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 580 - CIRCLE_FRAME_Y, 30, 30)]; // 416
		_circleImageView.image = [UIImage imageNamed:@"refreshCircle"];
		[self addSubview:_circleImageView];
		[self setState:EGOOSimplePullRefreshNormal];
    }
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)setState:(EGOSimplePullRefreshState)aState{
	
	switch (aState) {
		case EGOOSimplePullRefreshPulling:
			break;
		case EGOOSimplePullRefreshNormal:
			break;
		case EGOOSimplePullRefreshLoading:
			break;
		default:
			break;
	}
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	self._scrollView = scrollView;
	_oldOffsetY = _nowOffsetY;
	_nowOffsetY = scrollView.contentOffset.y;
//	NSLog(@"0000 old is %d now is %d", _oldOffsetY, _nowOffsetY);

	if (_state == EGOOSimplePullRefreshLoading) {
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOSimplePullRefreshPulling && scrollView.contentOffset.y > (-65.0f + _offsetHeight) && scrollView.contentOffset.y < (0.0f + _offsetHeight) && !_loading) {
			[self setState:EGOOSimplePullRefreshNormal];
		} else if (_state == EGOOSimplePullRefreshNormal && scrollView.contentOffset.y < (-65.0f + _offsetHeight) && !_loading) {
			[self setState:EGOOSimplePullRefreshPulling];
		}
	}
	[self rotateCircle];
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	self._scrollView = scrollView;
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= (-65.0f + _offsetHeight) && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
	
		[self setState:EGOOSimplePullRefreshLoading];
		[self startTimer];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[self closeTimer];
	self._scrollView = scrollView;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25f];
	_circleImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (M_PI * 2));
	[self setState:EGOOSimplePullRefreshNormal];
	[UIView commitAnimations];
}

#pragma mark - 旋转频率

- (void)rotateCircle {
	static int i = 0;
	float scale_ = 2;  //旋转速率

	/** 遂offsetY的移动方向判断是逆时针还是顺时针 */
	if (_oldOffsetY > _nowOffsetY) {
		i += scale_;
		_offSetUp = NO;
	} else if (_oldOffsetY < _nowOffsetY) {
		i -= scale_;
		_offSetUp = YES;
	} else if (_oldOffsetY == _nowOffsetY) {
		// 滚动慢时，会出现_oldOffsetY与_nowOffsetY相等的情况
		if (_offSetUp)
			i -= scale_;
		else
			i += scale_;
	}
	
	/** 每次旋转 1 * M_PI/radian  
		旋转一圈需要走的步骤为 1 * M_PI/radian , 2 * M_PI/radian ... M_PI/radian ... 2 * M_PI
		如需逆时针旋转，则每次旋转时乘以-1
	 */
	int radian = 32;  // 每次旋转 1 * M_PI/radian
	int divisor = radian * 2; // 除数 因为360°需要乘2
	int temp = i % divisor + 1; // 因为结果为i % divisor的结果为 0~divisor-1的一个值，所以需要加1
	float result = temp * -1.0f / radian;  //  1/radian, 2/radian ... 2
	//
	
	CGAffineTransform t;
	// offset大于TRIGER_HEIGHT或者loading时，_scrollView相对于屏幕的坐标不变. 
//	if (_scrollView.contentOffset.y < -TRIGER_HEIGHT || (_state == EGOOSimplePullRefreshLoading)) {
	if (_state == EGOOSimplePullRefreshLoading || _scrollView.contentOffset.y - _offsetHeight < -TRIGER_HEIGHT) {
//	if (_state == EGOOSimplePullRefreshLoading) {
		t = CGAffineTransformMakeTranslation(0, _scrollView.contentOffset.y + TRIGER_HEIGHT - _offsetHeight);
	} else {
		t = CGAffineTransformMakeTranslation(0, 0);
	}
	//	_circleImageView.layer.transform = CATransform3DMakeRotation((M_PI * result), 0.0f, 0.0f, 1.0f);
	_circleImageView.transform = CGAffineTransformRotate(t, (M_PI * result));

}

#pragma mark - 定时器控制
- (void)startTimer {
	[_timer invalidate];
	[_timer release];
	_timer = [[NSTimer scheduledTimerWithTimeInterval:0.018f target:self selector:@selector(rotateCircle) userInfo:nil repeats:YES] retain];
}

- (void)closeTimer {
	[_timer invalidate];
	[_timer release];
	_timer = nil;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}

@end