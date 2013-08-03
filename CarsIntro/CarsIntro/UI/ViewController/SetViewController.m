//
//  SetViewController.m
//  CarsIntro
//
//  Created by qianfeng on 6/25/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "SetViewController.h"

@implementation SetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)readDataSource
{
    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"0.jpg", @"KEY_IMAGE", @"4S店信息", @"KEY_INFO", nil];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"1.jpg", @"KEY_IMAGE", @"用户反馈", @"KEY_INFO", nil];
    NSDictionary * dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"3.jpg", @"KEY_IMAGE", @"版本信息", @"KEY_INFO", nil];
    [self.setTable.setArray addObjectsFromArray:[NSArray arrayWithObjects:dict1, dict2, dict3, nil]];
    self.setTable.backgroundColor = [UIColor clearColor];
    self.setTable.backgroundView = nil;
    [self.setTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self readDataSource];
}

- (void)dealloc {
    [_setTable release];
    [super dealloc];
}

#pragma mark - Button Action
- (IBAction)buttonPressed:(UIButton *)sender {
    [self backToHomeView:self.navigationController];
}

@end
