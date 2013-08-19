//
//  RescueViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "RescueViewController.h"
#import "iToast.h"
#import "WebRequest.h"
#import "JSON.h"
@interface RescueViewController ()<ASIHTTPRequestDelegate>

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
    [self.btnHelp setImage:[UIImage imageNamed:@"Rescue_2.png"] forState:UIControlStateNormal];
     NSLog(@"开始定位");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.btnHelp setImage:[UIImage imageNamed:@"Rescue_2.png"] forState:UIControlStateDisabled];
    
    CLLocationCoordinate2D center;
    center.latitude = 40.0516041972908;
    center.longitude = 116.294965283102;
    //设置要显示的经纬度
    
    MKCoordinateSpan span;
    span.latitudeDelta = 1;
    span.longitudeDelta = 1;
    MKCoordinateRegion region = {center,span};
    [self.mapKit setRegion:region];
    //设置当前位置
    self.mapKit.delegate = self;
    self.mapKit.showsUserLocation = YES;
    self.mapKit.mapType = MKMapTypeStandard;
}

- (void)viewDidAppear:(BOOL)animated {
    [self positioning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:110];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //定位后的新位置
    MKCoordinateRegion region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.02, 0.02));
    
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = newLocation.coordinate;
    //触发viewForAnnotation
//    [self.mapKit addAnnotation:ann];
    [ann release];
    //设置地图位置,动画显示平移的效果
    [self.mapKit setRegion:region animated:YES];
    //停止定位
    [manager stopUpdatingLocation];
    NSLog(@"定位成功");
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_mapKit release];
    [_btnHelp release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapKit:nil];
    [self setBtnHelp:nil];
    [super viewDidUnload];
}

#pragma mark - button Action

- (IBAction)position:(id)sender {
    [self positioning];
}

//http://www.ard9.com/qiche/index.php?c=member&a=release&tid=31&hand=161444713&id=&go=1&from=app
-(void)senderAPI
{
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=release&tid=31&hand=161444713&id=&go=1&from=app&uid=%@&address=山西&jd=%5.f&wd=%5.f", [DataCenter shareInstance].accont.loginUserID, [DataCenter shareInstance].latitude, [DataCenter shareInstance].longitude] andArgs:nil delegate:self andTag:110];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dic = [[request responseString] JSONValue];
    if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
        [self back:nil];
    }
    [[iToast makeText: [dic objectForKey:@"msg"]] show];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"信息错误");
}

- (IBAction)help:(id)sender {
    [self performSelector:@selector(senderAPI)];
}
- (IBAction)phone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006310351"]];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
