//
//  MemberCenter.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MemberCenter.h"

@implementation MemberCenter

-(id)init
{
    if (self = [super init]) {
        self.centerID = @"";
        self.tid = @"";
        self.title = @"";
        self.addtime = @"";
        self.hits = @"";
        self.orders = @"";
        self.mrank = @"";
        self.mgold = @"";
        self.isshow = @"";
        self.user = @"";
        self.content = @"";
        self.uid = @"";
    }
    return self;
}

-(void)dealloc
{
    [_centerID release];
    [_tid release];
    [_title release];
    [_addtime release];
    [_hits release];
    [_orders release];
    [_mrank release];
    [_mgold release];
    [_isshow release];
    [_user release];
    [_content release];
    [_uid release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)memberDic
{
    self.centerID = [memberDic stringForKey:@"id"];
    self.tid = [memberDic stringForKey:@"tid"];
    self.title = [memberDic stringForKey:@"title"];
    NSString * string = [memberDic stringForKey:@"addtime"];
    self.addtime = [string dateFormateSince1970];
    self.hits = [memberDic stringForKey:@"hits"];
    self.orders = [memberDic stringForKey:@"orders"];
    self.mrank = [memberDic stringForKey:@"mrank"];
    self.mgold = [memberDic stringForKey:@"mgold"];
    self.isshow = [memberDic stringForKey:@"isshow"];
    self.user = [memberDic stringForKey:@"user"];
    self.content = [memberDic stringForKey:@"content"];
    self.uid = [memberDic stringForKey:@"uid"];
}

@end
