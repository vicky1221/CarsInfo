//
//  DataCenter.m
//  TaoduOnline
//
//  Created by Cao Vicky on 7/26/13.
//  Copyright (c) 2013 Cao Vicky. All rights reserved.
//

#import "DataCenter.h"

@implementation DataCenter

static DataCenter *instance = nil;

+(DataCenter *)shareInstance{
    if (!instance) {
        instance = [[DataCenter alloc] init];
    }
    return instance;
}

- (id)init{
    if (self = [super init]) {
        self.documentPath = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [self updateUserInfo];
    }
    return self;
}

- (void)dealloc{
    [_accont release];
    [_documentPath release];
    [super dealloc];
}

- (void)updateUserInfo {
    if (!self.accont) {
        self.accont = [[[Account alloc] init] autorelease];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",self.documentPath,UserInfo]];
    if (dic) {
        [self.accont fromDic:dic];
    }
}


@end
