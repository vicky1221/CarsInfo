//
//  MOrderTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-8.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOrderTable : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * mOrderArray;

@end
