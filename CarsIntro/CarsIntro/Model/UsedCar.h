//
//  UsedCar.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedCar : NSObject

@property (nonatomic, retain) NSString * pinpai;
@property (nonatomic, retain) NSString * yanse;
@property (nonatomic, retain) NSString * bsx;
@property (nonatomic, retain) NSString * pic;

-(void)fromDic:(NSDictionary *)usedCarDic;

@end
