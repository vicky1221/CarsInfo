//
//  Account.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/9/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, retain) NSString *loginUserID;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *UserScore;
@property (nonatomic, retain) NSString *cylb;

- (BOOL)isAnonymous;
- (void)fromDic:(NSDictionary *)dic;
- (NSDictionary *)toDic;
- (void)logout;
- (void)saveAccountInfo;

@end
