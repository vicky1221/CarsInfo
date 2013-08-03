//
//  RegisterViewController.h
//  CarsIntro
//
//  Created by Cao Vicky on 7/10/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "KBaseViewController.h"
#import "RegisterTable.h"
#import "LoginViewController.h"

@interface RegisterViewController : KBaseViewController

@property (assign) BOOL isRegister;

- (IBAction)back:(id)sender;

- (IBAction)toHomeVC:(id)sender;

- (IBAction)loginButton:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *loginBtn;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet RegisterTable *registerTable;

@property (retain, nonatomic) NSMutableArray * dataArray; //存注册信息
@property (assign, nonatomic) UINavigationController *nav;
@property (assign, nonatomic) LoginViewController *loginVC;
@property (assign, nonatomic) IBOutlet UIView *keyBordView;

@end
