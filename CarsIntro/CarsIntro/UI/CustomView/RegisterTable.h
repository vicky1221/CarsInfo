//
//  RegisterTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-10.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterTable : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * registerArray;
@property (nonatomic, retain) NSMutableArray * loginArray;

@property (assign) BOOL isRegister;

@end
