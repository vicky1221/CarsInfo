//
//  CImageViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "UIAsyncImageView.h"
@interface CImageViewController : KBaseViewController<UIGestureRecognizerDelegate>

@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;

@property (retain, nonatomic) IBOutlet UIView *titleView;

@property (assign) BOOL isTitleView;
@end
