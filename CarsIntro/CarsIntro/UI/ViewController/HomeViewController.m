//
//  HomeViewController.m
//  CarsIntro
//
//  Created by banshenggua03 on 6/24/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "HomeViewController.h"
#import "UIView+custom.h"
#import "MemberViewController.h"
#import "SetViewController.h"
#import "CarsViewController.h"
#import "ActivitiesViewController.h"
#import "LoginViewController.h"
#import "InfoViewController.h"
#import "ASIHTTPRequest.h"
#import "iToast.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "UIAsyncImageView.h"
#import "WeatherViewController.h"

@interface HomeViewController ()<ASIHTTPRequestDelegate> {
    NSInteger abc; //判断签到次数
    NSMutableArray *cycleArray;
    UINavigationController *infoNav;
    UINavigationController *carsNav;
    UINavigationController * activityNav;
    UINavigationController * setNav;
    UINavigationController * memberNav;
    UINavigationController * loginNav;
    UINavigationController * weatherNav;
}
@end

@implementation HomeViewController

#define Button_Width    151
#define Button_Height   74

- (void)initXLCycleScrollView {
    cycleArray = [[NSMutableArray alloc] init];
    self.xlCycleScrollView.datasource = self;
}

- (void)addButtonsToContentView {
    
    for (int i = 0; i < 6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag  = i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Home_%d", i]] forState:UIControlStateNormal];
        float x = VIEW_WIDTH(self.contentView)/2 + (i%2?1:-1)*Button_Width/2;
        float y = i/2*Button_Height+Button_Height/2;
        button.frame = CGRectMake(0, 0, Button_Width, Button_Height);
        button.center = CGPointMake(x, y);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    [self.contentView.layer setCornerRadius:5];
//    
//    float contentY = VIEW_BOTTOM(self.xlCycleScrollView) + (VIEW_HEIGHT(self.view) - VIEW_BOTTOM(self.xlCycleScrollView))/2;
//    
//    self.contentView.frame = CGRectMake(VIEW_LEFT(self.contentView), VIEW_TOP(self.contentView), VIEW_WIDTH(self.contentView), Button_Height*3);
//    self.contentView.center = CGPointMake(VIEW_WIDTH(self.view)/2, contentY);
//    self.homeViewbackImage.image = [[UIImage imageNamed:@"HomeBtn_backGround"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
//    self.homeViewbackImage.frame = CGRectMake(VIEW_LEFT(self.contentView)-2, VIEW_TOP(self.contentView)-3.5f, VIEW_WIDTH(self.contentView)+5, VIEW_HEIGHT(self.contentView)+6);
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
    abc = 0;
    [super viewDidLoad];
    [self initXLCycleScrollView];
    [self addButtonsToContentView];
    [self performSelector:@selector(sendAPI)];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:1];
    [[WebRequest instance] clearRequestWithTag:11];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
                                                                    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [weatherNav release];
    [memberNav release];
    [setNav release];
    [infoNav release];
    [carsNav release];
    [activityNav release];
    [cycleArray release];
    [super dealloc];
}

- (void)sendAPI {
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=article&a=ad_list_json&tid=5" andArgs:nil delegate:self andTag:11];
}

#pragma mark - isLogin
-(BOOL)login
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * username = [defaults objectForKey:UserName];
    if (username && username.length > 0) {
        self.isLogin = YES;
        return self.isLogin;
    }else {
        self.isLogin = NO;
        return self.isLogin;
    }
}

#pragma mark - Button Action
- (void)buttonPressed:(id)sender {
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 0: {
            if (weatherNav) {
                [self pushCurrentViewController:self toNavigation:weatherNav isAdded:YES Driection:1];
            } else {
                WeatherViewController * weatherVC = [[WeatherViewController alloc] initWithNibName:@"WeatherViewController" bundle:nil];
                weatherNav = [[UINavigationController alloc] initWithRootViewController:weatherVC];
                weatherNav.navigationBarHidden = YES;
                [weatherVC release];
                [self pushCurrentViewController:self toNavigation:weatherNav isAdded:NO Driection:1];
            }

        }
            break;
        case 1:{
            if ([[DataCenter shareInstance].accont isAnonymous]) {
                [self toMemberView:nil];
            } else {
//                http://www.ard9.com/qiche/index.php?c=member&a=release&tid=32&hand=161444713&id=&go=1&from=app
                ASIHTTPRequest* request = [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=release&tid=32&hand=161444713&id=&go=1&from=app&uid=%@&qdsj=%0.f", [DataCenter shareInstance].accont.loginUserID, [[NSDate date] timeIntervalSince1970]] andArgs:nil delegate:self];
                request.tag = 1;
            }
        }
            break;
        case 2:{
            if (carsNav) {
                [self pushCurrentViewController:self toNavigation:carsNav isAdded:YES Driection:1];
            } else {
                CarsViewController * carsVC = [[CarsViewController alloc] initWithNibName:@"CarsViewController" bundle:nil];
                carsNav = [[UINavigationController alloc] initWithRootViewController:carsVC];
                carsNav.navigationBarHidden = YES;
                [carsVC release];
                [self pushCurrentViewController:self toNavigation:carsNav isAdded:NO Driection:1];
            }
        }
            break;
        case 3:{
            if (infoNav) {
                [self pushCurrentViewController:self toNavigation:infoNav isAdded:YES Driection:1];
            } else {
                InfoViewController *_infoVC = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
                infoNav = [[UINavigationController alloc] initWithRootViewController:_infoVC];
                infoNav.navigationBarHidden = YES;
                [_infoVC release];
                [self pushCurrentViewController:self toNavigation:infoNav isAdded:NO Driection:1];
                
            }
        }
            break;
        case 4:{
            if (activityNav) {
                [self pushCurrentViewController:self toNavigation:activityNav isAdded:YES Driection:1];
            } else {
                ActivitiesViewController *_activityVC = [[ActivitiesViewController alloc] initWithNibName:@"ActivitiesViewController" bundle:nil];
                activityNav = [[UINavigationController alloc] initWithRootViewController:_activityVC];
                activityNav.navigationBarHidden = YES;
                [_activityVC release];
                [self pushCurrentViewController:self toNavigation:activityNav isAdded:NO Driection:1];
            }
        }
            break;
        case 5:{
            [self toMemberView:nil];
        }
            break;
    }
    NSLog(@"%d", buttonTag);
}

- (IBAction)toMemberView:(id)sender {
    self.isLogin = ![DataCenter shareInstance].accont.isAnonymous;
    if (self.isLogin) {
        if (memberNav) {
            [self pushCurrentViewController:self toNavigation:memberNav isAdded:YES Driection:2];
        } else {
            MemberViewController * _memberVC = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
            memberNav = [[UINavigationController alloc] initWithRootViewController:_memberVC];
            memberNav.navigationBarHidden = YES;
            [_memberVC release];
            [self pushCurrentViewController:self toNavigation:memberNav isAdded:NO Driection:2];
        }
        
    } else {
        if (loginNav) {
            [self pushCurrentViewController:self toNavigation:loginNav isAdded:YES Driection:3];
        } else {
            LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginNav.navigationBarHidden = YES;                     
            [loginVC release];
            [self pushCurrentViewController:self toNavigation:loginNav isAdded:NO Driection:3];
        }        
    }
}
                

- (IBAction)toSetView:(id)sender {
    if (setNav) {
        [self pushCurrentViewController:self toNavigation:setNav isAdded:YES Driection:2];
    } else {
        SetViewController *_setVC = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
        setNav = [[UINavigationController alloc] initWithRootViewController:_setVC];
        setNav.navigationBarHidden = YES;
        [_setVC release];
        [self pushCurrentViewController:self toNavigation:setNav isAdded:NO Driection:2];
    }

}

#pragma mark - XLCycleScrollViewDatasource
- (NSInteger)numberOfPages {
    return [cycleArray count];
}

- (UIView *)pageAtIndex:(NSInteger)index {
    UIAsyncImageView *v = [[[UIAsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)] autorelease];
    [v enableHighlight:NO];
    [v setImageLoadStype:UIAsyncImageType_Default];
    NSString *imageURL = [cycleArray objectAtIndex:index];
    [v LoadImage:imageURL];
    return v;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == 1) {
        NSDictionary *dic = [[request responseString] JSONValue];
        if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            [[iToast makeText:[dic objectForKey:@"msg"]] show];
        }
    } else {                                                    
        //NSString *str = [request responseString];
        NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
        if (array.count > 0) {
            for (NSDictionary *dic in array) {
                NSString *imageUrl = [NSString stringWithFormat:@"%@%@", ServerAddress, [dic objectForKey:@"adfile"]];
                [cycleArray addObject:imageUrl];
            }
            [self.xlCycleScrollView reloadData];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    if (request.tag == 1) {
        NSLog(@"签到失败");
    }
}

@end
