//
//  UsedCarsCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "UsedCarsCell.h"

@implementation UsedCarsCell

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

-(void)cellForDic:(UsedCar *)usedCar
{
    [self.asyImageView LoadImage:usedCar.pic];
    self.colorLabel.text = usedCar.yanse;
    self.typeLabel.text = usedCar.pinpai;
    self.displacementLabel.text = usedCar.bsx;
}

- (void)dealloc {
    [_asyImageView release];
    [_typeLabel release];
    [_colorLabel release];
    [_displacementLabel release];
    [super dealloc];
}
@end
