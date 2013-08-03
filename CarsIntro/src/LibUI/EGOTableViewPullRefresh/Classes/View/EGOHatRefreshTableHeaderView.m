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

#import "EGOHatRefreshTableHeaderView.h"

//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR	 [UIColor colorWithRed:126.0/255.0 green:116.0/255.0 blue:144.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
//#define _hatHeight 41

@interface EGOHatRefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGOHatRefreshTableHeaderView

//@synthesize delegate=_delegate;
@synthesize hatView = _hatView;

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
	UIImage *image = [UIImage imageNamed:@"egoPullRefreshBackground"];
	NSInteger heighHat = CGRectGetHeight(_hatView.frame);
	
    frame = CGRectMake(0, -image.size.height, image.size.width, image.size.height);
	self = [super initWithFrame:frame arrowImageName:arrow textColor:textColor];
//	_hatView.frame = CGRectMake(0, self.frame.size.height - _hatView.frame.size.height, _hatView.frame.size.width, _hatView.frame.size.height);
	_hatHeight = _hatView.frame.size.height;
	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:10];
	for (UIView * _tmp in self.subviews) {
		_tmp.frame = CGRectMake(_tmp.frame.origin.x, _tmp.frame.origin.y - _hatHeight, _tmp.frame.size.width, _tmp.frame.size.height);
		[arr addObject:_tmp];
	}
	for (int i = 0; i < arr.count - 1 ; i++) {
		UIView *viewTmp = [arr objectAtIndex:i];
		[viewTmp removeFromSuperview];
	}
	[arr release];
//	[self addSubview:_hatView];
	
	
//	if((self = [super initWithFrame:frame])) {
		lastRefreshTime = 0.0;
		UIImageView *imageViewBackground = [[UIImageView alloc] initWithImage:image];
		imageViewBackground.frame = CGRectMake(imageViewBackground.frame.origin.x, imageViewBackground.frame.origin.y - heighHat, imageViewBackground.frame.size.width, imageViewBackground.frame.size.height);
		[self addSubview:imageViewBackground];
		[imageViewBackground release];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f - _hatHeight, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f - _hatHeight, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f - _hatHeight, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f - _hatHeight, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		//		// 显示上边的view 此view应该由外面传进来
		//		UIView *_viewTmp = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - _hatHeight, 320, _hatHeight)];
		//		[_viewTmp setBackgroundColor:[UIColor blueColor]];
		//		[self addSubview:_viewTmp];
		//		[_viewTmp release];

		_hatView.frame = CGRectMake(0, self.frame.size.height - _hatView.frame.size.height, _hatView.frame.size.width, _hatView.frame.size.height);
		[self addSubview:_hatView];
		
		[self setState:EGOOPullRefreshNormal];
		
//    }
	
    return self;
	
}

//- (id)initWithFrame:(CGRect)frame  {
//	return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
//}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"更新时间: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
	
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, _hatHeight + 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		//		scrollView.contentInset = UIEdgeInsetsMake(70, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
//		NSLog(@"scrollView.contentOffset.y is %f", scrollView.contentOffset.y);
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > - (_hatHeight +  65.0f) && scrollView.contentOffset.y < _hatHeight && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -(_hatHeight +  65.0f) && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
//		NSLog(@"scrollView.contentInset.top is %f", scrollView.contentInset.top);
		//		if (scrollView.contentInset.top != 0) {
		//			scrollView.contentInset = UIEdgeInsetsZero;
		//		}
		float offset = -scrollView.contentOffset.y;
//		if (offset >= _hatHeight * 2/3 && offset < _hatHeight + 5 && !scrollView.decelerating) {
		if ((offset >= _hatHeight * 2/3 && offset < _hatHeight + 5 && !scrollView.isDragging) || (scrollView.decelerating && offset > _hatHeight)) {
			NSLog(@"大于hat的1/2 %f", scrollView.contentOffset.y);
			scrollView.contentInset = UIEdgeInsetsMake(_hatHeight, 0.0f, 0.0f, 0.0f);
		}
		if (scrollView.contentOffset.y >= 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	float offset = -scrollView.contentOffset.y;

	if (scrollView.contentOffset.y <= - (_hatHeight + 65.0f) && !_loading) { //65.0f
		if (CFAbsoluteTimeGetCurrent() - lastRefreshTime < 7 && lastRefreshTime != 0) {
			NSLog(@"refresh time little then 7");
			[self performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:scrollView afterDelay:1];
		} else {
			
			if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
				[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
			}
			lastRefreshTime = CFAbsoluteTimeGetCurrent();
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(_hatHeight + 75.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	} else 	if (offset >= _hatHeight/2) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(_hatHeight, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		NSLog(@"大于hat的1/2 %f", scrollView.contentOffset.y);
	}
}

- (void)delayFinish:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	//	[scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self setState:EGOOPullRefreshNormal];
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[self performSelector:@selector(delayFinish:) withObject:scrollView afterDelay:0.1];
	
	return;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
//	[scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
	[self setState:EGOOPullRefreshNormal];
}

- (void)autoRefreshDrag:(UIScrollView *)scrollView {
	
	[self setState:EGOOPullRefreshLoading];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[scrollView setContentOffset:CGPointMake(0, -75) animated:NO];
	//	[scrollView setContentOffset:CGPointMake(0, -75)];
	//	scrollView.contentInset = UIEdgeInsetsMake(120.0f, 0.0f, 0.0f, 0.0f);
	//	scrollView.contentInset = UIEdgeInsetsMake(-160.0f, 0.0f, 0.0f, 0.0f);
	[UIView commitAnimations];
	
	//  egoRefreshScrollViewDidEndDragging
	if (CFAbsoluteTimeGetCurrent() - lastRefreshTime < 7 && lastRefreshTime != 0) {
		NSLog(@"refresh time little then 7");
		[self performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading:) withObject:scrollView afterDelay:1];
		//		[self egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
		return;
	}
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
		[_delegate performSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:) withObject:self afterDelay:0.5];
		lastRefreshTime = CFAbsoluteTimeGetCurrent();
	}
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
