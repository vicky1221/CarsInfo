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

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface LocationViewController ()<QuadCurveMenuDelegate>

@end

@implementation LocationViewController

- (void)addPath {
//    [UIImage imageNamed:@"icon-star.png"];
    
    UIImage *image1 = [UIImage imageNamed:@"bg_daohang"];
    UIImage *image2 = [UIImage imageNamed:@"bg_dingwei"];
    UIImage *image3 = [UIImage imageNamed:@"bg_buxing"];
    
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
    QuadCurveMenu *menu = [[QuadCurveMenu alloc] initWithFrame:CGRectMake(20, -20, 200, 200) menus:menus];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addPath];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self positionShop];
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
            // 定位自己
            [self positioning];
            break;
        case 1:
            // 定位店铺
            [self positionShop];
            break;
        case 2:
            // 步行
            [self walkWay];
            break;
        default:
            break;
    }
    NSLog(@"Select the index : %d",idx);
}

- (void)positionShop {
    CLLocationCoordinate2D center;
    center.latitude = 37.857452100000;
    center.longitude = 112.503559700000;
    self.shopLocation = center;
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

-(void)positioning
{
    //定位
    CLLocationManager * manager = [[CLLocationManager alloc] init];
    //定位的精确度
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    //地图定位的可偏移量,超过多少米定一次位
    manager.distanceFilter = 100.0;
    manager.delegate = self;
    //开始定位
    [manager startUpdatingLocation];
    NSLog(@"开始定位");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //定位后的新位置
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.02, 0.02));
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = newLocation.coordinate;
    self.myLocation = newLocation.coordinate;
    self.mapKit.showsUserLocation = YES;
    //触发viewForAnnotation
    //    [self.mapKit addAnnotation:ann];
    [ann release];
    //设置地图位置,动画显示平移的效果
    [self.mapKit setRegion:region animated:YES];
    //停止定位
    [manager stopUpdatingLocation];
    NSLog(@"定位成功");
}

- (void)walkWay {
    
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.myLocation addressDictionary:nil]];        //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.shopLocation addressDictionary:nil]];        toLocation.name = @"目的地";
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    /*         //keys
     
     
     MKLaunchOptionsMapCenterKey:地图中心的坐标(NSValue)         MKLaunchOptionsMapSpanKey:地图显示的范围(NSValue)         MKLaunchOptionsShowsTrafficKey:是否显示交通信息(boolean NSNumber)                  //MKLaunchOptionsDirectionsModeKey: 导航类型(NSString)         {            MKLaunchOptionsDirectionsModeDriving:驾车            MKLaunchOptionsDirectionsModeWalking:步行         }                  //MKLaunchOptionsMapTypeKey:地图类型(NSNumber)         enum {         MKMapTypeStandard = 0,         MKMapTypeSatellite,         MKMapTypeHybrid         };         */
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,            MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],            MKLaunchOptionsShowsTrafficKey:@NO
                              };        //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
    return;
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))// ios6以下，调用google map
    {
        NSString *urlString = [[NSString alloc]                               initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d", self.myLocation.latitude,self.myLocation.longitude,self.shopLocation.latitude,self.shopLocation.longitude];        NSURL *aURL = [NSURL URLWithString:urlString];        //打开网页google地图
        [[UIApplication sharedApplication] openURL:aURL];
    }else// 直接调用ios自己带的apple map
    {        //当前的位置
        //MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];        //起点
        MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.myLocation addressDictionary:nil]];        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.shopLocation addressDictionary:nil]];        toLocation.name = @"目的地";
        NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
        /*         //keys
                                                                                                      
                                                                                                      
                MKLaunchOptionsMapCenterKey:地图中心的坐标(NSValue)         MKLaunchOptionsMapSpanKey:地图显示的范围(NSValue)         MKLaunchOptionsShowsTrafficKey:是否显示交通信息(boolean NSNumber)                  //MKLaunchOptionsDirectionsModeKey: 导航类型(NSString)         {            MKLaunchOptionsDirectionsModeDriving:驾车            MKLaunchOptionsDirectionsModeWalking:步行         }                  //MKLaunchOptionsMapTypeKey:地图类型(NSNumber)         enum {         MKMapTypeStandard = 0,         MKMapTypeSatellite,         MKMapTypeHybrid         };         */
        NSDictionary *options = @{
                                  MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking,            MKLaunchOptionsMapTypeKey:[NSNumber numberWithInteger:MKMapTypeStandard],            MKLaunchOptionsShowsTrafficKey:@NO
                                  };        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:items launchOptions:options];
    }
}

@end
