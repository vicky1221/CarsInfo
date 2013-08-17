//
//  MemberCenter.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+type.h"
#import "NSString+Date.h"
@interface MemberCenter : NSObject

@property (nonatomic, copy) NSString * centerID;
@property (nonatomic, copy) NSString * tid;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * addtime;
@property (nonatomic, copy) NSString * hits;
@property (nonatomic, copy) NSString * orders;
@property (nonatomic, copy) NSString * mrank;
@property (nonatomic, copy) NSString * mgold;
@property (nonatomic, copy) NSString * isshow;
@property (nonatomic, copy) NSString * user; //"user" : "admin"
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * uid;

-(void)fromDic:(NSDictionary *)memberDic;


@end
