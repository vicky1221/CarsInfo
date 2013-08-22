//
//  Order.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "Order.h"
#import "NSString+Date.h"
#import "NSDictionary+type.h"
@implementation Order

- (id)init {
    self = [super init];
    if (self) {
        self.user = @"";
        self.phone = @"";
        self.time = @"";
        self.type = @"";
        self.title = @"";
    }
    return self;
}

- (void)dealloc {
    [_user release];
    [_phone release];
    [_time release];
    [_type release];
    [_title release];
    [super dealloc];
}

- (void)fromDic:(NSDictionary *)OrderDic {
    self.user = [OrderDic objectForKey:@"user"];
    self.phone = [OrderDic objectForKey:@"hits"];
    
    NSString * string = [OrderDic stringForKey:@"addtime"];
    self.time = [string dateFormateSince1970];
    //self.type = [OrderDic objectForKey:@"style"];
    self.title = [OrderDic objectForKey:@"title"];
}

@end
