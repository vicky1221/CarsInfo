//
//  WebRequest.h
//  Mamicun
//
//  Created by song on 13-7-14.
//  Copyright (c) 2013年 Cao Vicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface WebRequest : NSObject
{
    NSMutableArray *allRequest;
}
+ (WebRequest*)instance;
//分类
+(NSString*)cateWithIndex:(NSInteger)index;

//请求
-(id)requestWithCatagory:(NSString*)cata MothodName:(NSString*)method andArgs:(NSDictionary*)args delegate:(id)delegate;


//用tag请求
-(id)requestWithCatagory:(NSString*)cata MothodName:(NSString*)method andArgs:(NSDictionary*)args delegate:(id)delegate andTag:(NSInteger)tag;

//取消所有请求
-(void)clearAllRequest;
- (void)clearRequestWithTag:(NSInteger)tag;
@end
