//
//  MOrderCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
@interface MOrderCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@property (retain, nonatomic) IBOutlet UILabel *phoneLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UILabel *itemLabel;

@property (retain, nonatomic) IBOutlet UILabel *stateLabel;

- (void)cellForDic:(Order *)order;

@end
