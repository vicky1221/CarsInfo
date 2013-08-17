//
//  MessageBody.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+type.h"
#import "NSString+Date.h"
@interface MessageBody : NSObject

@property (nonatomic, retain) NSString * addtime;
@property (nonatomic, retain) NSString * messageBodyID;
@property (nonatomic, retain) NSString * user;
@property (nonatomic, retain) NSString * title;

-(void)fromDic:(NSDictionary *)messageBodyDic;

@end
