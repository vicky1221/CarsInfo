//
//  CarsCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"
#import "VehicleType.h"
@interface CarsCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *typeLable;
@property (retain, nonatomic) IBOutlet UILabel *displacementLabel;

- (void)cellForDic:(VehicleType *)vehicleType;

@end
