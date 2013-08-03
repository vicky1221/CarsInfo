//
//  ActivitiesCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-10.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"
#import "Activity.h"
@interface ActivitiesCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *footLabel;

-(void)cellForDic:(Activity *)activity;

@end
