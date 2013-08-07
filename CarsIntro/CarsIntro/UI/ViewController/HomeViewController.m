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

@interface HomeViewController ()<ASIHTTPRequestDelegate> {
    NSMutableArray *cycleArray;
    UINavigationController *infoNav;
    UINavigationController *carsNav;
    UINavigationController * activityNav;
    UINavigationController * setNav;
    UINavigationController * memberNav;
    UINavigationController * loginNav;
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
//    [self.contentView.layer setCornerRadius:5];
    
    float contentY = VIEW_BOTTOM(self.xlCycleScrollView) + (VIEW_HEIGHT(self.view) - VIEW_BOTTOM(self.xlCycleScrollView))/2;
    
    self.contentView.frame = CGRectMake(VIEW_LEFT(self.contentView), VIEW_TOP(self.contentView), VIEW_WIDTH(self.contentView), Button_Height*3);
    self.contentView.center = CGPointMake(VIEW_WIDTH(self.view)/2, contentY);
    self.homeViewbackImage.image = [[UIImage imageNamed:@"HomeBtn_backGround"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    self.homeViewbackImage.frame = CGRectMake(VIEW_LEFT(self.contentView)-2, VIEW_TOP(self.contentView)-3.5f, VIEW_WIDTH(self.contentView)+5, VIEW_HEIGHT(self.contentView)+6);
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
    [self initXLCycleScrollView];
    [self addButtonsToContentView];
    [self performSelector:@selector(sendAPI)];
	// Do any additional setup after loading the view.
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
    [memberNav release];
    [setNav release];
    [infoNav release];
    [carsNav release];
    [activityNav release];
    [cycleArray release];
    [super dealloc];
}

- (void)sendAPI {
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=article&a=ad_list_json&tid=5" andArgs:nil delegate:self];
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
        case 0:
            break;
        case 1:{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //NSString *userID = [defaults objectForKey:UserID];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"1" forKey:@"uid"];
            ASIHTTPRequest* request = [[WebRequest instance] requestWithCatagory:nil MothodName:@"qiandao" andArgs:dic delegate:self];
            request.tag = 1;
            return;
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSString *userID = [defaults objectForKey:UserID];
//            NSLog(@"这是用户ID:%@",userID);
//            if (userID && userID.length > 0) {
////                    client/clientRequestV1.php?method=qiandao&uid=用户编号
//                NSDictionary *dic = [NSDictionary dictionaryWithObject:userID forKey:@"uid"];
//                ASIHTTPRequest* request = [[WebRequest instance] requestWithCatagory:nil MothodName:@"qiandao" andArgs:dic delegate:self];
//                request.tag = 1;
//            } else {
//                
//                [self toMemberView:nil];
//            }
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
    self.isLogin = YES;
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
        [[iToast makeText:@"签到成功"] show];
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
        
    }
}

@end
