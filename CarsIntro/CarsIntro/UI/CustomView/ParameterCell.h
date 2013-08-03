//
//  ParameterCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parameter.h"
@interface ParameterCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

-(void)cellForDic:(Parameter *)parameter;

@end
