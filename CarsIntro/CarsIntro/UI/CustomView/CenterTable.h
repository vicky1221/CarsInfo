//
//  CenterTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-13.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterTable : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * centerArray;

@property (nonatomic, assign) UIViewController * viewController;

@end
