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
//        _image = [UIImage imageNamed:@"Location_2.png"];
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
    return self;
}

//-(id)initWithImage:(UIImage *)image Coordinate:(CLLocationCoordinate2D)coordinate 
//{
//    if (self = [super init]) {
//        _image = image;
//        _coordinate = coordinate;
//    }
//    return self;
//}

-(UIImage *)image
{
    return _image;
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
