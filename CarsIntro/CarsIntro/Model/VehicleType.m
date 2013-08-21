//
//  VehicleType.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "VehicleType.h"
#import "NSDictionary+type.h"
@implementation VehicleType

-(id)init
{
    if (self = [super init]) {
        self.vehicleTypeId = @"";
        self.title = @"";
        self.price = @"";
        self.tid = @"";
        self.addtime = @"";
        self.isshow = @"";
    }
    return self;
}

-(void)dealloc
{
    [_vehicleTypeId release];
    [_title release];
    [_price release];
    [_tid release];
    [_addtime release];
    [_isshow release];
    [super dealloc];
}

//id:"编号",title:"标题",zdj:"指导价",bsx:"变速箱",pl:"排量",zb:"质保",zhgkhy:"综合工况耗油",cj:"厂家",ctjg:"车体结构",pic:"图片1|图片2"
-(void)fromDic:(NSDictionary *)vehicleTypeDic
{
    self.vehicleTypeId = [vehicleTypeDic stringForKey:@"id"];
    self.title = [vehicleTypeDic stringForKey:@"title"];
    self.price = [vehicleTypeDic stringForKey:@"zdj"];
    self.tid = [vehicleTypeDic stringForKey:@"tid"];
    self.addtime = [vehicleTypeDic stringForKey:@"addtime"];
    self.litpic = [NSString stringWithFormat:@"%@%@",ServerAddress ,[vehicleTypeDic stringForKey:@"litpic"]];
}

@end
