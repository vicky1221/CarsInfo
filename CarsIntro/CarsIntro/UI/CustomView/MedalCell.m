//
//  MedalCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MedalCell.h"

@implementation MedalCell

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

-(void)cellForDic:(Medal *)medal
{
    self.title.text = medal.title;
    self.time.text = medal.addtime;
    self.user.text = medal.user;
}

- (void)dealloc {
    [_title release];
    [_user release];
    [_time release];
    [super dealloc];
}
@end
