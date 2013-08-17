//
//  CarsTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBaseTableView.h"

@protocol CarsTableDelegate <NSObject>
@optional
- (UIViewController *)viewController;

@end

@interface CarsTable :KBaseTableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * newCarsArray;
@property (nonatomic, retain) NSMutableArray * usedCarsArray;
@property (nonatomic, assign) BOOL isNewCarData;
//@property (nonatomic, assign) UIViewController *viewController;
@property (assign) id<CarsTableDelegate> carsDelegate;

@end

