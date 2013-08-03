//
//  UsedCarInfo.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "UsedCarInfo.h"
#import "NSDictionary+type.h"
@implementation UsedCarInfo

-(id)init
{
    if (self = [super init]) {
        self.usedCarInfoId = @"";
        self.usedCarTid = @"";
        self.title = @"";
        self.addTime = @"";
        self.hits = @"";
        self.orders = @"";
        self.mrank = @"";
        self.mgold = @"";
        self.isshow = @"";
        self.user = @"";
    }
    return self;
}

-(void)dealloc
{
    [_usedCarInfoId release];
    [_usedCarTid release];
    [_title release];
    [_addTime release];
    [_hits release];
    [_orders release];
    [_mrank release];
    [_mgold release];
    [_isshow release];
    [_user release];
    [super dealloc];
}

//id:"编号",pinpai :"品牌" ,"yanse :" 颜色" ,"bsx :" 变速箱" ,"xslc :" 行驶里程" ,"spsj :" 上牌时间" ,"xxms :" 详细描述","lxr :" 联系人","lxdh :" 联系电话"
-(void)fromDic:(NSDictionary *)usedCarInfoDic
{
    self.usedCarInfoId = [usedCarInfoDic objectForKey:@"id"];
    self.usedCarTid = [usedCarInfoDic objectForKey:@"tid"];
    self.title = [usedCarInfoDic objectForKey:@"title"];
    self.addTime = [usedCarInfoDic objectForKey:@"addtime"];
    self.hits = [usedCarInfoDic objectForKey:@"hits"];
    self.orders = [usedCarInfoDic objectForKey:@"orders"];
    self.mrank = [usedCarInfoDic objectForKey:@"mrank"];
    self.mgold = [usedCarInfoDic objectForKey:@"mgold"];
    self.isshow = [usedCarInfoDic objectForKey:@"isshow"];
    self.user = [usedCarInfoDic stringForKey:@"admin"];
}

@end
