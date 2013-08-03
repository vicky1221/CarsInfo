//
//  VehicleType.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleType : NSObject

//车型信息
//id:"编号",title:"标题",zdj:"指导价",bsx:"变速箱",pl:"排量",zb:"质保",zhgkhy:"综合工况耗油",cj:"厂家",ctjg:"车体结构",pic:"图片1|图片2"
@property (nonatomic, copy) NSString * vehicleTypeId;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * price;   //指导价
@property (nonatomic, copy) NSString * gearbox; //变速箱
@property (nonatomic, copy) NSString * displacement; //排量
@property (nonatomic, copy) NSString * qualityQuarantee; //质保
@property (nonatomic, copy) NSString * oilConsumption; //综合工况耗油
@property (nonatomic, copy) NSString * manufacturers; //厂家
@property (nonatomic, copy) NSString * structure; //车体结构
@property (nonatomic, copy) NSString * image;

-(void)fromDic:(NSDictionary *)vehicleTypeDic;

@end
