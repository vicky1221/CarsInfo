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
@property (nonatomic, retain) NSString * vehicleTypeId;
@property (nonatomic, retain) NSString * tid;
@property (nonatomic, retain) NSString * addtime;
@property (nonatomic ,retain) NSString * isshow;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * litpic;

-(void)fromDic:(NSDictionary *)vehicleTypeDic;

@end
