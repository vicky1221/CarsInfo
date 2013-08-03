//
//  PersonCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-31.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

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

-(void)cellForDic:(NSDictionary *)dic
{
    self.asyImageView.image = [UIImage imageNamed:[dic objectForKey:@"KEY_IMAGE"]];
}

- (void)dealloc {
    [_asyImageView release];
    [super dealloc];
}


@end
