//
//  FBackViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-8-16.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "FBackViewController.h"

@interface FBackViewController ()

@end

@implementation FBackViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toHome:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (IBAction)ratiningBtn:(id)sender {
}

@end
