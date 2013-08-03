//
//  RescueViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "RescueViewController.h"
#import "iToast.h"
@interface RescueViewController ()

@end

@implementation RescueViewController

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
    [manager release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CLLocationCoordinate2D center;
    center.latitude = 40.0516041972908;
    center.longitude = 116.294965283102;
    //设置要显示的经纬度
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    MKCoordinateRegion region = {center,span};
    [self.mapKit setRegion:region];
    //设置当前位置
    self.mapKit.delegate = self;
    self.mapKit.showsUserLocation = YES;
    self.mapKit.mapType = MKMapTypeStandard;
    
    [self positioning];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //定位后的新位置
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
    //设置地图位置,动画显示平移的效果
    [self.mapKit setRegion:region animated:YES];
    //停止定位
    [manager stopUpdatingLocation];
    [manager release];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error");
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

#pragma mark - button Action

- (IBAction)position:(id)sender {
    [self positioning];
}

- (IBAction)help:(id)sender {
    [[iToast makeText:@"救援信息发送成功,请耐心等待."] show];
}
- (IBAction)phone:(id)sender {
    NSLog(@"123");
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
