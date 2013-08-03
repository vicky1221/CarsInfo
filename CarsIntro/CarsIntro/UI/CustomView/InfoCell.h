//
//  InfoCell.h
//  CarsIntro
//
//  Created by Cao Vicky on 6/26/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAsyncImageView.h"
#import "Information.h"

@interface InfoCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) IBOutlet UIAsyncImageView *asyImageView;

- (void)cellForDic:(Information *)info;

@end
