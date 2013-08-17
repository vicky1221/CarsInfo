//
//  Account.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/9/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "Account.h"
#import "NSDictionary+type.h"

@implementation Account

- (id)init
{
    self = [super init];
    if (self) {
        self.loginUserID = @"";
        self.userName = @"";
        self.UserScore = @"";
        self.cylb = @"";
    }
    return self;
}

- (void)dealloc {
    [_loginUserID release];
    [_userName release];
    [_UserScore release];
    [_cylb release];
    [super dealloc];
}

- (void)fromDic:(NSDictionary *)dic {
    self.loginUserID = [dic stringForKey:@"id"];
    self.userName = [dic stringForKey:@"user"];
    self.UserScore = [dic stringForKey:@"score"];
    self.cylb = [dic stringForKey:@"cylb"];
}

- (NSDictionary *)toDic {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:self.loginUserID forKey:@"id"];
    [dic setObject:self.userName forKey:@"user"];
    [dic setObject:self.UserScore forKey:@"score"];
    [dic setObject:self.cylb forKey:@"cylb"];
    return dic;
}

- (BOOL)isAnonymous {
    if (self.loginUserID && [self.loginUserID integerValue] > 0) {
        return NO;
    }
    return YES;
}

- (void)logout {
    self.loginUserID = @"";
    self.userName = @"";
    self.UserScore = @"";
    self.cylb = @"";
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[DataCenter shareInstance] documentPath],UserInfo];
    NSDictionary *saveDic = [self toDic];
    [saveDic writeToFile:path atomically:YES];
}

- (void)saveAccountInfo {
    NSDictionary *d = [self toDic];
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[DataCenter shareInstance] documentPath],UserInfo];
    [d writeToFile:path atomically:YES];
}
@end
