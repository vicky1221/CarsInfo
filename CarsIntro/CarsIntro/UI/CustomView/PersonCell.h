//
//  PersonCell.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-31.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"
@interface PersonCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIAsyncImageView *asyImageView;


- (void)cellForDic:(NSDictionary *)dic;

@end
