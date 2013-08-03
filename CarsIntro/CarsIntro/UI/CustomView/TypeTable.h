//
//  TypeTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeCell.h"
@interface TypeTable : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * xfArray;
@property (nonatomic, retain) NSMutableArray * xjArray;
@property (nonatomic, assign) BOOL isXfData;
@property (nonatomic, assign) UIViewController * viewController;
@end
