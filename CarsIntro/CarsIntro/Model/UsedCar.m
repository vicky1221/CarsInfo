//
//  UsedCar.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "UsedCar.h"
#import "NSDictionary+type.h"
#import "NSString+Date.h"
@implementation UsedCar

-(id)init
{
    self = [super init];
    if (self) {
        self.pinpai = @"";
        self.bsx = @"";
        self.yanse = @"";
        self.pic = @"";
    }
    return self;
}

-(void)dealloc
{
    [_pic release];
    [_pinpai release];
    [_bsx release];
    [_yanse release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)usedCarDic
{
    self.pic = [NSString stringWithFormat:@"%@%@",ServerAddress ,[usedCarDic stringForKey:@"pic"]];
    self.pinpai = [usedCarDic stringForKey:@"pinpai"];
    self.yanse = [usedCarDic stringForKey:@"yanse"];
    self.bsx = [usedCarDic stringForKey:@"bsx"];
}
@end

