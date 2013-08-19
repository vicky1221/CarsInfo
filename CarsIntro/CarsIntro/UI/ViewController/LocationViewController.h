//
//  LocationViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import <MapKit/MapKit.h>
@interface LocationViewController : KBaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *mapKit;

@end
