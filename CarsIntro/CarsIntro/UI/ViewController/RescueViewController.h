//
//  RescueViewController.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
@interface RescueViewController : KBaseViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnHelp;

@property (retain, nonatomic) IBOutlet MKMapView *mapKit;

@end
