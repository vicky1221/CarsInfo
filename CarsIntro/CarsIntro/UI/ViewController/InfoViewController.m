//
//  InfoViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 6/26/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "InfoViewController.h"
#import "Information.h"
#import "JSON.h"
#import "iToast.h"

@interface InfoViewController () <ASIHTTPRequestDelegate>

@end

@implementation InfoViewController

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
    [self performSelector:@selector(sendAPI)];
	self.infoTable.viewController = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_infoTable release];
    [super dealloc];
}

#pragma mark - IBAction

- (IBAction)back:(id)sender {
    [self backToHomeView:self.navigationController];
}

- (void)sendAPI {
//    http://www.ard9.com/qiche/index.php?c=article&a=type_json&tid=33
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=article&a=type_json&tid=33" andArgs:nil delegate:self];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    for (NSDictionary *d in array) {
        Information *info = [[Information alloc] init];
        [info fromDic:d];
        [self.infoTable.infoArray addObject:info];
        [info release];
    }
    [self.infoTable reloadData];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
}

@end
