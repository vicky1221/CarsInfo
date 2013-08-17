//
//  MOrderCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MOrderCell.h"

@implementation MOrderCell

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

- (void)cellForDic:(Order *)order
{
    self.nameLabel.text = order.user;
    self.phoneLabel.text = order.phone;
    self.timeLabel.text = order.time;
    self.itemLabel.text = order.type;
    self.stateLabel.text = order.title;
}

- (void)dealloc {
    [_nameLabel release];
    [_phoneLabel release];
    [_timeLabel release];
    [_itemLabel release];
    [_stateLabel release];
    [super dealloc];
}
@end
