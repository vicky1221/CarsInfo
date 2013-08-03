//
//  UIAsyncImageView.m
//  KaraokeShare
//
//  Created by Li juan on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "UIAsyncImageView.h"
#import "QuartzCore/QuartzCore.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "UIImage+custom.h"
#import "SDImageCacheDelegate.h"
#import <Accelerate/Accelerate.h>
#import "GPUImage.h"

@interface UIAsyncImageView (sdcache) <SDImageCacheDelegate>

@end

@implementation UIAsyncImageView
@synthesize m_pImageView;
@synthesize m_pIndicator;
@synthesize m_isStarted;
@synthesize image;
@synthesize url = m_url;
@synthesize	customTag;
@synthesize customObject;
@synthesize nCorner;
@synthesize shadowColor, shadowOffset, shadowOpacity;


+ (void)reset:(id)obj {
}

+ (void)reset {
}

+ (id)push {
	return nil;
}

+ (void)pop {
}

+ (void)remove:(id)obj {
}

+ (void)removeCache:(NSString *)url {
	[[SDImageCache sharedImageCache] removeImageForKey:url];
}

- (void)reload {
	if (hasImage) {
		return;
	}
	[self LoadImage:m_url];
}

- (UIImage *)getClipImage:(UIImage *)_image {
	if (self.bounds.size.height == self.bounds.size.width) {
		return _image;
	}
	CGFloat scale = self.bounds.size.height / self.bounds.size.width;
	CGFloat height = _image.size.height * scale;
	if (height > _image.size.height)
		height = _image.size.height;
	CGFloat y = (_image.size.height - height) /2;
	CGRect rect = CGRectMake(0, y, _image.size.width, height);
	
	UIImage *scaleImg = [_image getSubImage:rect];
	return scaleImg;
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect
{
	
}

#pragma mark - highlight selected
- (void)setHighlighted:(BOOL)highlighted
{
	if (noHighlight) {
		[super setHighlighted:highlighted];
		return;
	}
	
	if (highlighted) {
		if (m_image) {
//			m_pImageView.image = [m_image brightness:brightness + 1.2];
			GPUImageBrightnessFilter *filter = [[[GPUImageBrightnessFilter alloc] init] autorelease];
			filter.brightness = brightness + 0.2;
			m_pImageView.image = [filter imageByFilteringImage:m_image];
		}
	} else {
		if (m_image)
			m_pImageView.image = m_image;
	}
	[super setHighlighted:highlighted];
}

- (void)enableHighlight:(BOOL)enable
{
	noHighlight = !enable;
}

- (void)setBrightness:(float)value
{
	brightness = value - 0.2;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
}

#pragma mark - 判断是否有缓存
+ (BOOL)isCachedForURL:(NSString *)strURL fromDisk:(BOOL)fromDisk
{
	UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromKey:strURL fromDisk:fromDisk];
	return cacheImg != nil;
}

+ (void)storeImage:(UIImage *)image forKey:(NSString *)strURL toDisk:(BOOL)toDisk {
	NSData *data = UIImageJPEGRepresentation(image, 1);
	[[SDImageCache sharedImageCache] storeImage:image imageData:data forKey:strURL toDisk:toDisk];
}

+ (void)LoadImage:(NSString *)strURL
	finishedBlock:(void (^)(UIImage *image))finishedBlock
	  failedBlock:(void (^)(NSError *error))failedBlock
{
	SDWebImageManager *manager = [SDWebImageManager sharedManager];
//	NSLog(@"UIAsyncImageView start download %@", strURL);
	[manager downloadWithURL:[NSURL URLWithString:strURL] delegate:self options:0 success:finishedBlock failure:failedBlock];
}

+ (void)cancel {
	SDWebImageManager *manager = [SDWebImageManager sharedManager];
	[manager cancelForDelegate:self];
}

- (void) LoadImageIfCached:(NSString *)strURL
				foundBlock:(void (^)(UIImage *))foundBlock
			 notFoundBlock:(void (^)(void))notFoundBlock
{
	self.url = strURL;
	if (m_image == nil) {
		[self setDefaultImage];
	}
	NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:Block_copy(notFoundBlock), @"notfound_block", Block_copy(foundBlock), @"found_block", nil];
	[[SDImageCache sharedImageCache] queryDiskCacheForKey:strURL delegate:self userInfo:info];
}

- (void) LoadImage:(NSString *) strURL
{
	[self LoadImage:strURL finishedBlock:^(UIImage *image) {
		;
	} failedBlock:^(NSError *error) {
		;
	}];
}

- (void) LoadImage:(NSString *) strURL finishedBlock:(void (^)(UIImage *image))finishBlock failedBlock:(void (^)(NSError *error))failedBlock
{
	m_isStarted = NO;
	self.url = strURL;
	
	if (m_type & UIAsyncImageType_ClearBg) { //请求图片时无默认背景
		[m_pImageView setImageWithURL:[NSURL URLWithString:strURL] success:^(UIImage *_image) {
			[self setImage:_image];
			finishBlock(_image);
			m_isStarted = NO;
		} failure:^(NSError *error) {
			failedBlock(error);
			m_isStarted = NO;
		}];
	} else if (m_type & UIAsyncImageType_UseCustomBackgroundImage) {
		// 请求图片有默认背景
		// 如果直接判断m_image会用问题，因为有复用的AsyImage，例如首页
		
		//请求图片时没有默认背景，用默认的背景
		[self LoadImageIfCached:strURL foundBlock:^(UIImage *_image) {
			[self setImage:_image];
			finishBlock(_image);
			m_isStarted = NO;
		} notFoundBlock:^{
			[m_pImageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:m_image success:^(UIImage *_image) {
				[self setImage:_image];
				finishBlock(_image);
				m_isStarted = NO;
			} failure:^(NSError *error) {
				failedBlock(error);
				m_isStarted = NO;
			}];
		}];

	} else if (m_type & UIAsyncImageType_Fuzzy) {
		// 请求图片有默认背景
		// 如果直接判断m_image会用问题，因为有复用的AsyImage，例如首页
		
		//请求图片时没有默认背景，用默认的背景
		[self LoadImageIfCached:strURL foundBlock:^(UIImage *_image) {
			GPUImageGaussianBlurFilter *filter = [[[GPUImageGaussianBlurFilter alloc] init] autorelease];
			filter.blurSize = 1;
			_image = [filter imageByFilteringImage:_image];
//			_image = [self boxblurImage:_image boxSize:39];
			[self setImage:_image];
			finishBlock(_image);
			m_isStarted = NO;
		} notFoundBlock:^{
			[m_pImageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[self getClipImage:[UIImage defaultImage]] success:^(UIImage *_image) {
				GPUImageGaussianBlurFilter *filter = [[[GPUImageGaussianBlurFilter alloc] init] autorelease];
				filter.blurSize = 1;
				_image = [filter imageByFilteringImage:_image];
//				_image = [self boxblurImage:_image boxSize:39];
				[self setImage:_image];
				finishBlock(_image);
				m_isStarted = NO;
			} failure:^(NSError *error) {
				failedBlock(error);
				m_isStarted = NO;
			}];
		}];
		
	} else {
		 //请求图片时没有默认背景，用默认的背景
		 [self LoadImageIfCached:strURL foundBlock:^(UIImage *_image) {
			 [self setImage:_image];
			 finishBlock(_image);
			 m_isStarted = NO;
		 } notFoundBlock:^{
			 [m_pImageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[self getClipImage:[UIImage defaultImage]] success:^(UIImage *_image) {
				 [self setImage:_image];
				 finishBlock(_image);
				 m_isStarted = NO;
			 } failure:^(NSError *error) {
				 failedBlock(error);
				 m_isStarted = NO;
			 }];
		 }];
	 }
	
	hasImage = NO;

	m_isStarted = TRUE;
}

- (void) LoadImage:(NSString *)strURL animation:(BOOL)_animation {
	animation = _animation;

	[self LoadImage:strURL];
}

- (void)setShadowColor:(CGColorRef)sColor {
	shadowColor = sColor;
	self.layer.shadowColor = sColor;
}

- (void)setShadowOffset:(CGSize)sOffset {
	shadowOffset = sOffset;
	self.layer.shadowOffset = sOffset;
}

- (void)setShadowOpacity:(CGFloat)sOpacity {
	shadowOpacity = sOpacity;
	self.layer.shadowOpacity = sOpacity;
}

- (void)setImageLoadStype:(UIAsyncImageType)type {
	m_type = type;
//	nCorner = 20;
	m_pImageView.frame = self.bounds;
	if (m_type & UIAsyncImageType_RoundRadius) {
		[m_pImageView.layer setMasksToBounds:YES];
		[m_pImageView.layer setCornerRadius:nCorner ? nCorner : 6];
		
	} else if (m_type & UIAsyncImageType_BoundRect) {
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = 0;
		self.layer.borderWidth = 0;
//		self.layer.borderWidth = 1;
		//		self.layer.borderColor = [[UIColor grayColor] CGColor];
		self.layer.borderColor = [[UIColor clearColor] CGColor];
		
//		m_pImageView.frame = CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4);
		m_pImageView.frame = self.bounds;
	} else if (m_type & UIAsyncImageType_RadiusShadow) {
		self.layer.shadowRadius = 0.3;
		self.layer.shadowOffset = CGSizeMake(0, 0.5f);
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOpacity = 0.5f;
		
		[m_pImageView.layer setMasksToBounds:YES];
		[m_pImageView.layer setCornerRadius:nCorner ? nCorner : 6];
	} else if (m_type & UIAsyncImageType_Circly) {
		m_pImageView.frame = CGRectMake(0, 0, self.bounds.size.width - 2, self.bounds.size.height - 2);
		m_pImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		
		[m_pImageView.layer setMasksToBounds:YES];
		[m_pImageView.layer setCornerRadius:m_pImageView.frame.size.width / 2];
		[self.layer setMasksToBounds:NO];
		[self.layer setCornerRadius:self.bounds.size.width/2];
		self.layer.borderWidth = 2;
		self.layer.backgroundColor = [UIColor clearColor].CGColor;
		
//		m_pImageView.layer.borderWidth = 2;
//		m_pImageView.layer.backgroundColor = [UIColor clearColor].CGColor;
		self.layer.shadowRadius = 2;
		self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOpacity = 0.4;
		self.layer.borderColor = [UIColor whiteColor].CGColor;
		

//		m_pImageView.layer.borderWidth = 2;
//		m_pImageView.layer.borderColor = [UIColor whiteColor].CGColor;//[UIColor colorWithRed:228/255 green:228/255 blue:228/255 alpha:1].CGColor;
//		m_pImageView.layer.borderColor = [UIColor colorWithRed:228/255 green:228/255 blue:228/255 alpha:1].CGColor;
	} else if (m_type & UIAsyncImageType_CircleNoBorder) {
		[m_pImageView.layer setMasksToBounds:YES];
		[m_pImageView.layer setCornerRadius:m_pImageView.frame.size.width / 2];
	}
	else {
		self.layer.masksToBounds = NO;
		m_pImageView.frame = self.bounds;
	}
    
    if (m_type & UIAsyncImageType_ClearBg) {
        self.backgroundColor = [UIColor clearColor];
        m_pImageView.backgroundColor = [UIColor clearColor];
    }
}

- (void)myInit {
	if (self.m_pImageView)
		return;
	
    // Initialization code.
    self.m_pImageView = [[[UIImageView alloc] init] autorelease];
	m_pImageView.contentMode = UIViewContentModeScaleToFill;
    m_pImageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self setImageLoadStype:UIAsyncImageType_Default];

    [self addSubview:m_pImageView];
    
    CGRect frame = CGRectMake(self.frame.size.width/2 - 10, self.frame.size.height/2 - 10, 20, 20);
    if (m_type != UIAsyncImageType_Default) {
        m_pIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        [m_pIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:m_pIndicator];
    }
    
    m_isStarted = NO;
    m_url =nil;
}
- (id)init {
    self = [super init];
    [self myInit];
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self myInit];
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self myInit];
    return self;
}

- (UIImage *) image {
	return m_image;
//    return m_pImageView.image;
}


- (void) setDefaultImage
{
//	[m_pImageView cancelCurrentImageLoad];
	m_pImageView.image = [self getClipImage:[UIImage defaultImage]];
	[m_image release];
	m_image = nil;
}

- (void)setImage:(UIImage *)l_image {
	[self setImage:l_image animation:animation];
}

- (void) setImage:(UIImage *)l_image animation:(BOOL)_animation {
//	NSLog(@"%@ 0 setImage, animation %d", self, _animation);
	
	if (l_image != m_image) {
		[m_image release];
		m_image = [l_image retain];
	}
    
    if (m_image == nil) {
        hasImage = NO;
		m_pImageView.image = nil;
        return;
    }
	
//	NSLog(@"%@ 1 setImage, animation %d", self, _animation);
	
	if ((m_type & UIAsyncImageType_ClipToHeight) || (m_type & UIAsyncImageType_ClipToTop) || (m_type & UIAsyncImageType_ClipToDown)) {
		
		CGFloat imgScale = m_image.size.height / m_image.size.width;
		CGFloat scale = self.bounds.size.height / self.bounds.size.width;
		CGRect rect;
		
#if 0
		if (imgScale != scale) {
			if (imgScale > scale) {
				CGFloat height = m_image.size.width * scale;
				rect = CGRectMake(0, (m_image.size.height - height) /2, m_image.size.width, height);
				
				UIImage *scaleImg = [m_image getSubImage:rect];
				NSLog(@"UIAsyncImageView scaleImg %@", NSStringFromCGSize(scaleImg.size));
				[m_image release];
				m_image = [scaleImg retain];
			} else {
				CGFloat height = self.bounds.size.width * imgScale;
				
				m_pImageView.frame = CGRectMake(0, (self.bounds.size.height - height)/2, self.bounds.size.width, height);
			}
		}
#else
		if (imgScale != scale) {
			if (m_type & UIAsyncImageType_ClipToTop) {
				if (imgScale > scale) {
					CGFloat height = m_image.size.width * scale;
					rect = CGRectMake(0, 0, m_image.size.width, height);
				} else if (imgScale < scale) {
					rect = CGRectMake((m_image.size.width - m_image.size.width * imgScale / scale) / 2, 0, m_image.size.width * imgScale / scale, m_image.size.height);
				}
			} else if (m_type & UIAsyncImageType_ClipToDown) {
				if (imgScale > scale) {
					CGFloat height = m_image.size.width * scale;
					rect = CGRectMake(0, (m_image.size.height - height), m_image.size.width, height);
				} else if (imgScale < scale) {
					rect = CGRectMake((m_image.size.width - m_image.size.width * imgScale / scale) / 2, m_image.size.height - m_image.size.height, m_image.size.width * imgScale / scale, m_image.size.height);
				}
			} else if (m_type & UIAsyncImageType_ClipToHeight) {
				if (imgScale > scale) {
					CGFloat height = m_image.size.width * scale;
					rect = CGRectMake(0, (m_image.size.height - height) /2, m_image.size.width, height);
				} else if (imgScale < scale) {
					CGFloat width = m_image.size.height / scale;
					rect = CGRectMake((m_image.size.width - width) /2, 0, m_image.size.height, width);
				}
			}
			
			UIImage *scaleImg = [m_image getSubImage:rect];
//			NSLog(@"UIAsyncImageView scaleImg %@", NSStringFromCGSize(scaleImg.size));
			[m_image release];
			m_image = [scaleImg retain];
		}
#endif
		
//		NSLog(@"UIAsyncImageView image %@", NSStringFromCGSize(m_image.size));
	}
    
	m_pImageView.image = m_image;
	
	if (_animation) {
		m_pImageView.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 1, 1);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:0.01];
		[UIView setAnimationDuration:0.5];
		if (m_type & UIAsyncImageType_BoundRect) {
			m_pImageView.frame = CGRectMake(2, 2, self.bounds.size.width-4, self.bounds.size.height-4);
		} else {
			m_pImageView.frame = self.bounds;
		}
		[UIView commitAnimations];
	}
	
	hasImage = YES;
}


- (void)dealloc {
	LogD(@"%@ dealloc", self);
	
//	[m_pImageView cancelCurrentImageLoad];
	[m_pImageView release];

    [m_url release];
	
	[customObject release];
	
	[m_image release];
	
    [super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ url:%@", [super description], m_url];
}

#pragma mark - 模糊效果
// 模糊效果
-(UIImage *)boxblurImage:(UIImage *)image_ boxSize:(int)boxSize {
    CGImageRef img = image_.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
	
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //create CGImageRef from vImage_Buffer output
    //1 - CGBitmapContextCreateImage -
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
	
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //2 CGImageCreate - alternative - has a leak
    
    /*
	 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	 CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, outBuffer.data, outBuffer.height * outBuffer.rowBytes, releasePixels);
	 CGImageRef imageRef = CGImageCreate(outBuffer.width, outBuffer.height, 8, 32, outBuffer.rowBytes, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaLast, provider, NULL, NO, kCGRenderingIntentPerceptual);
	 
	 UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
	 */
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
	
}

#pragma mark - SDImageCacheDelegate
- (void)imageCache:(SDImageCache *)imageCache didFindImage:(UIImage *)_image forKey:(NSString *)key userInfo:(NSDictionary *)info
{
	void (^notFoundBlock)(void) = [info objectForKey:@"notfound_block"];
	Block_release(notFoundBlock);
	
	void (^foundBlock)(UIImage *image) = [info objectForKey:@"found_block"];
	foundBlock(_image);
	Block_release(foundBlock);
}
- (void)imageCache:(SDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info
{
	void (^foundBlock)(void) = [info objectForKey:@"found_block"];
	Block_release(foundBlock);

	[self setDefaultImage];
	
	void (^notFoundBlock)(void) = [info objectForKey:@"notfound_block"];
	notFoundBlock();
	Block_release(notFoundBlock);
}


@end
