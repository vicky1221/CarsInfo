//
//  UIImage+custom.h
//  KaraokeShare
//
//  Created by Li juan on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (custom)
-(UIImage*)getSubImage:(CGRect)rect;  
-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage*)hightlightImage;
+(UIImage*)defaultImage;
@end
