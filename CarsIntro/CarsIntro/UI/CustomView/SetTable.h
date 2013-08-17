//
//  SetTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SetTable : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray * setArray;
@property (nonatomic, assign) UIViewController *controller;

@end