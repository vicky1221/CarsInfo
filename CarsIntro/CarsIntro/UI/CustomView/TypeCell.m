//
//  TypeCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "TypeCell.h"

@implementation TypeCell

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

-(void)cellForDic:(VehicleType *)vehicleType
{
    _titleLabel.text = vehicleType.title;
    _priceLabel.text = vehicleType.price;
    _gearboxLabel.text = vehicleType.gearbox;
    _displacement.text = vehicleType.displacement;
    _asyImageView.image = [UIImage imageNamed:vehicleType.image];
}

- (void)dealloc {
    [_titleLabel release];
    [_priceLabel release];
    [_gearboxLabel release];
    [_displacement release];
    [_asyImageView release];
    [super dealloc];
}
@end
