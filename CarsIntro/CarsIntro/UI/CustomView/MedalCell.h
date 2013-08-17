//
//  MedalCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medal.h"

@interface MedalCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *title;

@property (retain, nonatomic) IBOutlet UILabel *user;

@property (retain, nonatomic) IBOutlet UILabel *time;

- (void)cellForDic:(Medal *)medal;

@end
