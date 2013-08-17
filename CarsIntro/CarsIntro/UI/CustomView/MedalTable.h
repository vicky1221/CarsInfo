//
//  MedalTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-15.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedalTable : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * medalArray;

@property (nonatomic, assign) UIViewController * viewController;

@end
