//
//  DataCenter.h
//  TaoduOnline
//
//  Created by Cao Vicky on 7/26/13.
//  Copyright (c) 2013 Cao Vicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

#define UserInfo  @"userInfo.plist"

@interface DataCenter : NSObject

+(DataCenter *)shareInstance;
@property(nonatomic,retain) NSString *documentPath;
@property (nonatomic, retain) Account *accont;

@property (assign)          double latitude;
@property (assign)          double longitude;
- (void)updateUserInfo;

@end
