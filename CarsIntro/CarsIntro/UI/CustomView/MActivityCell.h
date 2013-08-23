//
//  MActivityCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MActivity.h"
@interface MActivityCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *numberLabel;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

- (void)cellForDic:(MActivity *)mactivity;

@end
