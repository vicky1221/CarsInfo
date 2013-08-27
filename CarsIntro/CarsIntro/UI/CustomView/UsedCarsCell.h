//
//  UsedCarsCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"
#import "UsedCar.h"
@interface UsedCarsCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;

@property (retain, nonatomic) IBOutlet UILabel *typeLabel;

@property (retain, nonatomic) IBOutlet UILabel *colorLabel;

@property (retain, nonatomic) IBOutlet UILabel *displacementLabel;

- (void)cellForDic:(UsedCar *)usedCar;

@end
