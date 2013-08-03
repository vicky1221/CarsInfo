//
//  PersonTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-30.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTable : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * personArray;

@end
