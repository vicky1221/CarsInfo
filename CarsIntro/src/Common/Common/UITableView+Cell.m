//
//  UITableView+Cell.m
//  KaraokeShare
//
//  Created by Li juan on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UITableView+Cell.h"

@implementation UITableView (Cell)

static NSMutableDictionary	*m_cellDict;

- (void)customRegisterNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier {

	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
		if (m_cellDict == nil) {
			m_cellDict = [[NSMutableDictionary alloc] initWithCapacity:10];
		}
		[m_cellDict setObject:nib forKey:identifier];
	} else {
		[self registerNib:nib forCellReuseIdentifier:identifier];
	}
}

- (id)customDequeueReusableCellWithIdentifier:(NSString *)identifier {
	id ret;
	ret = [self dequeueReusableCellWithIdentifier:identifier];
	if (ret == nil) {
		UINib *nib = [m_cellDict objectForKey:identifier];
		ret = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
	}
	
	return ret;
}
@end
