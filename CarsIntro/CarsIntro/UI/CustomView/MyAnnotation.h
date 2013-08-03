//
//  MyAnnotation.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>
{
    NSString * _title;
    NSString * _subtitle;
    CLLocationCoordinate2D _coordinate;
}
-(id)initWithTitle:(NSString *)title subTitle:(NSString *)subtitle Coordinate:(CLLocationCoordinate2D)coordinate;

@end
