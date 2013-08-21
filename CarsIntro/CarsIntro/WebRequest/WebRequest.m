//
//  WebRequest.m
//  Mamicun
//
//  Created by song on 13-7-14.
//  Copyright (c) 2013年 Cao Vicky. All rights reserved.
//

#import "WebRequest.h"

@implementation WebRequest

-(void)clearAllRequest
{
    for (ASIHTTPRequest *request in allRequest) {
        [request clearDelegatesAndCancel];
    }
}

- (void)clearRequestWithTag:(NSInteger)tag {
    for (ASIHTTPRequest *request in allRequest) {
        if (request.tag == tag) {
            [request clearDelegatesAndCancel];
        }                                               
    }
}
+(NSString*)cateWithIndex:(NSInteger)index
{
    NSArray *array = [NSArray arrayWithObjects:@"member",@"forum",@"goods",@"auction", nil];
    return [array objectAtIndex:index];
}
-(id)requestWithCatagory:(NSString*)cata MothodName:(NSString*)method andArgs:(NSDictionary*)args delegate:(id)delegate
{
    return [self requestWithCatagory:cata MothodName:method andArgs:args delegate:delegate andTag:0];
}

-(id)requestWithCatagory:(NSString*)cata MothodName:(NSString*)method andArgs:(NSDictionary*)args delegate:(id)delegate andTag:(NSInteger)tag
{
    if ([cata isEqualToString:@"get"]) {
        NSString *url = [NSString stringWithFormat:@"%@%@",Server,method];
        NSString *saveURl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",url);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:saveURl]];
        request.tag = tag;
        request.delegate = delegate;
        [request startAsynchronous];
        [allRequest addObject:request];
        return request;
    }
    NSString *url = [NSString stringWithFormat:@"%@",Server];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    for (NSString *key in [args allKeys]) {
        [request setPostValue:[args valueForKey:key] forKey:key];
    }
    request.tag = tag;
    request.delegate = delegate;
    [request startAsynchronous];
    [allRequest addObject:request];
    return request;
}

#pragma mark - 单例必须方法
static WebRequest *sharedInstance = nil;
+ (WebRequest*)instance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        allRequest = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self instance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
@end
