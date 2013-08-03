//
//  Information.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-11.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "Information.h"
#import "NSDictionary+type.h"
@implementation Information

-(id)init
{
    if (self = [super init]) {
        self.infoId = @"";
        self.title = @"";
        self.content = @"";
        self.picPath = @"";
        self.time = 0;
        self.tid = @"";
        self.user = @"";
        self.hasPic = NO;
    }
    return self;
}

-(void)dealloc
{
    [_url release];
    [_infoId release];
    [_title release];
    [_content release];
    [_picPath release];
    [super dealloc];
}

-(void)fromDic:(NSDictionary *)infoDic
{
//    
//    NSString * infoId; //"id" : "58"
//    NSString * title; //"title" : "测试带图片的资讯",
//    NSString * content; //"description" : "",
//    NSString * picPath; //"litpic" : "/qiche/uploads/
//    ime; //"addtime" : "1375079280",
//    OL       hasPic; //"isshow" : "1",
//    NSString *tid; //"tid" : "33",
//    NSString *user; //"user" : "admin"
    
    self.infoId = [infoDic stringForKey:@"id"];
    self.title = [infoDic stringForKey:@"title"];
    self.content = [infoDic stringForKey:@"description"];
    self.hasPic = [infoDic boolForKey:@"isshow"];
    self.picPath = [NSString stringWithFormat:@"%@%@",ServerAddress ,[infoDic stringForKey:@"litpic"]];
    self.time = [infoDic floatForKey:@"addtime"];
    self.tid = [infoDic stringForKey:@"tid"];
    self.user = [infoDic stringForKey:@"user"];
    self.url = [NSString stringWithFormat:@"%@%@",ServerAddress, [infoDic stringArrayForKey:@"url"]];
}

@end
