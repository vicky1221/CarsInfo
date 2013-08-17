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
        _sinaEngine = [[SinaWeibo alloc] initWithAppKey:@"721936388" appSecret:@"454bc428824415531c3b010411258915" appRedirectURI:@"http://www.readmw.com" andDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [_sinaEngine release];
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


#pragma mark -
#pragma mark SinaWeiboDelegate & SinaWeiboRequestDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
}
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
	
}
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{

}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{

}
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{

}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
}
- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data
{
	
}
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	
}

@end
