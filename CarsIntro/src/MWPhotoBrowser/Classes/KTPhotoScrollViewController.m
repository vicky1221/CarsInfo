//
//  KTPhotoScrollViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoScrollViewController.h"
#import "KTPhotoBrowserDataSource.h"
#import "KTPhotoBrowserGlobal.h"
#import "KTPhotoView.h"
#import "MBProgressHUD.h"

const CGFloat ktkDefaultPortraitToolbarHeight   = 44;
const CGFloat ktkDefaultLandscapeToolbarHeight  = 33;
const CGFloat ktkDefaultToolbarHeight = 44;

#define BUTTON_DELETEPHOTO 0
#define BUTTON_CANCEL 1

@interface KTPhotoScrollViewController (KTPrivate)
- (void)setCurrentIndex:(NSInteger)newIndex;
- (void)toggleChrome:(BOOL)hide;
- (void)startChromeDisplayTimer;
- (void)cancelChromeDisplayTimer;
- (void)hideChrome;
- (void)showChrome;
- (void)swapCurrentAndNextPhotos;
- (void)nextPhoto;
- (void)previousPhoto;
- (void)toggleNavButtons;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (void)loadPhoto:(NSInteger)index;
- (void)unloadPhoto:(NSInteger)index;
- (void)trashPhoto;
- (void)exportPhoto;
@end

@implementation KTPhotoScrollViewController {
    MBProgressHUD *progressHUD;
}

@synthesize statusBarStyle = statusBarStyle_;
@synthesize statusbarHidden = statusbarHidden_;


- (void)dealloc 
{
    [progressHUD release];
    [nextButton_ release], nextButton_ = nil;
    [previousButton_ release], previousButton_ = nil;
    [scrollView_ release], scrollView_ = nil;
    [toolbar_ release], toolbar_ = nil;
    [photoViews_ release], photoViews_ = nil;
    [dataSource_ release], dataSource_ = nil;  
   
    [super dealloc];
}

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index 
{
   if (self = [super init]) {
     startWithIndex_ = index;
     dataSource_ = [dataSource retain];
     
     // Make sure to set wantsFullScreenLayout or the photo
     // will not display behind the status bar.
     [self setWantsFullScreenLayout:YES];
//     [self setStatusbarHidden:NO];
     self.hidesBottomBarWhenPushed = YES;
   }
   return self;
}

- (void)loadView 
{
   [super loadView];
   
   CGRect scrollFrame = [self frameForPagingScrollView];
   UIScrollView *newView = [[UIScrollView alloc] initWithFrame:scrollFrame];
   [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
   [newView setDelegate:self];
   
   UIColor *backgroundColor = [dataSource_ respondsToSelector:@selector(imageBackgroundColor)] ?
                                [dataSource_ imageBackgroundColor] : [UIColor blackColor];  
   [newView setBackgroundColor:backgroundColor];
   [newView setAutoresizesSubviews:YES];
   [newView setPagingEnabled:YES];
   [newView setShowsVerticalScrollIndicator:NO];
   [newView setShowsHorizontalScrollIndicator:NO];
   
   [[self view] addSubview:newView];
   
   scrollView_ = [newView retain];
   
   [newView release];
   
   nextButton_ = [[UIBarButtonItem alloc] 
                  initWithImage:KTLoadImageFromBundle(@"UIBarButtonItemArrowRight.png")
                  style:UIBarButtonItemStylePlain
                  target:self
                  action:@selector(nextPhoto)];
   
   previousButton_ = [[UIBarButtonItem alloc] 
                      initWithImage:KTLoadImageFromBundle(@"UIBarButtonItemArrowLeft.png")
                      style:UIBarButtonItemStylePlain
                      target:self
                      action:@selector(previousPhoto)];
   
   UIBarButtonItem *trashButton = nil;
    
   if (_isMe) {
     trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                 target:self
                                                                 action:@selector(trashPhoto)];
   }
   
    UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                  target:self
                                                                                  action:@selector(exportPhoto)];

   UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                    target:nil 
                                                                    action:nil];
   
   NSMutableArray *toolbarItems = [[NSMutableArray alloc] initWithCapacity:7];
    
    if (trashButton) [toolbarItems addObject:trashButton];
   [toolbarItems addObject:space];
   [toolbarItems addObject:previousButton_];
   [toolbarItems addObject:space];
   [toolbarItems addObject:nextButton_];
   [toolbarItems addObject:space];
    if (exportButton) [toolbarItems addObject:exportButton];
   
   CGRect screenFrame = [[UIScreen mainScreen] bounds];
   CGRect toolbarFrame = CGRectMake(0, 
                                    screenFrame.size.height - ktkDefaultToolbarHeight, 
                                    screenFrame.size.width, 
                                    ktkDefaultToolbarHeight);
   toolbar_ = [[UIToolbar alloc] initWithFrame:toolbarFrame];
   [toolbar_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin];
   [toolbar_ setBarStyle:UIBarStyleBlackTranslucent];
   [toolbar_ setItems:toolbarItems];
   [[self view] addSubview:toolbar_];
   
   if (trashButton)
       [trashButton release];
   if (exportButton)
       [exportButton release];
   [toolbarItems release];
   [space release];
}

- (void)setTitleWithCurrentPhotoIndex 
{
   NSString *formatString = NSLocalizedString(@"%1$i of %2$i", @"Picture X out of Y total.");
   NSString *title = [NSString stringWithFormat:formatString, currentIndex_ + 1, photoCount_, nil];
   [self setTitle:title];
}

- (void)scrollToIndex:(NSInteger)index 
{
   CGRect frame = scrollView_.frame;
   frame.origin.x = frame.size.width * index;
   frame.origin.y = 0;
   [scrollView_ scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
   NSInteger pageCount = photoCount_;
   if (pageCount == 0) {
      pageCount = 1;
   }

   CGSize size = CGSizeMake(scrollView_.frame.size.width * pageCount, 
                            scrollView_.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
   [scrollView_ setContentSize:size];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
  
   photoCount_ = [dataSource_ numberOfPhotos];
   [self setScrollViewContentSize];
   
   // Setup our photo view cache. We only keep 3 views in
   // memory. NSNull is used as a placeholder for the other
   // elements in the view cache array.
   photoViews_ = [[NSMutableArray alloc] initWithCapacity:photoCount_];
   for (int i=0; i < photoCount_; i++) {
      [photoViews_ addObject:[NSNull null]];
   }
    
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.minSize = CGSizeMake(120, 120);
        progressHUD.minShowTime = 1;
        progressHUD.userInteractionEnabled = NO;
        // The sample image is based on the
        // work by: http://www.pixelpressicons.com
        // licence: http://creativecommons.org/licenses/by/2.5/ca/
        progressHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/Checkmark.png"]] autorelease];
        UIWindow *windows = [[UIApplication sharedApplication].windows objectAtIndex:0];
        [windows addSubview:progressHUD];
    }
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated 
{
   [super viewWillAppear:animated];
   
   // The first time the view appears, store away the previous controller's values so we can reset on pop.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   if (!viewDidAppearOnce_) {
      viewDidAppearOnce_ = YES;
      navbarWasTranslucent_ = [navbar isTranslucent];
      statusBarStyle_ = [[UIApplication sharedApplication] statusBarStyle];
   }
   // Then ensure translucency. Without it, the view will appear below rather than under it.  
   [navbar setTranslucent:YES];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];

   // Set the scroll view's content size, auto-scroll to the stating photo,
   // and setup the other display elements.
   [self setScrollViewContentSize];
   [self setCurrentIndex:startWithIndex_];
   [self scrollToIndex:startWithIndex_];

   [self setTitleWithCurrentPhotoIndex];
   [self toggleNavButtons];
   [self startChromeDisplayTimer];
}

- (void)viewWillDisappear:(BOOL)animated 
{
  // Reset nav bar translucency and status bar style to whatever it was before.
    [super viewWillDisappear:animated];
    UINavigationBar *navbar = [[self navigationController] navigationBar];
    [navbar setTranslucent:navbarWasTranslucent_];
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle_ animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self cancelChromeDisplayTimer];
  
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    
}

- (void)deleteCurrentPhoto:(int)atIndex isError:(BOOL)isError
{
    [self hideProgressHUD:YES];
    if (isError) {
        [self showProgressHUDCompleteMessage:@"删除失败"];
    } else {
        
        NSInteger photoIndexToDelete = atIndex;
        [self unloadPhoto:photoIndexToDelete + 1];
        [self unloadPhoto:photoIndexToDelete];
        photoCount_ -= 1;
        if (photoCount_ == 0) {
            [self showChrome];
            [[self navigationController] popViewControllerAnimated:YES];
        } else {
            NSInteger nextIndex = photoIndexToDelete;
            if (nextIndex == photoCount_) {
                nextIndex -= 1;
            }
            [self setCurrentIndex:nextIndex];
            [self setScrollViewContentSize];
        }
        [self showProgressHUDCompleteMessage:@"删除成功"];
    }
}

- (void)toggleNavButtons
{
   [previousButton_ setEnabled:(currentIndex_ > 0)];
   [nextButton_ setEnabled:(currentIndex_ < photoCount_ - 1)];
}


#pragma mark -
#pragma mark Frame calculations
#define PADDING  20

- (CGRect)frameForPagingScrollView 
{
   CGRect frame = [[UIScreen mainScreen] bounds];
   frame.origin.x -= PADDING;
   frame.size.width += (2 * PADDING);
   return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
   // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
   // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
   // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
   // because it has a rotation transform applied.
   CGRect bounds = [scrollView_ bounds];
   CGRect pageFrame = bounds;
   pageFrame.size.width -= (2 * PADDING);
   pageFrame.origin.x = (bounds.size.width * index) + PADDING;
   return pageFrame;
}


#pragma mark -
#pragma mark Photo (Page) Management

- (void)loadPhoto:(NSInteger)index
{
   if (index < 0 || index >= photoCount_) {
      return;
   }
   
   id currentPhotoView = [photoViews_ objectAtIndex:index];
   if (NO == [currentPhotoView isKindOfClass:[KTPhotoView class]]) {
      // Load the photo view.
      CGRect frame = [self frameForPageAtIndex:index];
      KTPhotoView *photoView = [[KTPhotoView alloc] initWithFrame:frame];      
      [photoView setScroller:self];
      [photoView setIndex:index];
      [photoView setBackgroundColor:[UIColor clearColor]];
      
      // Set the photo image.
      if (dataSource_) {
         if ([dataSource_ respondsToSelector:@selector(imageAtIndex:photoView:)] == NO) {
            UIImage *image = [dataSource_ imageAtIndex:index];
            [photoView setImage:image];
         } else {
            [dataSource_ imageAtIndex:index photoView:photoView];
         }
      }
      
      [scrollView_ addSubview:photoView];
      [photoViews_ replaceObjectAtIndex:index withObject:photoView];
      [photoView release];
   } else {
      // Turn off zooming.
      [currentPhotoView turnOffZoom];
   }
}

- (void)unloadPhoto:(NSInteger)index
{
   if (index < 0 || index >= photoCount_) {
      return;
   }
   
   id currentPhotoView = [photoViews_ objectAtIndex:index];
   if ([currentPhotoView isKindOfClass:[KTPhotoView class]]) {
      [currentPhotoView removeFromSuperview];
      [photoViews_ replaceObjectAtIndex:index withObject:[NSNull null]];
   }
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
   currentIndex_ = newIndex;
   
   [self loadPhoto:currentIndex_];
   [self loadPhoto:currentIndex_ + 1];
   [self loadPhoto:currentIndex_ - 1];
   [self unloadPhoto:currentIndex_ + 2];
   [self unloadPhoto:currentIndex_ - 2];
   
   [self setTitleWithCurrentPhotoIndex];
   [self toggleNavButtons];
}


#pragma mark -
#pragma mark Rotation Magic

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   CGRect toolbarFrame = toolbar_.frame;
   if ((interfaceOrientation) == UIInterfaceOrientationPortrait || (interfaceOrientation) == UIInterfaceOrientationPortraitUpsideDown) {
      toolbarFrame.size.height = ktkDefaultPortraitToolbarHeight;
   } else {
      toolbarFrame.size.height = ktkDefaultLandscapeToolbarHeight+1;
   }
   
   toolbarFrame.size.width = self.view.frame.size.width;
   toolbarFrame.origin.y =  self.view.frame.size.height - toolbarFrame.size.height;
   toolbar_.frame = toolbarFrame;
}

- (void)layoutScrollViewSubviews
{
   [self setScrollViewContentSize];

   NSArray *subviews = [scrollView_ subviews];
   
   for (KTPhotoView *photoView in subviews) {
      CGPoint restorePoint = [photoView pointToCenterAfterRotation];
      CGFloat restoreScale = [photoView scaleToRestoreAfterRotation];
      [photoView setFrame:[self frameForPageAtIndex:[photoView index]]];
      [photoView setMaxMinZoomScalesForCurrentBounds];
      [photoView restoreCenterPoint:restorePoint scale:restoreScale];
   }
   
   // adjust contentOffset to preserve page location based on values collected prior to location
   CGFloat pageWidth = scrollView_.bounds.size.width;
   CGFloat newOffset = (firstVisiblePageIndexBeforeRotation_ * pageWidth) + (percentScrolledIntoFirstVisiblePage_ * pageWidth);
   scrollView_.contentOffset = CGPointMake(newOffset, 0);
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration 
{
   // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
   // place to calculate the content offset that we will need in the new orientation
   CGFloat offset = scrollView_.contentOffset.x;
   CGFloat pageWidth = scrollView_.bounds.size.width;
   
   if (offset >= 0) {
      firstVisiblePageIndexBeforeRotation_ = floorf(offset / pageWidth);
      percentScrolledIntoFirstVisiblePage_ = (offset - (firstVisiblePageIndexBeforeRotation_ * pageWidth)) / pageWidth;
   } else {
      firstVisiblePageIndexBeforeRotation_ = 0;
      percentScrolledIntoFirstVisiblePage_ = offset / pageWidth;
   }    
   
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration 
{
   [self layoutScrollViewSubviews];
   // Rotate the toolbar.
   [self updateToolbarWithOrientation:toInterfaceOrientation];
   
   // Adjust navigation bar if needed.
   if (isChromeHidden_ && statusbarHidden_ == NO) {
      UINavigationBar *navbar = [[self navigationController] navigationBar];
      CGRect frame = [navbar frame];
      frame.origin.y = 20;
      [navbar setFrame:frame];
   }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
   [self startChromeDisplayTimer];
}

- (UIView *)rotatingFooterView 
{
   return toolbar_;
}


#pragma mark -
#pragma mark Chrome Helpers

- (void)toggleChromeDisplay 
{
   [self toggleChrome:!isChromeHidden_];
}

- (void)toggleChrome:(BOOL)hide 
{
   isChromeHidden_ = hide;
   if (hide) {
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.4];
   }
   
   if ( ! [self isStatusbarHidden] ) {     
//     if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
//       [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:NO];
//     } else {  // Deprecated in iOS 3.2+.
//       id sharedApp = [UIApplication sharedApplication];  // Get around deprecation warnings.
//       [sharedApp setStatusBarHidden:hide animated:NO];
//     }
   }

   CGFloat alpha = hide ? 0.0 : 1.0;
   
   // Must set the navigation bar's alpha, otherwise the photo
   // view will be pushed until the navigation bar.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   [navbar setAlpha:alpha];

   [toolbar_ setAlpha:alpha];

   if (hide) {
      [UIView commitAnimations];
   }
   
   if ( ! isChromeHidden_ ) {
      [self startChromeDisplayTimer];
   }
}

- (void)hideChrome 
{
   if (chromeHideTimer_ && [chromeHideTimer_ isValid]) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
   [self toggleChrome:YES];
}

- (void)showChrome 
{
   [self toggleChrome:NO];
}

- (void)startChromeDisplayTimer 
{
   [self cancelChromeDisplayTimer];
   chromeHideTimer_ = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                       target:self 
                                                     selector:@selector(hideChrome)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)cancelChromeDisplayTimer 
{
   if (chromeHideTimer_) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
   CGFloat pageWidth = scrollView.frame.size.width;
   float fractionalPage = scrollView.contentOffset.x / pageWidth;
   NSInteger page = floor(fractionalPage);
	if (page != currentIndex_) {
		[self setCurrentIndex:page];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
   [self hideChrome];
}


#pragma mark -
#pragma mark Toolbar Actions

- (void)nextPhoto 
{
   [self scrollToIndex:currentIndex_ + 1];
   [self startChromeDisplayTimer];
}

- (void)previousPhoto 
{
   [self scrollToIndex:currentIndex_ - 1];
   [self startChromeDisplayTimer];
}

- (void)trashPhoto 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您确定要删除该相片吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
	[alert show];
    [alert release];
}

- (void)exportPhoto
{
    UIActionSheet *actionsSheet = nil;
    if (self.isMe) {
        actionsSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil
                                           otherButtonTitles:NSLocalizedString(@"Save", nil), NSLocalizedString(@"Remove", nil), nil] autorelease];
    } else {
        actionsSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil
                                           otherButtonTitles:NSLocalizedString(@"Save", nil), nil] autorelease];
    }
    actionsSheet.tag = 2;
    actionsSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionsSheet showInView:self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (dataSource_) {
            [self showProgressHUDWithMessage:nil];
            [dataSource_ deleteImageAtIndex:currentIndex_];
            [self showProgressHUDWithMessage:@"删除中"];
        }
    }
}

#pragma mark - MBProgressHUD

- (void)showProgressHUDWithMessage:(NSString *)message {
    progressHUD.labelText = message;
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [progressHUD show:YES];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    scrollView_.scrollEnabled = NO;
}

- (void)hideProgressHUD:(BOOL)animated {
    [progressHUD hide:animated];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    scrollView_.scrollEnabled = YES;
}

- (void)showProgressHUDCompleteMessage:(NSString *)message {
    if (message) {
        if (progressHUD.isHidden) [progressHUD show:YES];
        progressHUD.labelText = message;
        progressHUD.mode = MBProgressHUDModeCustomView;
        [progressHUD hide:YES afterDelay:1.5];
    } else {
        [progressHUD hide:YES];
    }
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    scrollView_.scrollEnabled = YES;
}

#pragma mark - Actions

- (void)savePhoto {
    KTPhotoView *photo = [photoViews_ objectAtIndex:currentIndex_];
    if ([photo underlyingImage]) {
        [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"Saving", @"Displayed with ellipsis as 'Saving...' when an item is in the process of being saved")]];
        [self performSelector:@selector(actuallySavePhoto:) withObject:photo afterDelay:0];
    }
}

- (void)actuallySavePhoto:(KTPhotoView *)photo {
    if ([photo underlyingImage]) {
        UIImageWriteToSavedPhotosAlbum([photo underlyingImage], self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self showProgressHUDCompleteMessage: error ? @"保存失败" : @"保存成功"];
    [self hideProgressHUD:YES];
//    [self hideControlsAfterDelay]; // Continue as normal...
}

#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (actionSheet.tag == 2){
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
                [self savePhoto]; return;
            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
                [self trashPhoto]; return;
            } 
        }
    }
}

@end
