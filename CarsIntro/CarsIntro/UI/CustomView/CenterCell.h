//
//  CenterCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberCenter.h"
@interface CenterCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *sender;

@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

- (void)cellForDic:(MemberCenter *)memberCenter;

@end
