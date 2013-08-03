//
//  RegisterViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 7/10/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "MemberViewController.h"
#import "RegisterCell.h"
#import "UIView+custom.h"
#import "LoginViewController.h"

@interface RegisterViewController ()
{
    HomeViewController * homeVC;
    MemberViewController * memberVC;
    UINavigationController * loginNav;
}
@end

@implementation RegisterViewController

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
    if (self.isRegister) {
        self.registerTable.isRegister = YES;
        self.titleLabel.text = @"会员登录";
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.registerTable.loginArray addObjectsFromArray:[NSArray arrayWithObjects:@"用户名/手机号", @"密码", nil]];
    }else {
        self.registerTable.isRegister = NO;
        self.titleLabel.text = @"会员注册";
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerTable.registerArray addObjectsFromArray:[NSArray arrayWithObjects:@"用户名/手机号", @"密码", @"邮箱", nil]];
    }
    [self.registerTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readDataSource];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    homeVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    memberVC = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写了KBaseViewController的方法
- (void) backToHomeView:(UINavigationController *)navController {
    [UIView animateWithDuration:0.1 animations:^{
        navController.view.alpha = 0;
    } completion:^(BOOL finished) {
        navController.view.hidden = YES;
    }];
}

#pragma mark - button Action

- (IBAction)back:(id)sender {    
    if (loginNav) {
        [self pushCurrentViewController:self toNavigation:loginNav isAdded:YES Driection:5];
    } else {
        LoginViewController * loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginNav.navigationBarHidden = YES;
        [loginVC release];
        [self pushCurrentViewController:self toNavigation:loginNav isAdded:NO Driection:5];
    }
}


- (IBAction)toHomeVC:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (IBAction)loginButton:(id)sender {
    NSArray *cells = [self.registerTable visibleCells];
    NSMutableArray *textArray = [NSMutableArray array];
    for (RegisterCell *cell in cells) {
        [textArray addObject:cell.textField.text];
    }
    
    NSLog(@"textArray :%@", [textArray description]);

    for (NSString *str in textArray) {
        if (str.length == 0) {
            UIAlertView *alert = nil;
            if (self.isRegister) {
                alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名或者密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            } else {
                alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名密码邮箱都不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            }
            [alert show];
            [alert release];
            return;
        }
    }
    
    //用户注册
    if ([textArray count] == 3) {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[textArray objectAtIndex:0], UserName, [textArray objectAtIndex:1], Password, [textArray objectAtIndex:2], @"email", nil];
        NSLog(@"dict: %@", dict);
        [self.dataArray addObject:dict];
        NSLog(@"dataArray: %@", self.dataArray);
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.dataArray forKey:@"data"];
        [defaults synchronize];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
    //用户登录
    if ([textArray count] == 2) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * array = [defaults objectForKey:@"data"];
        NSLog(@",,,,%@", array);
        for (NSDictionary *dic in array) {
            NSLog(@"dic...%@", dic);
            if ([[textArray objectAtIndex:0] isEqualToString:[dic objectForKey:UserName]] && [[textArray objectAtIndex:1] isEqualToString:[dic objectForKey:Password]]) {
                //memberVC.isPush = NO;
                [self.navigationController pushViewController:memberVC animated:YES];  //退出登录时pop
            };
        }
    }
    // 发送注册API
}

- (void)dealloc {
    [loginNav release];
    [homeVC release];
    [memberVC release];
    [_dataArray release];
    [_titleLabel release];
    [_registerTable release];
    [_loginBtn release];
    [super dealloc];
}
@end
