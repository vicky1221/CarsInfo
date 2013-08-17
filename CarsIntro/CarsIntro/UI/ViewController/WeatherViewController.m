//
//  WeatherViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "WeatherViewController.h"
#import "ProviceViewController.h"
#import "WeatherCity.h"
#import "JSON.h"
#import "iToast.h"
#import "NSDictionary+type.h"

@interface WeatherViewController () <ASIHTTPRequestDelegate>{
    WeatherCity *saveCity;
}

@end

@implementation WeatherViewController

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
    
    [self shadowView:view1];
    [self shadowView:view2];
    [self shadowView:view3];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"City"];
    if (dic) {
        if (!saveCity) {
            saveCity = [[WeatherCity alloc] init];
        }
        [saveCity fromDic:dic];
    } else {
        if (!saveCity) {
            saveCity = [[WeatherCity alloc] init];
        }
        saveCity.provinceID = @"0";
        saveCity.cityCode = @"101010100";
        saveCity.cityName = @"北京";
        saveCity.cityID = @"1";
        saveCity.isSelect = YES;
    }
    [cityButton setTitle:saveCity.cityName forState:UIControlStateNormal];
    [self performSelector:@selector(sendAPI)];
}

- (void)dealloc {
    [saveCity release];
    [super dealloc];
}

- (void)sendAPI {
    NSString *urlString = [NSString stringWithFormat:@"http://m.weather.com.cn/data/%@.html", saveCity.cityCode];
    NSLog(@"%@", urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.tag = 535;
    request.delegate = self;
    [request startAsynchronous];
}

- (IBAction)toHome:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (IBAction)selectCity:(id)sender {
    ProviceViewController *proviceVC = [[ProviceViewController new] autorelease];
    [self.navigationController pushViewController:proviceVC animated:YES];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *dic = [[request responseString] JSONValue];
    NSLog(@"%@", [dic description]);
    if (dic) {
        NSDictionary *weatherDic = [dic objectForKey:@"weatherinfo"];
        timeLabel.text = [weatherDic stringForKey:@"date_y"];
        weekLabel.text = [weatherDic stringForKey:@"week"];
        weatherLabel.text = [NSString stringWithFormat:@"%@  %@", [weatherDic stringForKey:@"weather1"], [weatherDic stringForKey:@"temp1"]];
        washCarLabel.text = [weatherDic stringForKey:@"index_xc"];
        weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [weatherDic stringForKey:@"img_title1"]]];
        
        weatherLabel2.text = [NSString stringWithFormat:@"%@  %@", [weatherDic stringForKey:@"weather2"], [weatherDic stringForKey:@"temp2"]];
        weatherLabel3.text = [NSString stringWithFormat:@"%@  %@", [weatherDic stringForKey:@"weather3"], [weatherDic stringForKey:@"temp3"]];
        weatherImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [weatherDic stringForKey:@"img_title2"]]];
        weatherImageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [weatherDic stringForKey:@"img_title3"]]];
        
    }
//    weatherinfo =     {
//        city = "\U5ef6\U5e86";
//        "city_en" = yanqing;
//        cityid = 101010800;
//        date = "";
//        "date_y" = "2013\U5e748\U670814\U65e5";
//        fchh = 18;
//        fl1 = "\U5c0f\U4e8e3\U7ea7";
//        fl2 = "\U5c0f\U4e8e3\U7ea7";
//        fl3 = "\U5c0f\U4e8e3\U7ea7";
//        fl4 = "\U5c0f\U4e8e3\U7ea7";
//        fl5 = "\U5c0f\U4e8e3\U7ea7";
//        fl6 = "\U5c0f\U4e8e3\U7ea7";
//        fx1 = "\U5fae\U98ce";
//        fx2 = "\U5fae\U98ce";
//        img1 = 4;
//        img10 = 1;
//        img11 = 1;
//        img12 = 2;
//        img2 = 99;
//        img3 = 4;
//        img4 = 99;
//        img5 = 4;
//        img6 = 1;
//        img7 = 0;
//        img8 = 99;
//        img9 = 0;
//        "img_single" = 4;
//        "img_title1" = "\U96f7\U9635\U96e8";
//        "img_title10" = "\U591a\U4e91";
//        "img_title11" = "\U591a\U4e91";
//        "img_title12" = "\U9634";
//        "img_title2" = "\U96f7\U9635\U96e8";
//        "img_title3" = "\U96f7\U9635\U96e8";
//        "img_title4" = "\U96f7\U9635\U96e8";
//        "img_title5" = "\U96f7\U9635\U96e8";
//        "img_title6" = "\U591a\U4e91";
//        "img_title7" = "\U6674";
//        "img_title8" = "\U6674";
//        "img_title9" = "\U6674";
//        "img_title_single" = "\U96f7\U9635\U96e8";
//        index = "\U70ed";
//        index48 = "\U70ed";
//        "index48_d" = "\U5929\U6c14\U70ed\Uff0c\U5efa\U8bae\U7740\U77ed\U88d9\U3001\U77ed\U88e4\U3001\U77ed\U8584\U5916\U5957\U3001T\U6064\U7b49\U590f\U5b63\U670d\U88c5\U3002";
//        "index48_uv" = "\U4e2d\U7b49";
//        "index_ag" = "\U8f83\U6613\U53d1";
//        "index_cl" = "\U8f83\U4e0d\U5b9c";
//        "index_co" = "\U8f83\U4e0d\U8212\U9002";
//        "index_d" = "\U5929\U6c14\U70ed\Uff0c\U5efa\U8bae\U7740\U77ed\U88d9\U3001\U77ed\U88e4\U3001\U77ed\U8584\U5916\U5957\U3001T\U6064\U7b49\U590f\U5b63\U670d\U88c5\U3002";
//        "index_ls" = "\U4e0d\U5b9c";
//        "index_tr" = "\U4e00\U822c";
//        "index_uv" = "\U4e2d\U7b49";
//        "index_xc" = "\U4e0d\U5b9c";
//        st1 = 29;
//        st2 = 19;
//        st3 = 28;
//        st4 = 20;
//        st5 = 33;
//        st6 = 18;
//        temp1 = "21\U2103~31\U2103";
//        temp2 = "22\U2103~30\U2103";
//        temp3 = "20\U2103~33\U2103";
//        temp4 = "20\U2103~31\U2103";
//        temp5 = "20\U2103~29\U2103";
//        temp6 = "19\U2103~27\U2103";
//        tempF1 = "69.8\U2109~87.8\U2109";
//        tempF2 = "71.6\U2109~86\U2109";
//        tempF3 = "68\U2109~91.4\U2109";
//        tempF4 = "68\U2109~87.8\U2109";
//        tempF5 = "68\U2109~84.2\U2109";
//        tempF6 = "66.2\U2109~80.6\U2109";
//        weather1 = "\U96f7\U9635\U96e8";
//        weather2 = "\U96f7\U9635\U96e8";
//        weather3 = "\U96f7\U9635\U96e8\U8f6c\U591a\U4e91";
//        weather4 = "\U6674";
//        weather5 = "\U6674\U8f6c\U591a\U4e91";
//        weather6 = "\U591a\U4e91\U8f6c\U9634";
//        week = "\U661f\U671f\U4e09";
//        wind1 = "\U5fae\U98ce";
//        wind2 = "\U5fae\U98ce";
//        wind3 = "\U5fae\U98ce";
//        wind4 = "\U5fae\U98ce";
//        wind5 = "\U5fae\U98ce";
//        wind6 = "\U5fae\U98ce";
//    };
    
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
}

@end
