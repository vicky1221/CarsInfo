//
//  MActivityCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MActivityCell.h"

@implementation MActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)cellForDic:(MActivity *)mactivity
{
    self.timeLabel.text = mactivity.useTime;
    self.titleLabel.text = mactivity.title;
    self.numberLabel.text = mactivity.yhjId;
}

- (void)dealloc {
    [_titleLabel release];
    [_numberLabel release];
    [_timeLabel release];
    [super dealloc];
}
@end
