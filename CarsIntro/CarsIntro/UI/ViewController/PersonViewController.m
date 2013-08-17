//
//  PersonViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "PersonViewController.h"
#import "UIView+custom.h"
#import "MOrderViewController.h"
#import "CenterViewController.h"
#import "MedalViewController.h"
@interface PersonViewController () {
    Account *myAccount;
}
@end

@implementation PersonViewController

#define Button_Width    303
#define Button_Height   58

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addButtonsToContentView
{
    int j = 4;
    for (int i = 0; i < j; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag  = i;
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"Center_%d", i]] forState:UIControlStateNormal];
        float x = VIEW_WIDTH(self.contentView)/2;
        float y = i*Button_Height+Button_Height/2;
        button.frame = CGRectMake(0, 0, Button_Width, Button_Height);
        button.center = CGPointMake(x, y);
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    float delta = 58*j-VIEW_HEIGHT(self.contentView);
    self.contentView.frame = VIEW_FRAME_HB(self.contentView, 0, delta);
    self.logoutButton.frame = VIEW_FRAME_HB(self.logoutButton, delta, 0);
    CGSize size = self.scrollView.contentSize;
    self.scrollView.contentSize = CGSizeMake(size.width, size.height+delta);
}                                                            
                                                            
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    myAccount = [DataCenter shareInstance].accont;
    [self shadowView:self.titleView];
    [self shadowView:self.contentView];
    [self addButtonsToContentView];
    self.UserNameLabel.text = myAccount.userName;
    self.ScoreLabel.text = myAccount.UserScore;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_titleView release];
    [_contentView release];
    [_UserNameLabel release];
    [_ScoreLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTitleView:nil];
    [self setContentView:nil];
    [self setUserNameLabel:nil];
    [self setScoreLabel:nil];
    [super viewDidUnload];
}
#pragma mark - button Action
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)toHome:(id)sender {
    [self backToHomeView:self.navigationController];
}
- (IBAction)logout:(id)sender {
    [[DataCenter shareInstance].accont logout];
    [self toHome:nil];
}
-(void)buttonPressed:(id)sender
{
    NSInteger buttonTag = ((UIButton *)sender).tag;
    switch (buttonTag) {
        case 0: {
            CenterViewController * centerVC = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
            [self.navigationController pushViewController:centerVC animated:YES];
            [centerVC release];
        }
            break;
        case 1: {
            MedalViewController * medalVC = [[MedalViewController alloc] initWithNibName:@"MedalViewController" bundle:nil];
            [self.navigationController pushViewController:medalVC animated:YES];
            [medalVC release];
        }
            break;
        case 3: {
            MOrderViewController * mOrderVC = [[MOrderViewController alloc] initWithNibName:@"MOrderViewController" bundle:nil];
            [self.navigationController pushViewController:mOrderVC animated:YES];
            [mOrderVC release];
        }
            break;
        default:
            break;
    }

}

@end
