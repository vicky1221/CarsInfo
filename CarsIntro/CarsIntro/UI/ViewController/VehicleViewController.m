//
//  VehicleViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "VehicleViewController.h"
#import "UIView+custom.h"
#import "ParameterViewController.h"
#import "CImageViewController.h"
#import "Parameter.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "JSON.h"
#import "iToast.h"

@interface VehicleViewController ()<ASIHTTPRequestDelegate> {
    NSMutableArray *fieldArray;
    NSDictionary *dataDic;
    NSMutableArray *parameterArray;
}

@end

@implementation VehicleViewController

#define Button_Width    152
#define Button_Height   36

- (void)addButtonsToScrollview
{
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.tag = 101;
    [button1 setBackgroundImage:[UIImage imageNamed:@"btn_online"] forState:UIControlStateNormal];
    float x = VIEW_WIDTH(self.scrollView)/2 - Button_Width/2;
    float y = (Button_Width - 100)/2;
    button1.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    button1.center = CGPointMake(x, y);
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button1];
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.tag = 102;
    [button2 setBackgroundImage:[UIImage imageNamed:@"btn_phone"] forState:UIControlStateNormal];
    x = VIEW_WIDTH(self.scrollView)/2 + Button_Width/2;
    y = (Button_Width - 100)/2;
    button2.frame = CGRectMake(0, 0, Button_Width, Button_Height);
    button2.center = CGPointMake(x, y);
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button2];
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView)*1.5);
}

- (void)initCarsImageView {
//    [self.carsImageView.layer setCornerRadius:3];
    [self.carsImageView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.carsImageView.layer setShadowOpacity:0.5];
    [self.carsImageView.layer setShadowOffset:CGSizeMake(2, 2)];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)readDataSource
{
    Parameter * parameter1 = [[Parameter alloc] init];
    parameter1.title = @"厂商指导价";
    parameter1.content = self.vehicleType.price;
    [self.vehicleTable.vehicleArray addObject:parameter1];
    [parameter1 release];
    
    Parameter * parameter2 = [[Parameter alloc] init];
    parameter2.title = @"变速箱";
    parameter2.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter2];
    [parameter2 release];
    
    Parameter * parameter3 = [[Parameter alloc] init];
    parameter3.title = @"驱动方式";
    parameter3.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter3];
    [parameter3 release];
    
    Parameter * parameter4 = [[Parameter alloc] init];
    parameter4.title = @"排量";
    parameter4.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter4];
    [parameter4 release];
    
    Parameter * parameter5 = [[Parameter alloc] init];
    parameter5.title = @"质保";
    parameter5.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter5];
    [parameter5 release];
    
    Parameter * parameter6 = [[Parameter alloc] init];
    parameter6.title = @"综合工况油耗";
    parameter6.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter6];
    [parameter6 release];
    
    Parameter * parameter7 = [[Parameter alloc] init];
    parameter7.title = @"厂家";
    parameter7.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter7];
    [parameter7 release];
    
    Parameter * parameter8 = [[Parameter alloc] init];
    parameter8.title = @"车体结构";
    parameter8.content = @"";
    [self.vehicleTable.vehicleArray addObject:parameter8];
    [parameter8 release];
    
    self.vehicleTable.backgroundColor = [UIColor clearColor];
    self.vehicleTable.backgroundView = nil;
    [self.vehicleTable reloadData];
    self.vehicleTable.scrollEnabled = NO;
}

- (void)viewDidLoad
{
    
//    http://www.ard9.com/qiche/index.php?c=channel&molds=esc&a=info_json&id=编号
//    http://www.ard9.com/qiche/index.php?c=product&a=info_json&id=20
    
    [super viewDidLoad];
    dataDic = [[NSDictionary alloc] init];
    fieldArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
    
    [self addButtonsToScrollview];
    [self readDataSource];
    [self initCarsImageView];
    
    self.typeLabel.text = self.vehicleType.title;
    [self.asyImageView  LoadImage:self.vehicleType.litpic];
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imagePress:)];
    [self.asyImageView addGestureRecognizer:imageTap];
    [imageTap release];
    
    [self shadowView:self.questionView];
    
    [self performSelector:@selector(sendAPI)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_carsImageView release];
    [_typeLabel release];
    [_asyImageView release];
    [_vehicleType release];
    [_scrollView release];
    [_vehicleTable release];
    [fieldArray release];
    [dataDic release];
    [super dealloc];
}

- (void)sendAPI {
//    http://www.ard9.com/qiche/index.php?c=product&a=info_json_field
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=product&a=info_json_field" andArgs:nil delegate:self andTag:56];
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=product&a=info_json&id=20" andArgs:nil delegate:self andTag:57];
}

#pragma mark - image Action

-(void)imagePress:(UITapGestureRecognizer*)recognizer
{
    CImageViewController * vc = [[CImageViewController alloc] initWithNibName:@"CImageViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    vc.asyImageView.image = self.asyImageView.image;
    [vc release];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button:(id)sender {
    ParameterViewController * parmeterVC = [[ParameterViewController alloc] initWithNibName:@"ParameterViewController" bundle:nil];
    parmeterVC.vehicleType = self.vehicleType;
    [self.navigationController pushViewController:parmeterVC animated:YES];
    [parmeterVC release];
    NSLog(@"1111");
}

#pragma mark - UIActionSheetDelegate

-(void)buttonPressed:(id)sender
{
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 101: {
            if ([[DataCenter shareInstance].accont isAnonymous]) {
                LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                loginNav.navigationBarHidden = YES;
                [loginVC release];
                [self pushCurrentViewController:self toNavigation:loginNav isAdded:NO Driection:3];
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    self.onlineView.transform = CGAffineTransformMakeTranslation(-320, 0);
                }];
                self.questionView.text = @"";
            }
        }
            break;
        case 102:{
            UIActionSheet * as=[[UIActionSheet alloc] initWithTitle:@"拨打商家热线" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"电话-4008170818-1001" otherButtonTitles:nil, nil];
            [as showInView:self.view];
            [as release];
        }
            break;
    }
    NSLog(@"%d", buttonTag);
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex==1) {
        return;
    }
    if (buttonIndex==0) {
        NSLog(@"打电话");
    }
}

- (void)onlineViewBack {
    [UIView animateWithDuration:0.5 animations:^{
        self.onlineView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}

- (IBAction)sendQuestion:(id)sender {
    [self onlineViewBack];
}

- (IBAction)onlineback:(id)sender {
    
//     http://www.ard9.com/qiche/index.php?c=message&a=add&tid=11&from=app
    [self onlineViewBack];
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=message&a=add&tid=11&from=app&title=在线咨询&body=%@&uid=%@", self.questionView.text,[DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:55];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == 55) {
        [iToast makeText:@"提交成功"];
    } else if (request.tag == 56) {
        NSArray *array = [[request responseString] JSONValue];
        [fieldArray addObjectsFromArray:array];
        if (dataDic.allKeys.count>0) {
            [self bindData];
        }
    } else if (request.tag == 57) {
        [dataDic release];
        dataDic = [[request responseString] JSONValue];
        if (fieldArray.count > 0) {
            [self bindData];
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
}

- (void)bindData {
    for (int i = 0; i < fieldArray.count; i++) {
        NSDictionary *d = [fieldArray objectAtIndex:i];
        Parameter *par = [[Parameter alloc] init];
        par.title = [d objectForKey:@"fieldsname"];
        par.content = [dataDic objectForKey:[NSString stringWithFormat:@"%@",[d objectForKey:@"fields"]]];
        [parameterArray addObject:par];
        [par release];
    }
    [self.vehicleTable reloadData];
}

@end
