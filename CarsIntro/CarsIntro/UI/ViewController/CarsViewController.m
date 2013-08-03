//
//  CarsViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "CarsViewController.h"
#import "VehicleType.h"
#import "UsedCarInfo.h"
#import "UIView+custom.h"
#import "CarsCell.h"
#import "TypeViewController.h"
#import "JSON.h"
#import "UsedCarInfo.h"

@interface CarsViewController ()<ASIHTTPRequestDelegate>

@end

@implementation CarsViewController

#define Button_Width    152
#define Button_Height   36

- (void)addButtonsToChoiceView
{
    self.btnNew = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnNew.tag = 101;
    [self.btnNew setBackgroundImage:[UIImage imageNamed:@"newCar_1@2x.png"] forState:UIControlStateNormal];
    float x = VIEW_WIDTH(self.choiceView)/2 - Button_Width/2;
    float y = VIEW_HEIGHT(self.choiceView)/2;
    self.btnNew.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    self.btnNew.center = CGPointMake(x, y);
    [self.btnNew addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceView addSubview:self.btnNew];
    
    self.btnUsed = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnUsed.tag = 102;
    [self.btnUsed setBackgroundImage:[UIImage imageNamed:@"usedCar_1@2x.png"] forState:UIControlStateNormal];
    x = VIEW_WIDTH(self.choiceView)/2 + Button_Width/2;
    y = VIEW_HEIGHT(self.choiceView)/2;
    self.btnUsed.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    self.btnUsed.center = CGPointMake(x, y);
    [self.btnUsed addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.choiceView addSubview:self.btnUsed];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)readNewDataSource
{
    self.carsTable.isNewCarData = YES;
    self.carsTable.newCarsArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray * array2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    VehicleType * _vehicleType1 = [[VehicleType alloc] init];
    _vehicleType1.title = @"XF";
    _vehicleType1.price = @"55.0万元";
    _vehicleType1.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType1.image = @"0.jpg";
    [array1 addObject:_vehicleType1];
    [_vehicleType1 release];
    
    VehicleType * _vehicleType2 = [[VehicleType alloc] init];
    _vehicleType2.title = @"XF";
    _vehicleType2.price = @"55.0万元";
    _vehicleType2.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType2.image = @"1.jpg";
    [array1 addObject:_vehicleType2];
    [_vehicleType2 release];
    
    VehicleType * _vehicleType3 = [[VehicleType alloc] init];
    _vehicleType3.title = @"XJ";
    _vehicleType3.price = @"55.0万元";
    _vehicleType3.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType3.image = @"3.jpg";
    [array1 addObject:_vehicleType3];
    [_vehicleType3 release];
    
    VehicleType * _vehicleType4 = [[VehicleType alloc] init];
    _vehicleType4.title = @"XF";
    _vehicleType4.price = @"55.0万元";
    _vehicleType4.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType4.image = @"0.jpg";
    [array2 addObject:_vehicleType4];
    [_vehicleType4 release];
    
    VehicleType * _vehicleType5 = [[VehicleType alloc] init];
    _vehicleType5.title = @"XF";
    _vehicleType5.price = @"55.0万元";
    _vehicleType5.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType5.image = @"1.jpg";
    [array2 addObject:_vehicleType5];
    [_vehicleType5 release];
    
    VehicleType * _vehicleType6 = [[VehicleType alloc] init];
    _vehicleType6.title = @"XF";
    _vehicleType6.price = @"55.0万元";
    _vehicleType6.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType6.image = @"3.jpg";
    [array2 addObject:_vehicleType6];
    [_vehicleType6 release];
    
    VehicleType * _vehicleType7 = [[VehicleType alloc] init];
    _vehicleType7.title = @"XF";
    _vehicleType7.price = @"55.0万元";
    _vehicleType7.displacement = @"0L 0L 3L 4.2L 5L";
    _vehicleType7.image = @"0.jpg";
    [array2 addObject:_vehicleType7];
    [_vehicleType7 release];
    
    [self.carsTable.newCarsArray addObject:array1];
    [self.carsTable.newCarsArray addObject:array2];
    [array1 release];
    [array2 release];
    [self.carsTable reloadData];
}

//-(void)readUsedDataSource
//{
//    self.carsTable.isNewCarData = NO;
//    self.carsTable.usedCarsArray = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray * array1 = [[NSMutableArray alloc] initWithCapacity:0];
//    NSMutableArray * array2 = [[NSMutableArray alloc] initWithCapacity:0];
//    
//    VehicleType * _vehicleType1 = [[VehicleType alloc] init];
//    _vehicleType1.title = @"XF";
//    _vehicleType1.price = @"55.0万元";
//    _vehicleType1.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType1.image = @"0.jpg";
//    [array1 addObject:_vehicleType1];
//    [_vehicleType1 release];
//    
//    VehicleType * _vehicleType2 = [[VehicleType alloc] init];
//    _vehicleType2.title = @"XJ";
//    _vehicleType2.price = @"55.0万元";
//    _vehicleType2.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType2.image = @"1.jpg";
//    [array1 addObject:_vehicleType2];
//    [_vehicleType2 release];
//    
//    VehicleType * _vehicleType3 = [[VehicleType alloc] init];
//    _vehicleType3.title = @"XF";
//    _vehicleType3.price = @"55.0万元";
//    _vehicleType3.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType3.image = @"3.jpg";
//    [array1 addObject:_vehicleType3];
//    [_vehicleType3 release];
//    
//    VehicleType * _vehicleType4 = [[VehicleType alloc] init];
//    _vehicleType4.title = @"XF";
//    _vehicleType4.price = @"55.0万元";
//    _vehicleType4.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType4.image = @"0.jpg";
//    [array1 addObject:_vehicleType4];
//    [_vehicleType4 release];
//    
//    VehicleType * _vehicleType5 = [[VehicleType alloc] init];
//    _vehicleType5.title = @"XF";
//    _vehicleType5.price = @"55.0万元";
//    _vehicleType5.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType5.image = @"1.jpg";
//    [array2 addObject:_vehicleType5];
//    [_vehicleType5 release];
//    
//    VehicleType * _vehicleType6 = [[VehicleType alloc] init];
//    _vehicleType6.title = @"XF";
//    _vehicleType6.price = @"55.0万元";
//    _vehicleType6.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType6.image = @"3.jpg";
//    [array2 addObject:_vehicleType6];
//    [_vehicleType6 release];
//    
//    VehicleType * _vehicleType7 = [[VehicleType alloc] init];
//    _vehicleType7.title = @"XF";
//    _vehicleType7.price = @"55.0万元";
//    _vehicleType7.displacement = @"0L 0L 3L 4.2L 5L";
//    _vehicleType7.image = @"0.jpg";
//    [array2 addObject:_vehicleType7];
//    [_vehicleType7 release];
//     
//    [self.carsTable.usedCarsArray addObject:array1];
//    [self.carsTable.usedCarsArray addObject:array2];
//    [array1 release];
//    [array2 release];
//    [self.carsTable reloadData];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addButtonsToChoiceView];
    [self readNewDataSource];
    //self.carsTable.viewController = self;
    self.carsTable.carsDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action
- (void)buttonPressed:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 101:
            [self.btnNew setBackgroundImage:[UIImage imageNamed:@"newCar_1@2x.png"] forState:UIControlStateNormal];
            [self.btnUsed setBackgroundImage:[UIImage imageNamed:@"usedCar_1@2x.png"] forState:UIControlStateNormal];
            [self readNewDataSource];
            break;
        case 102:
            [self.btnNew setBackgroundImage:[UIImage imageNamed:@"newCar_2@2x.png"] forState:UIControlStateNormal];
            [self.btnUsed setBackgroundImage:[UIImage imageNamed:@"usedCar_2@2x.png"] forState:UIControlStateNormal];
            [self performSelector:@selector(sendAPI)];
            break;
    }
    NSLog(@"%d", buttonTag);
}

- (void)sendAPI {
    //    http://www.ard9.com/qiche/index.php?c=channel&a=type_json&tid=26
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=channel&a=type_json&tid=26" andArgs:nil delegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    NSLog(@"array,,,%@",[array description]);
    for (NSDictionary *d in array) {
        UsedCarInfo *info = [[UsedCarInfo alloc] init];
        [info fromDic:d];
        [self.carsTable.usedCarsArray addObject:info];
        [info release];
    }
    [self.carsTable reloadData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"error!");
}




- (IBAction)back:(id)sender {
    [self backToHomeView:self.navigationController];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [_choiceView release];
    [_carsTable release];
    [super dealloc];
}

#pragma mark - CarsTableDelegate
-(UIViewController *)viewController
{
    return self;
}

@end
