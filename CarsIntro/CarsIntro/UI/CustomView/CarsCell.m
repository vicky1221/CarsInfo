//
//  CarsCell.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CarsCell.h"

@implementation CarsCell

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

//@property (nonatomic, copy) NSString * vehicleTypeId;
//@property (nonatomic, copy) NSString * title;
//@property (nonatomic, copy) NSString * price;   //指导价
//@property (nonatomic, copy) NSString * gearbox; //变速箱
//@property (nonatomic, copy) NSString * displacement; //排量
//@property (nonatomic, copy) NSString * qualityQuarantee; //质保
//@property (nonatomic, copy) NSString * oilConsumption; //综合工况耗油
//@property (nonatomic, copy) NSString * manufacturers; //厂家
//@property (nonatomic, copy) NSString * structure; //车体结构
//@property (nonatomic, copy) NSString * image;

-(void)cellForDic:(VehicleType *)vehicleType
{
//  [self.asyImageView LoadImage:[dic objectForKey:@"image"]];
//  _typeLable.text = [dic objectForKey:@"type"];
    self.asyImageView.image = [UIImage imageNamed:vehicleType.image];
    _titleLabel.text = vehicleType.title;
    _priceLabel.text = vehicleType.price;
    _displacementLabel.text = vehicleType.displacement;
}

- (void)dealloc {
    [_asyImageView release];
    [_titleLabel release];
    [_priceLabel release];
    [_typeLable release];
    [_displacementLabel release];
    [super dealloc];
}
@end
