//
//  UIImage+custom.m
//  KaraokeShare
//
//  Created by Li juan on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+custom.h"

@implementation UIImage (custom)

+(UIImage*)defaultImage {
	return [UIImage imageNamed:@"avatar_default"];
}

//截取部分图像  
-(UIImage*)getSubImage:(CGRect)rect  
{
	CGRect _rect;
	_rect.origin.x =  rect.origin.x * self.scale;
	_rect.origin.y =  rect.origin.y * self.scale;
	_rect.size.width = rect.size.width * self.scale;
	_rect.size.height = rect.size.height * self.scale;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, _rect);  
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
	
    UIGraphicsBeginImageContext(smallBounds.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
	CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
	
    return smallImage;  
}

-(UIImage*)hightlightImage
{
	CGRect bounds = CGRectMake(0, 0, CGImageGetWidth(self.CGImage), CGImageGetHeight(self.CGImage));
	
    UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self drawInRect:bounds blendMode:kCGBlendModeExclusion alpha:0.7];
	UIImage *hlImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

	return hlImage;
}

//等比例缩放  
-(UIImage*)scaleToSize:(CGSize)size   
{  
    CGFloat width = CGImageGetWidth(self.CGImage);  
    CGFloat height = CGImageGetHeight(self.CGImage);  
	
    float verticalRadio = size.height*1.0/height;   
    float horizontalRadio = size.width*1.0/width;  
	
    float radio = 1;  
    if(verticalRadio>1 && horizontalRadio>1)  
    {  
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;     
    }  
    else  
    {  
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;     
    }  
	
    width = width*radio;  
    height = height*radio;  
	
    int xPos = (size.width - width)/2;  
    int yPos = (size.height-height)/2;  
	
    // 创建一个bitmap的context    
    // 并把它设置成为当前正在使用的context    
    UIGraphicsBeginImageContext(size);    
	
    // 绘制改变大小的图片    
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];    
	
    // 从当前context中创建一个改变大小后的图片    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();    
	
    // 使当前的context出堆栈    
    UIGraphicsEndImageContext();    
	
    // 返回新的改变大小后的图片    
    return scaledImage;  
}  
@end
