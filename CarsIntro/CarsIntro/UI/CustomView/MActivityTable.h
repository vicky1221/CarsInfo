//
//  MActivityTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-8-23.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MActivityTable : UITableView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * MActivityArray;
@end
