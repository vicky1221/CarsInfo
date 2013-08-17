//
//  KBaseTableView.h
//  CarsIntro
//
//  Created by Cao Vicky on 8/16/13.
//  Copyright (c) 2013 banshenggua03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@protocol TableEGODelegate <NSObject>

- (BOOL)shouldEgoHeadLoading:(UITableView *)tableView;
- (void)triggerEgoHead:(UITableView *)tableView;

@end

@interface KBaseTableView : UITableView <EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_egoRefreshHeadView;
}

@property (nonatomic, assign) EGORefreshTableHeaderView *egoRefreshHeadView;
@property (nonatomic, assign) id<TableEGODelegate> kdelegate;

- (void)createEGOHead;
- (void)createEGOHead:(id<EGORefreshTableHeaderDelegate>)delegate;
- (void)removeEGOHead;
- (void)finishEGOHead;

@end
