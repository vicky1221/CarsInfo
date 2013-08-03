//
//  VehicleType.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "VehicleType.h"

@implementation VehicleType

-(id)init
{
    if (self = [super init]) {
        self.vehicleTypeId = @"";
        self.title = @"";
        self.price = @"";
        self.gearbox = @"";
        self.displacement = @"";
        self.qualityQuarantee = @"";
        self.oilConsumption = @"";
        self.manufacturers = @"";
        self.structure = @"";
        self.image = @"";
    }
    return self;
}

-(void)dealloc
{
    [_vehicleTypeId release];
    [_title release];
    [_price release];
    [_gearbox release];
    [_displacement release];
    [_qualityQuarantee release];
    [_oilConsumption release];
    [_manufacturers release];
    [_structure release];
    [_image release];
    [super dealloc];
}

//id:"编号",title:"标题",zdj:"指导价",bsx:"变速箱",pl:"排量",zb:"质保",zhgkhy:"综合工况耗油",cj:"厂家",ctjg:"车体结构",pic:"图片1|图片2"
-(void)fromDic:(NSDictionary *)vehicleTypeDic
{
    self.vehicleTypeId = [vehicleTypeDic objectForKey:@"id"];
    self.title = [vehicleTypeDic objectForKey:@"title"];
    self.price = [vehicleTypeDic objectForKey:@"zdj"];
    self.gearbox = [vehicleTypeDic objectForKey:@"bsx"];
    self.displacement = [vehicleTypeDic objectForKey:@"pl"];
    self.qualityQuarantee = [vehicleTypeDic objectForKey:@"zb"];
    self.oilConsumption = [vehicleTypeDic objectForKey:@"zhgkhy"];
    self.manufacturers = [vehicleTypeDic objectForKey:@"cj"];
    self.structure = [vehicleTypeDic objectForKey:@"ctjg"];
    self.image = [vehicleTypeDic objectForKey:@"pic"];
}

@end
