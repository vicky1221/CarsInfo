//
//  InfoTable.m
//  CarsIntro
//
//  Created by Cao Vicky on 6/26/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import "InfoTable.h"
#import "InfoCell.h"
#import "DynamicViewController.h"
@implementation InfoTable

- (void)myInit {
    self.delegate = self;
    self.dataSource = self;
    self.infoArray = [NSMutableArray array];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self myInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self myInit];
    }
    return self;
}

- (void)dealloc {
    [_infoArray release];
    [super dealloc];
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.infoArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *kCellID = @"InfoCell";
    InfoCell *infoCell = (InfoCell *)[self dequeueReusableCellWithIdentifier:kCellID];
    if (infoCell == nil) {
        infoCell = [[[NSBundle mainBundle] loadNibNamed:kCellID owner:nil options:nil] objectAtIndex:0];
    }
    Information *info = [self.infoArray objectAtIndex:indexPath.row];
    [infoCell cellForDic:info];
    return infoCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Information *info = [self.infoArray objectAtIndex:indexPath.row];
    DynamicViewController * dynamicVC = [[DynamicViewController alloc] initWithNibName:@"DynamicViewController" bundle:nil];
    dynamicVC.infoID = info.infoId;
    [self.viewController.navigationController pushViewController:dynamicVC animated:YES];
    [dynamicVC release];
}

@end
