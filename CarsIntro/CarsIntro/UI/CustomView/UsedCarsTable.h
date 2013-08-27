//
//  UsedCarsTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-26.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBaseTableView.h"
#import "UsedCarsCell.h"
@interface UsedCarsTable : KBaseTableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * UsedCarsArray;
@property (nonatomic, assign) UIViewController *viewController;
@end
