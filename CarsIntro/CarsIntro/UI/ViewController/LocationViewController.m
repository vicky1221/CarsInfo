//
//  LocationViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "LocationViewController.h"
#import "MyAnnotation.h"
@interface LocationViewController ()

@end

@implementation LocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)positioning
{
    //定位
    CLLocationManager * manager = [[CLLocationManager alloc] init];
    //定位的精确度
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    //地图定位的可偏移量,超过多少米定一次位
    manager.distanceFilter = 10.0;
    manager.delegate = self;
    //开始定位
    [manager startUpdatingLocation];
    NSLog(@"开始定位");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    //[self positioning];
    [super viewDidAppear:animated];
    CLLocationCoordinate2D center;
    center.latitude = 37.857452100000;
    center.longitude = 112.503559700000;
    //设置要显示的经纬度
    MKCoordinateSpan span;
    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;
    MKCoordinateRegion region = {center,span};
    [self.mapKit setRegion:region];
    //设置当前位置
    self.mapKit.delegate = self;
    self.mapKit.showsUserLocation = YES;
    self.mapKit.mapType = MKMapTypeStandard;
    
    MyAnnotation * anno = [[MyAnnotation alloc] initWithTitle:@"山西君和汽车销售服务有限公司" subTitle:@"太原市万柏林区迎泽西大街170" Coordinate:center];
    [self.mapKit addAnnotation:anno];
    [anno release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView* newAnnotation=[[MKAnnotationView alloc] initWithAnnotation: (MyAnnotation *)annotation reuseIdentifier: annotation.title];
    newAnnotation.canShowCallout = YES;
    UIImage *image = [UIImage imageNamed:@"Location_1.png"];
    newAnnotation.image= image;
    
    return newAnnotation;
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mapKit release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapKit:nil];
    [super viewDidUnload];
}
@end
