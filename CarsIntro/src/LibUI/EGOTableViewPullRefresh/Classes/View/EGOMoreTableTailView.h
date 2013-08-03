//
//  EGOMoreTableTailView.h
//  Demo
//
//  Created by Liangjin.Peng on 12/06/10.
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPushMorePushing = 0,
	EGOOPushMoreNormal,
	EGOOPushMoreLoading,	
} EGOPushMoreState;

@protocol EGOMoreTableTailDelegate;
@interface EGOMoreTableTailView : UIView {
	
	id _delegate;
	EGOPushMoreState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) IBOutlet id <EGOMoreTableTailDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)egoMoreScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoMoreScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol EGOMoreTableTailDelegate
- (void)egoMoreTableTailDidTriggerMore:(EGOMoreTableTailView*)view;
- (BOOL)egoMoreTableTailDataSourceIsLoading:(EGOMoreTableTailView*)view;
@optional
- (NSDate*)egoMoreTableTailDataSourceLastUpdated:(EGOMoreTableTailView*)view;
@end
