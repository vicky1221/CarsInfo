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
//    "id":"92","tid":"34","title":"","style":"","trait":"","gourl":"","addtime":"1377103646","hits":"0","orders":"0","mrank":"0","mgold":"0","isshow":"0","description":"","htmlurl":"","htmlfile":"","1":"1","user":"","name":"df","tel":"adf","shijian":"0","url":"\/qiche\/channel\/yuyue\/921.html","yysl":"0","from":"\u5c71\u897f\u541b\u548c\u5965\u8fea"}
//  [{"id":"118","tid":"36","title":"","style":"","trait":"","gourl":"","addtime":"1377270060","hits":"0","orders":"0","mrank":"0","mgold":"0","isshow":"0","description":"","htmlurl":"","htmlfile":"","1":"1","user":"","name":"fad","tel":"1441324","shijian":"2013-08-23 23:00","url":"\/qiche\/channel\/yuyue\/1181.html","yysl":"0","from":"\u5c71\u897f\u541b\u548c\u5965\u8fea"}]
    self.user = [OrderDic stringForKey:@"name"];
    self.phone = [OrderDic stringForKey:@"tel"];
    
//    NSString * string = [OrderDic stringForKey:@"addtime"];
//    self.time = [string dateFormateSince1970];
    self.time = [OrderDic stringForKey:@"shijian"];
    //self.type = [OrderDic objectForKey:@"style"];
    self.title = [OrderDic stringForKey:@"title"];
}

@end
