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

@interface InfoViewController () <ASIHTTPRequestDelegate, TableEGODelegate> {
    BOOL isStart;
}

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
    self.infoTable.kdelegate = self;
    [self.infoTable createEGOHead];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:4];
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
    [[WebRequest instance] requestWithCatagory:@"get" MothodName:@"c=article&a=type_json&tid=33" andArgs:nil delegate:self andTag:4];
    isStart = YES;
}                                                                   

- (void)requestFinished:(ASIHTTPRequest *)request {
    [self.infoTable.infoArray removeAllObjects];
    NSArray *array = [NSArray arrayWithArray:[[request responseString] JSONValue]];
    for (NSDictionary *d in array) {
        Information *info = [[Information alloc] init];
        [info fromDic:d];
        [self.infoTable.infoArray addObject:info];
        [info release];
    }
    isStart = NO;
    [self.infoTable reloadData];
    [self.infoTable finishEGOHead];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    [self.infoTable finishEGOHead];
    isStart = NO;
}

- (BOOL)shouldEgoHeadLoading:(UITableView *)tableView {
    return isStart;
}
- (void)triggerEgoHead:(UITableView *)tableView {
    [self sendAPI];
}

@end
