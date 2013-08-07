//
//  PersonViewController.m
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import "PersonViewController.h"
#import "UIView+custom.h"
@interface PersonViewController ()

@end

@implementation PersonViewController

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
    NSDictionary * dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Center_0.png", @"KEY_IMAGE", nil];
    NSDictionary * dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Center_1.png", @"KEY_IMAGE", nil];
    NSDictionary * dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Center_2.png", @"KEY_IMAGE", nil];
    NSDictionary * dict4 = [NSDictionary dictionaryWithObjectsAndKeys:@"Center_3.png", @"KEY_IMAGE", nil];
    NSDictionary * dict5 = [NSDictionary dictionaryWithObjectsAndKeys:@"Center_4.png", @"KEY_IMAGE", nil];
    NSDictionary * dict6 = [NSDictionary dictionaryWithObjectsAndKeys:@"Center_1.png", @"KEY_IMAGE", nil];
    [self.personTable.personArray addObjectsFromArray:[NSArray arrayWithObjects:dict1, dict2, dict3, dict4, dict5, dict6, nil]];
    [self.personTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.titleView.layer setShadowOpacity:0.3];
    [self.titleView.layer setShadowRadius:1];
    [self.titleView.layer setShadowOffset:CGSizeMake(0.5,0.5)];
    
    [self.contentView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.contentView.layer setShadowOpacity:0.3];
    [self.contentView.layer setShadowOffset:CGSizeMake(1, 1)];
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(VIEW_WIDTH(self.scrollView), VIEW_HEIGHT(self.scrollView) * 1.18);
    
    [self readDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_titleView release];
    [_personTable release];
    [_contentView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setTitleView:nil];
    [self setPersonTable:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}
#pragma mark - button Action
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)toHome:(id)sender {
    [self backToHomeView:self.navigationController];
}

@end
