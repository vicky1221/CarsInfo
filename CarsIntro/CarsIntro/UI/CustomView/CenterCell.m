//
//  CenterCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CenterCell.h"

@implementation CenterCell

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

- (void)cellForDic:(MemberCenter *)memberCenter
{
    self.titleLabel.text = memberCenter.title;
    self.sender.text = memberCenter.hits;
    self.timeLabel.text = memberCenter.addtime;
}

- (void)dealloc {
    [_titleLabel release];
    [_sender release];
    [_timeLabel release];
    [super dealloc];
}
@end
