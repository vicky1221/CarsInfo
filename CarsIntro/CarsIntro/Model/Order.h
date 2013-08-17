//
//  Order.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, copy) NSString * user;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * title;

- (void)fromDic:(NSDictionary *)OrderDic;

@end
