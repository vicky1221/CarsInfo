//
//  MActivity.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+type.h"
#import "NSString+Date.h"
@interface MActivity : NSObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * yhjId;
@property (nonatomic, retain) NSString * useTime;

-(void)fromDic:(NSDictionary *)MActivityDic;

@end
