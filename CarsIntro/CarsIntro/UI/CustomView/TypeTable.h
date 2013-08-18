//
//  TypeTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeCell.h"
#import "KBaseTableView.h"
@interface TypeTable : KBaseTableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * typeArray;

@property (nonatomic, assign) UIViewController * viewController;
@end
