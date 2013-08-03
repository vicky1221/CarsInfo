//
//  TypeCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleType.h"
#import "UIAsyncImageView.h"

@interface TypeCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *priceLabel;

@property (retain, nonatomic) IBOutlet UILabel *gearboxLabel;

@property (retain, nonatomic) IBOutlet UILabel *displacement;
@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;


- (void)cellForDic:(VehicleType *)vehicleType;

@end
