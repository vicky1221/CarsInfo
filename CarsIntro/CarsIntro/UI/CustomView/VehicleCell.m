//
//  VehicleCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "VehicleCell.h"

@implementation VehicleCell

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

-(void)cellForDic:(Parameter *)parameter
{
    self.titleLabel.text = parameter.title;
    self.contentLabel.text = parameter.content;
}


- (void)dealloc {
    [_titleLabel release];
    [_contentLabel release];
    [super dealloc];
}
@end
