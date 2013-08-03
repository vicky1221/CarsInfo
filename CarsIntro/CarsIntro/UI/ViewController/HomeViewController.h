//
//  HomeViewController.h
//  CarsIntro
//
//  Created by banshenggua03 on 6/24/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "XLCycleScrollView.h"

@interface HomeViewController : KBaseViewController <XLCycleScrollViewDatasource>
@property (nonatomic, assign) IBOutlet XLCycleScrollView *xlCycleScrollView;
@property (nonatomic, assign) IBOutlet UIView *contentView;
@property (assign) BOOL isLogin;
@property (nonatomic, assign) IBOutlet UIView *homeView;
@property (nonatomic, assign) IBOutlet UIImageView *homeViewbackImage;

@end
