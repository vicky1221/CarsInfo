//
//  MyQuestionViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/17/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "JSON.h"

@interface MyQuestionViewController ()

@end

@implementation MyQuestionViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[WebRequest instance] clearRequestWithTag:34];
}

- (void)sendAPI{
     [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=message&a=type_json&tid=11&from=app&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:34];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *str = [request responseString];
    NSArray *array = [NSArray arrayWithArray:[str JSONValue]];
    for (NSDictionary *d in array) {
        
    }
                      
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    //    [myActive finishEGOHead];
}

@end
