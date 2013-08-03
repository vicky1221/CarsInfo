//
//  MyAnnotation.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(id)initWithTitle:(NSString *)title subTitle:(NSString *)subtitle Coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    return self;
}

-(NSString *)title
{
    return _title;
}

-(NSString *)subtitle
{
    return _subtitle;
}

-(CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

@end
