//
//  UIAsyncImageView.h
//  KaraokeShare
//
//  Created by Li juan on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	UIAsyncImageType_Default = 0,
	UIAsyncImageType_RoundRadius = 1,
	UIAsyncImageType_BoundRect = 2,
	UIAsyncImageType_ClipToHeight = 4,
	UIAsyncImageType_ClearBg = 8,
	UIAsyncImageType_RoundRadiusSmallImage = 16,
	UIAsyncImageType_UseCustomBackgroundImage = 32,
	UIAsyncImageType_RadiusShadow = 64,
	UIAsyncImageType_Circly = 128,
	UIAsyncImageType_CircleNoBorder = 256,
	UIAsyncImageType_Fuzzy = 512, //模糊效果
	UIAsyncImageType_ClipToTop = 1024, // 从上边剪切
	UIAsyncImageType_ClipToDown = 2048, // 从下边剪切
} UIAsyncImageType;

@interface UIAsyncImageView : UIControl
{
	UIImageView				*m_pImageView;
	UIActivityIndicatorView *m_pIndicator;
	BOOL                    m_isStarted;
    
    NSString                *m_url;
	
	UIAsyncImageType		m_type;
	
	int						customTag;
	
	NSObject				*customObject;
	
	BOOL					animation;
	
	UIImage					*m_image;
	BOOL					hasImage;
	CGFloat					nCorner;
	
	CGSize					shadowOffset;
	CGColorRef				shadowColor;
	CGFloat					shadowOpacity;
	
	BOOL					noHighlight;
	float					brightness;
}
@property (nonatomic, retain) UIImageView				*m_pImageView;
@property (nonatomic, retain) UIActivityIndicatorView   *m_pIndicator;
@property (nonatomic) BOOL                              m_isStarted;
@property (nonatomic, retain) UIImage                   *image;
@property (nonatomic, retain) NSString                  *url;
@property (nonatomic, assign) int						customTag;
@property (nonatomic, retain) NSObject					*customObject;
@property (nonatomic, assign) CGFloat					nCorner;
@property (nonatomic, assign) CGSize					shadowOffset;
@property (nonatomic, assign) CGColorRef				shadowColor;
@property (nonatomic, assign) CGFloat					shadowOpacity;

+ (void) reset:(id)obj;
+ (void) reset;
+ (id) push;
+ (void) pop;
+ (void) remove:(id)obj;
+ (void)removeCache:(NSString *)url;
+ (void)LoadImage:(NSString *)strURL finishedBlock:(void (^)(UIImage *image))finishBlock failedBlock:(void (^)(NSError *error))failedBlock;
+ (void)storeImage:(UIImage *)image forKey:(NSString *)strURL toDisk:(BOOL)toDisk;
+ (BOOL)isCachedForURL:(NSString *)strURL fromDisk:(BOOL)fromDisk;
+ (void) cancel;

- (void) LoadImageIfCached:(NSString *)strURL foundBlock:(void (^)(UIImage *))foundBlock notFoundBlock:(void (^)(void))notFoundBlock;
- (void) LoadImage:(NSString *) strURL;
- (void) LoadImage:(NSString *) strURL finishedBlock:(void (^)(UIImage *image))finishBlock failedBlock:(void (^)(NSError *error))failedBlock;
- (void) LoadImage:(NSString *)strURL animation:(BOOL)_animation;
- (void) setImageLoadStype:(UIAsyncImageType)type;
- (void) setDefaultImage;
- (void) setImage:(UIImage *)image animation:(BOOL)animation;

- (void) enableHighlight:(BOOL)enable;
- (void) setBrightness:(float)value; // -1.0 ~ 1.0

- (void)reload;
@end