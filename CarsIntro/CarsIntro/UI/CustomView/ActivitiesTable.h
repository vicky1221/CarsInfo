//
//  ActivitiesTable.h
//  CarsIntro
//
//  Created by cuishuai on 13-7-9.
//  Copyright (c) 2013年 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KBaseTableView.h"

@protocol ActivitiesTableDelegate <NSObject>
@optional
-(UIViewController *)viewController;
@end

@interface ActivitiesTable : KBaseTableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray * activityArray;
@property (nonatomic, retain) NSMutableArray * couponArray;
@property (nonatomic, assign) BOOL isActivityData;
@property (assign) id<ActivitiesTableDelegate> ActivitiesDelegate;
@end
