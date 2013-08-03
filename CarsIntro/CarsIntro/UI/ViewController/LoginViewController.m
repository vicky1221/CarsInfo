//
//  LoginViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 7/10/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UIView+custom.h"
#import "HomeViewController.h"
@interface LoginViewController ()
{
    UINavigationController * registerNav;
}
@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.navigationController.view.frame = CGRectMake(0, VIEW_HEIGHT(self.navigationController.view), VIEW_WIDTH(self.navigationController.view), VIEW_HEIGHT(self.navigationController.view));
    } completion:^(BOOL finished) {
        nil;
    }];
}

- (IBAction)login:(id)sender {
    if (registerNav) {
        [self pushCurrentViewController:self toNavigation:registerNav isAdded:YES Driection:4];
    } else {
        RegisterViewController * registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];        
        registerNav = [[UINavigationController alloc] initWithRootViewController:registerVC];
        registerNav.navigationBarHidden = YES;
        [registerVC release];
        [self pushCurrentViewController:self toNavigation:registerNav isAdded:NO Driection:4];
        registerVC.isRegister = YES;
    }
}

- (IBAction)Register:(id)sender {
    
    if (registerNav) {
        [self pushCurrentViewController:self toNavigation:registerNav isAdded:YES Driection:4];
    } else {
        RegisterViewController * registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
        registerNav = [[UINavigationController alloc] initWithRootViewController:registerVC];
        registerNav.navigationBarHidden = YES;
        [registerVC release];
        
        [self pushCurrentViewController:self toNavigation:registerNav isAdded:NO Driection:4];
        registerVC.isRegister = NO;
    }
}

//重写了KBaseViewController的方法
- (void) backToHomeView:(UINavigationController *)navController {
    [UIView animateWithDuration:0.1 animations:^{
        navController.view.alpha = 0;
    } completion:^(BOOL finished) {
        navController.view.hidden = YES;
    }];
}


- (IBAction)toHomeVC:(id)sender {
    [self backToHomeView:self.navigationController];
}

-(void)dealloc
{
    [registerNav release];
    [super dealloc];
}

@end
