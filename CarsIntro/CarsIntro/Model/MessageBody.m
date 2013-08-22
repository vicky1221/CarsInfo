//
//  MessageBody.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MessageBody.h"

@implementation MessageBody

-(id)init
{
    if (self = [super init]) {
        self.addtime = @"";
        self.messageBodyID = @"";
        self.user = @"";
        self.title = @"";
    }
    return self;
}

-(void)dealloc
{
    [_addtime release];
    [_messageBodyID release];
    [_user release];
    [_title release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)messageBodyDic
{
    NSString * string = [messageBodyDic stringForKey:@"addtime"];
    self.addtime = [string dateFormateSince1970];
    self.messageBodyID = [messageBodyDic stringForKey:@"id"];
    self.user = [messageBodyDic stringForKey:@"user"];
    self.title = [messageBodyDic stringForKey:@"title"];
}

@end
