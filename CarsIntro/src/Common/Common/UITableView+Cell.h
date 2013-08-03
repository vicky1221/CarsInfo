//
//  UITableView+Cell.h
//  KaraokeShare
//
//  Created by Li juan on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Cell)
- (void)customRegisterNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (id)customDequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
