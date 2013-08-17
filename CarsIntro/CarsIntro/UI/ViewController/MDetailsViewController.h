//
//  MDetailsViewController.h
//  CarsIntro
//
//  Created by cs on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "Medal.h"
@interface MDetailsViewController : KBaseViewController

@property (nonatomic ,retain) Medal * medal;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *userLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@end
