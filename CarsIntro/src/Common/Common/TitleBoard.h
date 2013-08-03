//
//  TitleBoard.h
//  DropDownList
//
//  Created by kingyee on 11-9-19.
//  Copyright 2011 Kingyee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol TitleBoardDelegate

- (void)didSelectAtIndex:(NSIndexPath *)indexPath;
- (void)didSelectAtIndexPath:(NSInteger) index;

@end

@interface TitleBoardItem : NSObject
{
	NSString *title;
}
@property (retain) NSString *title;

@end

@interface TitleBoard : UIControl <UIPickerViewDelegate, UIPickerViewDataSource>{
	id <TitleBoardDelegate>	_delegate;
}

@property (assign) id <TitleBoardDelegate> delegate;

- (void)updateView:(NSArray *)_arrTitles selectIndex:(NSInteger)_selectIndex;
@end
