//
//  LocationViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-19.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "LocationViewController.h"
#import "MyAnnotation.h"
#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"

@interface LocationViewController ()<QuadCurveMenuDelegate>

@end

@implementation LocationViewController

- (void)addPath {
//    [UIImage imageNamed:@"icon-star.png"];
    
    UIImage *image1 = [UIImage imageNamed:@"bg_buxing"];
    UIImage *image2 = [UIImage imageNamed:@"bg_daohang"];
    UIImage *image3 = [UIImage imageNamed:@"bg_dingwei"];
    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:image1
                                                               highlightedImage:image1
                                                                   ContentImage:image1
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:image2
                                                               highlightedImage:image2
                                                                   ContentImage:image2
                                                        highlightedContentImage:nil];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:image3
                                                               highlightedImage:image3
                                                                   ContentImage:image3
                                                        highlightedContentImage:nil];
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(0, 0, 200, 200) menus:menus];
    menu.delegate = self;
    [self.view addSubview:menu];
    [menu release];
}

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
    [self addPath];
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
    MKAnnotationView* newAnnotation=[[[MKAnnotationView alloc] initWithAnnotation: (MyAnnotation *)annotation reuseIdentifier: annotation.title] autorelease];
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


#pragma mark -

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
    NSLog(@"Select the index : %d",idx);
}


@end
