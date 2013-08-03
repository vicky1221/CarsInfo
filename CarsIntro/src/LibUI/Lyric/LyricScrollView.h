//
//  LyricScrollView.h
//  KWPlayer
//
//  Created by YeeLion on 11-1-19.
//  Copyright 2011 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
//#import "PlayerControlBase.h"

#define offsetLyricShadow 0

#define colorLyricTextShadow  [UIColor blackColor]
#define colorLyricTextHighlighted	[UIColor yellowColor]
#define colorLyricText				[UIColor whiteColor]

@protocol PlayerUIEventDelegate

@optional
- (void) onUIEventSeek:(id)sender schedule:(NSTimeInterval)schedule;

@end


typedef enum _LYRIC_STATUS {
	lyricStatDefault = 0,//歌词界面默认显示，建议为空
	lyricStatSucceed,
	lyricStatLoading,
	lyricStatError,
	lyricStatNoneLrc
} LYRIC_STATUS;

typedef enum LyricType {
	LyricType_Default, // 多行
	LyricType_SignleLine, // 单行
	LyricType_Karaoke, // 双行
} LyricType;

int calcWordLength( const char* string, int count);

class CLyricParser;

@protocol LyricScrollDelegate

@optional
- (void) onLyricSeekBegin:(id)sender;

- (void) onLyricSeekValueChange:(id)sender;

- (void) onLyricSeekCancel:(id)sender;

- (void) onLyricSeekEnd:(id)sender;

@end

//歌词视图
@interface LyricScrollView :UIView {// PlayerControlBase {
    id delegate;
    
    NSString* _textFont;
    int _textSize;
    int _lineHeight;
    
    UIColor* _textColor;
    UIColor* _textColorHighlighted;
	UIColor* _shadowColor;
	UIColor* _strokeColor;
    
    int _lyricStatus;
    CLyricParser* _lyricParser;

    CFDictionaryRef _textAttributes;
    
    NSMutableArray* _lyricLines;    // CTLine
    int _currentLyricLine;
        
    int _offset;    // _offset is 0 when a lyric line start, and _lineHeight when lyric line end
 
    BOOL _active;
    int _schedule;
    int _duration;
    
    NSTimer* _animationTimer;
    
    BOOL _seekEnabled;
    int _seekScheduleCache;
    BOOL _seeking;
    
    int _draging;   // 0 ended, -1 start, 1 draging
    CGPoint _pointStartSeek;
    
    BOOL    m_bIsLoading;
	
	LyricType m_type;
    
    //UIPanGestureRecognizer* panGestureRecognizer;
    //UISwipeGestureRecognizer* swipeGestureRecognizer;
}

@property (nonatomic, assign) id<PlayerUIEventDelegate> delegate;

@property (nonatomic, retain) NSString* textFont;
@property (nonatomic, assign) int textSize;
@property (nonatomic, assign) int lineHeight;

@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, retain) UIColor* textColorHighlighted;
@property (nonatomic, retain) UIColor* shadowColor;
@property (nonatomic, retain) UIColor* strokeColor;

@property (nonatomic, assign) int lyricStatus;
@property (nonatomic, assign) CLyricParser* lyricParser;

@property (nonatomic, assign) BOOL active;

@property (nonatomic, assign) int schedule;
@property (nonatomic, assign) int duration;

@property (nonatomic, assign) BOOL seekEnabled;

@property (nonatomic, assign) LyricType type;

- (void) initExtraData;
- (void) dealloc;

- (void) reset;

- (void) clearLyricContent;

- (int) splitLyricLines;

- (void) updateLyricContent;

- (void) refreshLyricView;

- (void) drawRect:(CGRect)rect;
- (void) drawScheduleLine:(CGRect)rect;
- (void) drawEmptyInfo:(CGRect)rect;
- (void) drawGuide:(CGRect)rect duration:(int)duration;
- (void) drawLyric:(CGRect)rect;
- (void) drawLyricLine:(NSString*)text rect:(CGRect)rect offtime:(int)time;
- (void) drawLyricLineHighlightted:(NSString*)text rect:(CGRect)rect offtime:(int)time;

- (void) startLyricAnimatioin;
- (void) stopLyricAnimatioin;

- (void) animationTimerCallback:(NSTimer*)timer;

- (void) scrollToSchedule:(int)schedule;

- (void) beginSeek:(float)offset;
- (void) seekToOffset:(float)offset;
- (void) cancelSeek;
- (void) endSeek:(float)offset;

- (void) loadLyric:(NSURL *)url;
- (void) cancelLoad;

@end
