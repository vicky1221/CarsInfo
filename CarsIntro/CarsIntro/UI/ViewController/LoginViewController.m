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
    RegisterViewController * registerVC;
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
    [registerVC release];
    registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerVC.loginVC = self;
    registerVC.nav = self.navigationController;

    registerVC.isRegister = YES;
    [self.view addSubview:registerVC.view];
    registerVC.view.frame = CGRectMake(0, -VIEW_HEIGHT(registerVC.view), VIEW_WIDTH(registerVC.view), VIEW_HEIGHT(registerVC.view));
    [UIView animateWithDuration:0.5 animations:^{
        registerVC.view.frame = CGRectMake(0, 0, VIEW_WIDTH(registerVC.view), VIEW_HEIGHT(registerVC.view));
        self.currentView.frame = CGRectMake(0, VIEW_HEIGHT(self.currentView), VIEW_WIDTH(self.currentView), VIEW_HEIGHT(self.currentView));
    } completion:^(BOOL finished) {
        
    }];
//    [registerVC release];
}

- (IBAction)Register:(id)sender {
    [registerVC release];
    registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerVC.loginVC = self;
    registerVC.nav = self.navigationController;
    registerVC.isRegister = NO;
    [self.view addSubview:registerVC.view];
    registerVC.view.frame = CGRectMake(0, -VIEW_HEIGHT(registerVC.view), VIEW_WIDTH(registerVC.view), VIEW_HEIGHT(registerVC.view));
    [UIView animateWithDuration:0.5 animations:^{
        registerVC.view.frame = CGRectMake(0, 0, VIEW_WIDTH(registerVC.view), VIEW_HEIGHT(registerVC.view));
        self.currentView.frame = CGRectMake(0, VIEW_HEIGHT(self.currentView), VIEW_WIDTH(self.currentView), VIEW_HEIGHT(self.currentView));
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)toHomeVC:(id)sender {
    [self backToHomeView:self.navigationController WithTime:0.1];
}

-(void)dealloc
{
    [registerVC release];
    [super dealloc];
}

@end
