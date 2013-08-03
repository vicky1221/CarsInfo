//
//  SetCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (retain, nonatomic) IBOutlet UILabel *label;

- (void)cellForDic:(NSDictionary *)dic;

@end
