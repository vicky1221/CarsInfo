//
//  MessageCenter.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MessageCenter.h"
#import "NSDictionary+type.h"
#import "NSString+Date.h"
@implementation MessageCenter

-(id)init
{
    if (self = [super init]) {
       self.messageId = @"";
        self.sender = @"";
        self.content = @"";
        self.time = @"";
    }
    return self;
}

-(void)dealloc
{
    [_messageId release];
    [_sender release];
    [_content release];
    [_time release];
    [super dealloc];
}

//id:"编号",fxr:"发信人" ,content:"内容"，shijian:"发布时间"
-(void)fromDic:(NSDictionary *)messageCenterDic
{
    self.messageId = [messageCenterDic objectForKey:@"id"];
    self.sender= [messageCenterDic objectForKey:@"fxr"];
    self.content = [messageCenterDic objectForKey:@"content"];
    NSString * string = [messageCenterDic stringForKey:@"shijian"];
    self.time = [string dateFormateSince1970];
}

@end
