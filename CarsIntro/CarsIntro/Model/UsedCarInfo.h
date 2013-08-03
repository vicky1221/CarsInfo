//
//  UsedCarInfo.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedCarInfo : NSObject

//二手车列表

//"id": "1",
//"tid": "26",
//"title": "weqewq",
//"style": "",
//"trait": "",
//"gourl": "",
//"addtime": "1374826620",
//"hits": "0",
//"orders": "0",
//"mrank": "0",
//"mgold": "0",
//"isshow": "1",
//"description": "",
//"htmlurl": "",
//"htmlfile": "",
//"user": "admin",
//"url": "/qiche/channel/esc/11.html"


//二手车信息
//id:"编号",pinpai :"品牌" ,"yanse :" 颜色" ,"bsx :" 变速箱" ,"xslc :" 行驶里程" ,"spsj :" 上牌时间" ,"xxms :" 详细描述","lxr :" 联系人","lxdh :" 联系电话"
@property (nonatomic, copy) NSString * usedCarInfoId;
@property (nonatomic, copy) NSString * usedCarTid;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * addTime;
@property (nonatomic, copy) NSString * hits;
@property (nonatomic, copy) NSString * orders;
@property (nonatomic, copy) NSString * mrank;
@property (nonatomic, copy) NSString * mgold;
@property (nonatomic, copy) NSString * isshow;
@property (nonatomic, copy) NSString *user; //"user" : "admin"

//@property (nonatomic, copy) NSString * color;
//@property (nonatomic, copy) NSString * gearbox; //变速箱
//@property (nonatomic, copy) NSString * travlledDistance; //行驶里程
//@property (nonatomic, copy) NSString * time; //上牌时间
//@property (nonatomic, copy) NSString * description; //详细描述
//@property (nonatomic, copy) NSString * linkman; //联系人
//@property (nonatomic, copy) NSString * phone; //联系电话

-(void)fromDic:(NSDictionary *)usedCarInfoDic;

@end
