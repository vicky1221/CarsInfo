//
//  MyQuestionViewController.m
//  CarsIntro
//
//  Created by Cao Vicky on 8/17/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "MyQuestionViewController.h"
#import "JSON.h"
#import "NSString+Date.h"
#import "UIView+custom.h"

@interface MyQuestionViewController () {
    NSMutableArray *array;
}

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
    array = [[NSMutableArray alloc] initWithCapacity:10];
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

- (void)dealloc {
    [array release];
    [super dealloc];
}

- (void)sendAPI{
     [[WebRequest instance] requestWithCatagory:@"get" MothodName:[NSString stringWithFormat:@"c=message&a=type_json&tid=11&from=app&uid=%@", [DataCenter shareInstance].accont.loginUserID] andArgs:nil delegate:self andTag:34];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *str = [request responseString];
    [array addObjectsFromArray:[NSArray arrayWithArray:[str JSONValue]]];
    [questionTable reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    //    [myActive finishEGOHead];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [array count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kCellID = @"QuetionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    NSDictionary *dic = [array objectAtIndex:indexPath.row];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    titleLabel.text = [dic objectForKey:@"body"];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 38, 300, 16)];
    timeLabel.text = [[dic objectForKey:@"addtime"] dateStringSince1970];
    timeLabel.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1];
    timeLabel.textAlignment = UITextAlignmentRight;
    [cell.contentView addSubview:timeLabel];
    timeLabel.font = [UIFont systemFontOfSize:11];
    [timeLabel release];
    return cell;
    
}

@end
