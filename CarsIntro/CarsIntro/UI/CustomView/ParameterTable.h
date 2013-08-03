//
//  ParameterTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-18.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterCell.h"
@interface ParameterTable : UITableView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray * parameterArray;
@end
