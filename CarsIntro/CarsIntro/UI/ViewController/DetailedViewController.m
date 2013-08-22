//
//  DetailedViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-6.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "DetailedViewController.h"
#import "Parameter.h"
@interface DetailedViewController ()

@end

@implementation DetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

    //    交强险	=950
    //    第三者责任险	=607
    //    车上人员责任险	=145
    //    车辆损失险	=(基本保费+ 车价*费率)
    //    车辆损失险的费率	基本保费80， 费率0.904% （8万以下)
    //    基本保费144，费率 0.824% （8-20万）
    //    基本保费192， 费率0.800% （20-35万）
    //    基本保费368， 费率0.7496%（35-50万）
    //    基本保费640，费率 0.6952%（50万以上）
    //    自燃险=	车辆损失险*0.18
    //    玻璃单独破碎险=	车辆损失险*0.3
    //    车身划痕损失险=	小于30万 400
    //    大于30完小于等于50万 585
    //    大于50万   850
    //    机动车盗抢险=	车辆损失险*0.5
    //    不计免赔特约险=	（第三者责任险+车辆损失险+车上人员责任险+车身划痕损失险）*0.15+（机动车盗抢险）*0.2

-(void)readDataSource
{
    float totprice = [self.price floatValue];
    float jiaoqiangxian = 950;
    float disanzhezerenxian = 607;
    float cheshangrenyuanzerenxian = 145;
    float sunshixian = 0;
    if (totprice<8) {
        sunshixian = 80+totprice*0.904*100;
    } else if (totprice >= 8 && totprice < 20) {
        sunshixian = 144 + totprice*0.824*100;
    } else if (totprice >=20 && totprice < 35) {
        sunshixian = 192 + totprice*0.8*100;
    } else if (totprice >=35 && totprice < 50) {
        sunshixian = 368 + totprice*0.7496*100;
    } else if (totprice >=50) {
        sunshixian = 640 + totprice*0.6952*100;
    }
    float ziranxian = sunshixian*0.18;
    float boliposuixian = sunshixian*0.3;
    float cheshenhuahen = 0;
    if (totprice<=30) {
        cheshenhuahen = 400;
    } else if (totprice>30&&totprice<=50) {
        cheshenhuahen = 585;
    } else {
        cheshenhuahen = 850;
    }
    float jidongchedaoxian = sunshixian*0.5;
    float bujimianpei = (disanzhezerenxian+sunshixian+cheshangrenyuanzerenxian+cheshenhuahen)*0.15+jidongchedaoxian*0.2;
    
    
    NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray * array2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    Parameter * parameter1 = [[Parameter alloc] init];
    parameter1.title = @"交强险";
    parameter1.content = @"950元";
    [array1 addObject:parameter1];
    [parameter1 release];
    
    Parameter * parameter2 = [[Parameter alloc] init];
    parameter2.title = @"第三者责任险";
    parameter2.content = @"607元";
    [array1 addObject:parameter2];
    [parameter2 release];
    
    Parameter * parameter3 = [[Parameter alloc] init];
    parameter3.title = @"车辆损失险";
    parameter3.content = [NSString stringWithFormat:@"%.0f元", sunshixian];
    [array1 addObject:parameter3];
    [parameter3 release];
    
    Parameter * parameter4 = [[Parameter alloc] init];
    parameter4.title = @"不计免赔特约险";
    parameter4.content = [NSString stringWithFormat:@"%.0f元", bujimianpei];
    [array1 addObject:parameter4];
    [parameter4 release];
    
    Parameter * parameter5 = [[Parameter alloc] init];
    parameter5.title = @"合计";
    parameter5.content = [NSString stringWithFormat:@"%.0f元", sunshixian+bujimianpei+607+950];
    [array1 addObject:parameter5];
    [parameter5 release];
    
    Parameter * parameter6 = [[Parameter alloc] init];
    parameter6.title = @"交通险";
    parameter6.content = @"950元";
    [array2 addObject:parameter6];
    [parameter6 release];
    
    Parameter * parameter7 = [[Parameter alloc] init];
    parameter7.title = @"第三者责任险";
    parameter7.content = @"607元";
    [array2 addObject:parameter7];
    [parameter7 release];
    
    Parameter * parameter8 = [[Parameter alloc] init];
    parameter8.title = @"车辆损失险";
    parameter8.content = [NSString stringWithFormat:@"%.0f元", sunshixian];
    [array2 addObject:parameter8];
    [parameter8 release];
    
    Parameter * parameter9 = [[Parameter alloc] init];
    parameter9.title = @"机动车盗抢险";
    parameter9.content = [NSString stringWithFormat:@"%.0f元", jidongchedaoxian];
    [array2 addObject:parameter9];
    [parameter9 release];
    
    Parameter * parameter10 = [[Parameter alloc] init];
    parameter10.title = @"自燃险";
    parameter10.content = [NSString stringWithFormat:@"%.0f元", ziranxian];
    [array2 addObject:parameter10];
    [parameter10 release];
    
    Parameter * parameter11 = [[Parameter alloc] init];
    parameter11.title = @"玻璃单独破碎险";
    parameter11.content = [NSString stringWithFormat:@"%.0f元", boliposuixian];
    [array2 addObject:parameter11];
    [parameter11 release];
    
    Parameter * parameter12 = [[Parameter alloc] init];
    parameter12.title = @"车上人员责任险";
    parameter12.content = [NSString stringWithFormat:@"%.0f元", cheshangrenyuanzerenxian];
    [array2 addObject:parameter12];
    [parameter12 release];
    
    Parameter * parameter13 = [[Parameter alloc] init];
    parameter13.title = @"车身划痕损失险";
    parameter13.content = [NSString stringWithFormat:@"%.0f元", cheshenhuahen];
    [array2 addObject:parameter13];
    [parameter13 release];
    
    Parameter * parameter14 = [[Parameter alloc] init];
    parameter14.title = @"不计免赔特约险";
    parameter14.content = [NSString stringWithFormat:@"%.0f元", bujimianpei];
    [array2 addObject:parameter14];
    [parameter14 release];
    
    Parameter * parameter15 = [[Parameter alloc] init];
    parameter15.title = @"合计";
    parameter15.content = [NSString stringWithFormat:@"%.0f元", bujimianpei+cheshenhuahen+cheshangrenyuanzerenxian+boliposuixian+ziranxian+jidongchedaoxian+sunshixian+950+607];
    [array2 addObject:parameter15];
    [parameter15 release];
    
    [self.detailedTable.detailedArray addObject:array1];
    [self.detailedTable.detailedArray addObject:array2];
    [array1 release];
    [array2 release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self readDataSource];
    self.detailedTable.backgroundColor = [UIColor clearColor];
    self.detailedTable.backgroundView = nil;
    [self.detailedTable setShowsVerticalScrollIndicator:NO];
    //    [tableView setShowsHorizontalScrollIndicator:NO];
    //    [tableView setShowsVerticalScrollIndicator:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_detailedTable release];
    [super dealloc];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];    
}

@end
