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
#import "iToast.h"
#import "JSON.h"

@interface RegisterViewController () <ASIHTTPRequestDelegate, UITextFieldDelegate>
{
    HomeViewController * homeVC;
    MemberViewController * memberVC;
    UINavigationController * loginNav;
    NSMutableArray *textFieldArray;
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
        self.loginBtn.center = CGPointMake(VIEW_WIDTH(self.view)/2, VIEW_HEIGHT(self.view)/2);
        [self.loginBtn setImage:[UIImage imageNamed:@"LoginBtn"] forState:UIControlStateNormal];
        [self.registerTable.loginArray addObjectsFromArray:[NSArray arrayWithObjects:@"用户名", @"密码", nil]];
    }else {
        self.registerTable.isRegister = NO;
        self.titleLabel.text = @"会员注册";
        self.loginBtn.center = CGPointMake(VIEW_WIDTH(self.view)/2, VIEW_HEIGHT(self.view)-106);
        [self.loginBtn setImage:[UIImage imageNamed:@"RegisterBtn"] forState:UIControlStateNormal];
        [self.registerTable.registerArray addObjectsFromArray:[NSArray arrayWithObjects:@"用户名", @"密码", @"确认密码", @"手机号", @"邮箱", nil]];
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
    textFieldArray = [[NSMutableArray alloc] init];
    [self addTextDelegate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:2];
    [[WebRequest instance] clearRequestWithTag:3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [textFieldArray release];
    [loginNav release];
    [homeVC release];
    [memberVC release];
    [_dataArray release];
    [_titleLabel release];
    [_registerTable release];
    [_loginBtn release];
    [super dealloc];
}

- (void)addTextDelegate {
    NSArray *cells = [self.registerTable visibleCells];
    for (int i = 0; i<cells.count; i++) {
        RegisterCell *cell = [cells objectAtIndex:i];
        cell.textField.tag = i;
        cell.textField.delegate = self;
        [textFieldArray addObject:cell.textField];
    }
}

#pragma mark - button Action

- (IBAction)back:(id)sender {
    [self hideKeyView];
    [UIView animateWithDuration:0.5 animations:^{
        self.loginVC.currentView.frame = CGRectMake(0, 0, VIEW_WIDTH(self.loginVC.currentView), VIEW_HEIGHT(self.loginVC.currentView));
        self.view.frame = CGRectMake(0, -VIEW_HEIGHT(self.view), VIEW_WIDTH(self.view), VIEW_HEIGHT(self.view));
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (IBAction)toHomeVC:(id)sender {
    [self hideKeyView];
    [self backToHomeView:self.nav WithTime:0.1];
}

- (IBAction)loginButton:(id)sender {
    [self hideKeyView];
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

    if (self.isRegister){
        //用户登录
        NSString *userName = [textArray objectAtIndex:0];
        NSString *passWord = [textArray objectAtIndex:1];
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=login&go=1&from=app&url=?c=member&user=%@&pass=%@",userName, passWord] andArgs:nil delegate:self andTag:2];
    } else {
        //用户注册
        NSString *userName = [textArray objectAtIndex:0];
        NSString *email = [textArray objectAtIndex:4];
        NSString *mobile = [textArray objectAtIndex:3];
        NSString *pass1 = [textArray objectAtIndex:1];
        NSString *pass2 = [textArray objectAtIndex:2];
        [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=member&a=reg&go=1&from=app&user=%@&email=%@&mobile=%@&pass1=%@&pass2=%@",userName, email, mobile,pass1,pass2] andArgs:nil delegate:self andTag:3];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.view==self.view) {
        [self hideKeyView];
    }
}

- (void)hideKeyView {
    NSArray *cells = [self.registerTable visibleCells];
    for (RegisterCell *cell in cells) {
        [UIView animateWithDuration:0.3 animations:^{
            self.registerTable.transform = CGAffineTransformIdentity;
        }];
        [cell.textField resignFirstResponder];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == 2) {
        NSDictionary *dic = [[request responseString] JSONValue];
        if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            NSString *path = [NSString stringWithFormat:@"%@/%@",[[DataCenter shareInstance] documentPath],UserInfo];
            Account *account = [[Account alloc] init];
            [account fromDic:dic];
            NSDictionary *saveDic = [account toDic];
            if([saveDic writeToFile:path atomically:YES])
            {
                [self back:nil];
                [[DataCenter shareInstance] updateUserInfo];
            }
            [account release];
            [self toHomeVC:nil];
        }
        [iToast makeText:[dic objectForKey:@"msg"]];
    } else if (request.tag == 3) {
        NSDictionary *dic = [[request responseString] JSONValue];
        if ([[dic objectForKey:@"result"] isEqualToString:@"SUCCESS"]) {
            [self back:nil];
        }
        [iToast makeText:[dic objectForKey:@"msg"]];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [[iToast makeText:@"网络请求返回失败"] show];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag>2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.registerTable.transform = CGAffineTransformMakeTranslation(0, -44*(textField.tag-2));
        }];
    }
}

@end
