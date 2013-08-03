//
//  FocusPic.m
//  CarsIntro
//
//  Created by Cao Vicky on 7/10/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "FocusPic.h"

@implementation FocusPic

- (id)init {
    self = [super init];
    if (self) {
        self.picName = @"";
        self.picPath = @"";
    }
    return self;
}

- (void)dealloc {
    [_picName release];
    [_picPath release];
    [super dealloc];
}

//"picName":"Bill" ,"picPath":"Gates"
- (void)fromDic:(NSDictionary *)focusPicDic {
    self.picName = [focusPicDic objectForKey:@"picName"];
    self.picPath = [focusPicDic objectForKey:@"picPath"];
}

@end
