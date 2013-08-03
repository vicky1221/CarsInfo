//
//  LyricScrollView.mm
//  KWPlayer
//
//  Created by YeeLion on 11-1-19.
//  Copyright 2011 Kuwo Beijing Co., Ltd. All rights reserved.
//
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

#import "globalm.h"

#import "LyricParser.h"
#import "LyricScrollView.h"
#import "Session.h"
#import "NSString+Custom.h"
#import "AFDownloadRequestOperation.h"

#define GradentColorTime 700    // millisecond

#define LYRIC_SHADOW_ENABLED 0

#define ALIGN_CENTER	0
#define ALIGN_LEFT		1
#define ALIGN_RIGHT		2

// 对应于从CLyricParser加载的一行歌词，通过内部拆分，记录下每行的位置，和于CTLine对应的每行文字位置
@interface LyricSplitedLine : NSObject {
    const CLyricLine* _lyric;
    CFTypeRef _lines;   // CTLine or CFArray of CTLine type
    int _count; // 内部行计数
    NSArray* _ranges;   // 每CTLine行内部的词位置，对应于_lines的类型，可能为NSValue(NSRange)或NSArray of NSValue(NSRange)
	
	id delegate;
}
// added by plj
@property (assign, readonly, nonatomic) UIColor* textColor;
@property (assign, readonly, nonatomic) UIColor* textColorHighlighted;  // 新设置的文字颜色
@property (assign, readonly, nonatomic) UIColor* shadowColor;
@property (assign, readonly, nonatomic) UIColor* strokeColor;
@property (assign, nonatomic) id delegate;

- (const CLyricLine*)lyricLine;

- (int) subLineCount;

- (int) subLineWordCount:(int)index;

- (BOOL) subLineAtIndex:(int)index lineRef:(CTLineRef*)lineRef ranges:(NSArray**)ranges;

- (int) calcScheduleByOffsetScale:(float)scale;

+ (LyricSplitedLine*) lineWithLyricLine:(const CLyricLine*)lyric textAttributes:(CFDictionaryRef)attributes width:(int)width verbatim:(BOOL)verbatim delegate:(id)delegate;


- (int) drawInContext:(CGContextRef)context baseRect:(CGRect)rect lineHeight:(int)lineHeight extend:(BOOL)upOrDown schedule:(int)schedule align:(int)align;

- (int) drawHighlightedInContext:(CGContextRef)context baseRect:(CGRect)rect lineHeight:(int)lineHeight extend:(BOOL)upOrDown schedule:(int)schedule verbatim:(BOOL)verbatim align:(int)align;

@end

@implementation LyricSplitedLine
@synthesize delegate;
@synthesize textColor, textColorHighlighted, shadowColor, strokeColor;

- (id) initWithLV:(id)_delegate { // changed by plj
    self = [super init];
    _count = 0;
    _lyric = NULL;
    _lines = NULL;
    _ranges = nil;

	delegate = _delegate; // plj
    return self;
}

- (void) dealloc {
    [_ranges release];
    if (_lines) {
        CFRelease(_lines);
    }
    [super dealloc];
}


- (const CLyricLine*)lyricLine {
    return _lyric;
}

- (int) subLineCount {
    return _count;
}

- (int) subLineWordCount:(int)index {
    NSAssert(index >= 0 && index < _count, @"Logic error!");
    if (_count == 1) {
        return [_ranges count];
    } else {
        return [(NSArray*)[_ranges objectAtIndex:index] count];
    }
}

- (BOOL) subLineAtIndex:(int)index lineRef:(CTLineRef*)lineRef ranges:(NSArray**)ranges {
    if (index < 0 || index >= _count) {
        *lineRef = NULL;
        *ranges = nil;
        return FALSE;
    }
    if (_count == 1) {
        NSAssert(index == 0, @"Logic error!");
        *lineRef = (CTLineRef)_lines;
        *ranges = _ranges;
    } else {
        *lineRef = (CTLineRef)CFArrayGetValueAtIndex((CFArrayRef)_lines, index);
        *ranges = (NSArray*)[_ranges objectAtIndex:index];
    }
    
    return TRUE;
}

- (void) setLyric:(const CLyricLine*)lyric {
    NSAssert(lyric != NULL, @"Logic error!");
    _lyric = lyric;
}

- (void) addSubLine:(CTLineRef)line ranges:(NSArray*)ranges verbatim:(BOOL)verbatim {
    if (_count == 0) {
        CFRetain(line);
        if (_lines) {
            CFRelease(_lines);
        }
        _lines = line;

        if (verbatim) {
            [ranges retain];
            [_ranges release];
            _ranges = ranges;
        }
    } else {
        if (_count == 1) {
            CTLineRef tempLine = (CTLineRef)_lines;
            _lines = CFArrayCreateMutable(kCFAllocatorDefault, 2, &kCFTypeArrayCallBacks);
            CFArrayAppendValue((CFMutableArrayRef)_lines, tempLine);
            CFRelease(tempLine);
            
            if (verbatim) {
                NSArray* tempRange = _ranges;
                _ranges = [[NSMutableArray alloc] initWithCapacity:2];
                [(NSMutableArray*)_ranges addObject:tempRange];
                [tempRange release];
            }
        }
        CFArrayAppendValue((CFMutableArrayRef)_lines, line);
        if (verbatim) {
            [(NSMutableArray*)_ranges addObject:ranges];
        }
    }
    _count++;
}

int calcWordLength( const char* string, int count) {
    CFStringRef temp = CFStringCreateWithBytes(kCFAllocatorDefault, (const UInt8*)string, count, kCFStringEncodingUTF8, FALSE);
    CFIndex length = CFStringGetLength(temp);
    CFRelease(temp);
    return length;
}

- (NSArray*) calcSubLineWordsRanges:(const CLyricLine*)pLyricLine start:(int)start count:(int)count {
    NSAssert(start + count <= pLyricLine->GetWordCount(), @"Logic error!");
    NSMutableArray* rangeArray = [NSMutableArray arrayWithCapacity:count];
    if (count > 0) {
        const CLyricWord* pWord = pLyricLine->GetWord(start);
        NSAssert(pWord != NULL, @"Logic error!");
        CFStringRef temp = CFStringCreateWithBytes(kCFAllocatorDefault, (const UInt8*)pLyricLine->GetText(), pWord->pos, kCFStringEncodingUTF8, FALSE);
        CFIndex location  = CFStringGetLength(temp);
        CFRelease(temp);
        for (int i = start; i < start + count; i++) {
            const CLyricWord* pWord = pLyricLine->GetWord(i);
            CFIndex length = calcWordLength(pLyricLine->GetText() + pWord->pos, pWord->count);
            NSRange range = NSMakeRange(location, length);
            [rangeArray addObject:[NSValue valueWithRange:range]];
            location += length;
        }
    }
    return rangeArray;
}

- (void) splitLineWithTextAttributes:(CFDictionaryRef)attributes lineWidth:(float)width verbatim:(BOOL)verbatim {
    NSAssert(_lyric != NULL, @"Invalid lyric line!");
    
    CFStringRef string = CFStringCreateWithCString(kCFAllocatorDefault, _lyric->GetText(), kCFStringEncodingUTF8);
    if (!string)
        return;
    CFIndex length = CFStringGetLength(string);
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);
    
    CFIndex start = 0;
    CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);
    int wordStart = 0;
    int wordCount = _lyric->GetWordCount();
    if (count == length) {
        CTLineRef lineRef = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        if (verbatim) {
            NSArray* ranges = [self calcSubLineWordsRanges:_lyric start:wordStart count:wordCount];
            [self addSubLine:lineRef ranges:ranges verbatim:verbatim];
        } else {
            [self addSubLine:lineRef ranges:nil verbatim:verbatim];
        }
        CFRelease(lineRef);
    } else {
        while (1) {
            // 拆出一行
            if (verbatim) {
                int textCount = 0;  // line length
                for (int i = wordStart; i < _lyric->GetWordCount(); i++) {
                    const CLyricWord* pWord = _lyric->GetWord(i);
                    CFIndex len = calcWordLength(_lyric->GetText() + pWord->pos, pWord->count);
                    textCount += len;
                    if (textCount < count) {
                        continue;
                    } else if (textCount == count) {
                        wordCount = i - wordStart + 1;
                        break;
                    } else {
                        if (i == wordStart) { // one word per line at least
                            count = len;
                            wordCount = 1;
                        } else {
                            count = textCount - len;
                            wordCount = i - wordStart;
                        }
                        break;
                    }
                }
                
                CTLineRef lineRef = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
                NSArray* ranges = [self calcSubLineWordsRanges:_lyric start:wordStart count:wordCount];
                [self addSubLine:lineRef ranges:ranges verbatim:verbatim];
                CFRelease(lineRef);
                
                wordStart += wordCount;
            } else {
                CTLineRef lineRef = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
                [self addSubLine:lineRef ranges:nil verbatim:verbatim];
                CFRelease(lineRef);
            }

            start += count;
            if (start >= length) {
                break;
            }
            count = CTTypesetterSuggestLineBreak(typesetter, start, width);
        }
    }
    CFRelease(typesetter);
    CFRelease(attrString);
    CFRelease(string);
}

- (int) calcScheduleByOffsetScale:(float)scale {
    if (scale > 1.0) {
        scale = 1.0;
    } else if (scale < 0) {
        scale = 0;
    }
    return _lyric->GetTimestamp() + _lyric->GetElapsed() * scale;
}

+ (LyricSplitedLine*) lineWithLyricLine:(const CLyricLine*)lyric textAttributes:(CFDictionaryRef)attributes width:(int)width verbatim:(BOOL)verbatim delegate:(id)delegate {
    LyricSplitedLine* lsl = [[LyricSplitedLine alloc] initWithLV:delegate];
    [lsl setLyric:lyric];
    [lsl splitLineWithTextAttributes:attributes lineWidth:width verbatim:verbatim];
    return [lsl autorelease];
}

- (CGRect) lyricLineDrawingRect:(CTLineRef)lineRef baseRect:(CGRect)rect align:(int)align{
    CGFloat ascent, descent, leading;
    int width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
    CGRect rcLine;
	switch (align) {
		case ALIGN_CENTER:
			rcLine = CenterRect(rect, width, ascent);
			break;
		case ALIGN_LEFT:
			rcLine = LeftRect(rect, width, 0);
			break;
		case ALIGN_RIGHT:
			rcLine = RightRect(rect, width, 0);
			break;
			
		default:
			break;
	}
    DeflateRect(&rcLine, 0, leading, 0, descent);
    return rcLine;
}

- (void) drawSubLine:(CTLineRef)lineRef context:(CGContextRef)context rect:(CGRect)rect color:(CGColorRef)color colorStroke:(CGColorRef)colorStroke  shadow:(BOOL)shadow align:(int)align {
    CGRect rcLine = [self lyricLineDrawingRect:lineRef baseRect:rect align:align];

#if !LYRIC_SHADOW_ENABLED
    if (colorStroke) {
        CGContextSetTextDrawingMode(context, kCGTextFillStroke);
        CGContextSetStrokeColorWithColor(context, colorStroke);
    } else {
        CGContextSetTextDrawingMode(context, kCGTextFill);
    }
#else
    // stroke and shadow
    CGContextSetTextDrawingMode(context, kCGTextFill);

    CGContextSaveGState(context);
    if (shadow) {
        CGSize size = {1.f, 1.f};
        CGContextSetShadowWithColor(context, size, offsetLyricShadow, [((LyricScrollView *)delegate).shadowColor CGColor]);
    }
    CGContextSetFillColorWithColor(context, color);
//	CGFloat minRect = CGRectGetMinX(rcLine);
//	CGFloat maxRect = CGRectGetMaxY(rcLine);
//	NSLog(@"minRect x is %f", minRect);
//	NSLog(@"minRect y is %f", maxRect);

    CGContextSetTextPosition(context, CGRectGetMinX(rcLine), CGRectGetMaxY(rcLine));
    CTLineDraw(lineRef, context);
    CGContextRestoreGState(context);
    
    OffsetRectY(&rcLine, -1);
    //CGContextSetShadowWithColor(context, size, 0.f, [UIColor clearColor].CGColor);
#endif
    CGContextSetFillColorWithColor(context, color);
    CGContextSetTextPosition(context, CGRectGetMinX(rcLine), CGRectGetMaxY(rcLine));
    CTLineDraw(lineRef, context);
}

   

- (UIColor*) textColorOfSchedule:(int)schedule {
    UIColor* color = nil;
    if (_lyric->IsScheduleMatched(schedule)) {
		color = self.textColorHighlighted;
        int offtime = schedule - _lyric->GetTimestamp();
        if (offtime >= 0 && offtime < GradentColorTime) {
            color = GetGradentColor(self.textColor, self.textColorHighlighted, offtime, GradentColorTime);
        }
    } else {
        color = self.textColor;
        int offtime = schedule - (_lyric->GetTimestamp() + _lyric->GetElapsed());
        if (offtime >= 0 && offtime < GradentColorTime) {
            color = GetGradentColor(self.textColorHighlighted, self.textColor, offtime, GradentColorTime);
        }
    }
    return color;
}

- (int) drawInContext:(CGContextRef)context baseRect:(CGRect)rect lineHeight:(int)lineHeight extend:(BOOL)upOrDown schedule:(int)schedule align:(int)align {
    CGContextSaveGState(context);
    
    int count = [self subLineCount];

    CGRect rcSubLine = rect;
    if (upOrDown) {
        OffsetRectY(&rcSubLine, -lineHeight * (count - 1));
    }
    
    UIColor* color = [self textColorOfSchedule:schedule];
    CTLineRef lineRef;
    NSArray* ranges;
    for (int i = 0; i < count; i++) {
        [self subLineAtIndex:i lineRef:&lineRef ranges:&ranges];
        [self drawSubLine:lineRef context:context rect:rcSubLine color:color.CGColor colorStroke:self.strokeColor.CGColor shadow:FALSE align:align];
        OffsetRectY(&rcSubLine, lineHeight);
    }
    
    CGContextRestoreGState(context);
    return count;
}

// return total lines count
- (int) drawHighlightedInContext:(CGContextRef)context baseRect:(CGRect)rect lineHeight:(int)lineHeight extend:(BOOL)upOrDown schedule:(int)schedule verbatim:(BOOL)verbatim align:(int)align {
    
    if (!verbatim || !_lyric->IsScheduleMatched(schedule)) {    // normal drawing
        return [self drawInContext:context baseRect:rect lineHeight:lineHeight extend:FALSE schedule:schedule align:align];
    }
    
    int count = [self subLineCount];
    if (_lyric->GetWordCount() == 0) {
        return count;
    }
    
    CGContextSaveGState(context);
    
    CGRect rcSubLine = rect;
    if (upOrDown) {
        OffsetRectY(&rcSubLine, -lineHeight * (count - 1));
    }
    
    int curWord = _lyric->GetCorsorOfWord(schedule - _lyric->GetTimestamp());
    NSAssert(curWord < _lyric->GetWordCount(), @"Logic error: verbatim lyric timestamp error!");
    const CLyricWord* pWord = _lyric->GetWord(curWord);

    CTLineRef lineRef;
    NSArray* ranges;
    int baseWordIndex = 0;
    for (int i = 0; i < count; i++) {
        [self subLineAtIndex:i lineRef:&lineRef ranges:&ranges];
        int lineWordCount = [self subLineWordCount:i];
        if (curWord < baseWordIndex) {   // normal drawing
            [self drawSubLine:lineRef context:context rect:rcSubLine color:self.textColor.CGColor colorStroke:self.strokeColor.CGColor shadow:TRUE align:align];
        } else if (curWord >= baseWordIndex + lineWordCount) {    // highlighted drawing
            [self drawSubLine:lineRef context:context rect:rcSubLine color:self.textColorHighlighted.CGColor colorStroke:self.strokeColor.CGColor shadow:TRUE align:align];
        } else {
            // back word, not highlighted part
            [self drawSubLine:lineRef context:context rect:rcSubLine color:self.textColor.CGColor colorStroke:self.strokeColor.CGColor shadow:TRUE align:align];
            
            // foreground word, highlighted part
            //CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange wordRange = [(NSValue*)[ranges objectAtIndex:curWord - baseWordIndex] rangeValue];
            CGFloat start = CTLineGetOffsetForStringIndex(lineRef, wordRange.location, NULL);
            float width = start;
            if (pWord->IsScheduleMatched(schedule - _lyric->GetTimestamp())) {
                CGFloat end = (curWord < _lyric->GetWordCount()
                               ? CTLineGetOffsetForStringIndex(lineRef, wordRange.location + wordRange.length, NULL)
                               : CTLineGetTypographicBounds(lineRef, NULL, NULL, NULL));
                float s = (float)(schedule - (_lyric->GetTimestamp() + pWord->time)) / pWord->elapse;
                width += (end - start) * s;
            }
            CGRect rcDrawing = [self lyricLineDrawingRect:lineRef baseRect:rcSubLine align:align];
            CGRect rcClip = CGContextGetClipBoundingBox(context);
            rcClip.size.width = rcDrawing.origin.x + width - rcClip.origin.x;   // left highlighted part only
            
            CGContextSaveGState(context);
            CGContextClipToRect(context, rcClip);
//            CGSize size = {0.f, 1.f};
//            CGContextSetShadowWithColor(context, size, 10.f, UIColorFromRGBValue(0x066e52).CGColor);
//            [self drawSubLine:lineRef context:context rect:rcSubLine color:UIColorFromRGBValue(0x066e52).CGColor colorStroke:UIColorFromRGBValue(0x066e52).CGColor];
            [self drawSubLine:lineRef context:context rect:rcSubLine color:self.textColorHighlighted.CGColor colorStroke:self.strokeColor.CGColor shadow:FALSE align:align];
            CGContextRestoreGState(context);
        }
        baseWordIndex += lineWordCount;
        OffsetRectY(&rcSubLine, lineHeight);
    }
    
    CGContextRestoreGState(context);
    return count;
}


#pragma mark - 歌词颜色相关. plj
- (UIColor *)textColor {
	return ((LyricScrollView *)delegate).textColor;
}
- (UIColor *)textColorHighlighted {
	return((LyricScrollView *)delegate).textColorHighlighted;
}
- (UIColor *)shadowColor {
	return ((LyricScrollView *)delegate).shadowColor;
}
- (UIColor *)strokeColor {
	return ((LyricScrollView *)delegate).strokeColor;
}

@end


#define LYRIC_REFRESH_RATE (1.0/20)


@interface LyricScrollView ()

@property (retain) AFDownloadRequestOperation *request;

@end


@implementation LyricScrollView

@synthesize delegate;

@synthesize textFont = _textFont;
@synthesize textSize = _textSize;
@synthesize lineHeight = _lineHeight;

@synthesize textColor = _textColor;
@synthesize textColorHighlighted = _textColorHighlighted;
@synthesize shadowColor = _shadowColor;
@synthesize strokeColor = _strokeColor;

@synthesize lyricStatus = _lyricStatus;
@synthesize lyricParser = _lyricParser;

@synthesize active = _active;

@synthesize schedule = _schedule;
@synthesize duration = _duration;

@synthesize seekEnabled = _seekEnabled;

@synthesize type=m_type;

- (void) setLyricParser:(CLyricParser*)parser {
    _lyricParser = parser;
}

- (void) setLyricStatus:(int)status {
    _lyricStatus = status;
    if(status != lyricStatSucceed) {   // none or failed
        [self clearLyricContent];
        [self setNeedsDisplay];
    }
    
    [self updateLyricContent];
    //[self setActive:(status == lyricStatSucceed)];
}

- (void) setActive:(BOOL)active {
    _active = active;
    if (_active) {
        [self startLyricAnimatioin];
    } else {
        [self stopLyricAnimatioin];
    }
}

- (void) setSchedule:(int)schedule {
    if (_seeking) {
        _seekScheduleCache = schedule;
    } else {
        _schedule = schedule;
    }
    
    if (!_active) {
        [self refreshLyricView];
    }

    /*if (!_lyricParser)
        return;
    
    // update lyric content on animation timer.
    if (!_currentLyricLine == -1) {
        _currentLyricLine = _lyricParser->GetLineCursorOfSchedule(_schedule);
    }*/
}

- (CFDictionaryRef) createLyricTextAttributes {
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f); 
    CTFontRef font = CTFontCreateWithName((CFStringRef)_textFont, _textSize, &transform);
    CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorFromContextAttributeName };
    CFTypeRef values[] = { font, kCFBooleanTrue };
    #define ARRAYSIZE(A) (sizeof(A)/sizeof((A)[0]))
	
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                                                    (const void**)&values, ARRAYSIZE(keys),
                                                    &kCFTypeDictionaryKeyCallBacks,
                                                    &kCFTypeDictionaryValueCallBacks);
    CFRelease(font);
    return attributes;
}

- (void) initExtraData {
    //[super initExtraData];
    self.backgroundColor = [UIColor lightGrayColor];
    
//    _textFont = @"Helvetica";    // @"Arial";
	_textFont = @"Helvetica-Bold";
    _textSize = 16;
    _lineHeight = 48;
    
    self.textColor = [UIColor grayColor];
    self.textColorHighlighted = [UIColor yellowColor];
	self.shadowColor = [UIColor blackColor];
    
    _lyricLines = [[NSMutableArray arrayWithCapacity:64] retain];
    
    _textAttributes = [self createLyricTextAttributes];
    
    _seeking = FALSE;
    _seekScheduleCache = 0;
    
	self.request = nil;
	
    m_bIsLoading = NO;


    [self reset];
    /*
    //UISwipeGestureRecognizer* swipeGestureRecognizer;
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUserSwipeAction:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;// | UISwipeGestureRecognizerDirectionDown;
    swipeGestureRecognizer.delegate = self;
    [self addGestureRecognizer:swipeGestureRecognizer];
    //[swipeGestureRecognizer release];
    
    //UIPanGestureRecognizer* panGestureRecognizer;
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleUserPanAction:)];
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    //[panGestureRecognizer release];
    */
    /*UITapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleUserTapAction:)];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];*/
}

- (void) layoutSubviews {
    [super layoutSubviews];

#if 1
    float gradientHeight = 8.0;//20.0;
    float gradientScale = gradientHeight / CGRectGetHeight(self.bounds);

    CGRect rectTop = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), gradientHeight);
    OffsetRectToPoint(&rectTop, self.bounds.origin);
    CAGradientLayer* gradientTop = [CAGradientLayer layer];
    gradientTop.frame = rectTop;
    gradientTop.colors = [NSArray arrayWithObjects:
                          (id)[[UIColor clearColor] CGColor],
                          (id)[[UIColor blackColor] CGColor],
                          nil];

    CGRect rectMiddle = self.bounds;
    DeflateRectXY(&rectMiddle, 0.0, gradientHeight);
    CAGradientLayer* gradientMiddle = [CAGradientLayer layer];
    gradientMiddle.frame = rectMiddle;
    gradientMiddle.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor blackColor] CGColor],
                             nil];

    CGRect rectBottom = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), gradientHeight);
    OffsetRectToXY(&rectBottom, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - gradientHeight);
    CAGradientLayer* gradientBottom = [CAGradientLayer layer];
    gradientBottom.frame = rectBottom;
    gradientBottom.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor blackColor] CGColor],
                             (id)[[UIColor clearColor] CGColor],
                             nil];
    
    //CAGradientLayer* mask = [CAGradientLayer layer];
    CALayer* mask = [CALayer layer];
    mask.frame = self.bounds;
    [mask addSublayer:gradientTop];
    [mask addSublayer:gradientMiddle];
    [mask addSublayer:gradientBottom];
    self.opaque = TRUE;
    self.layer.mask = mask;
#endif
    
    [self splitLyricLines];
}

- (void) dealloc {
	NSLog(@"dealloc lyric scroll view................");
    [self stopLyricAnimatioin];
    [self cancelSeek];
    
    [_textFont release];
    [_textColor release];
    [_textColorHighlighted release];
    
    [_lyricLines release];
    
    if (_textAttributes) CFRelease(_textAttributes);
//    [];
    [self cancelLoad];
    
    [super dealloc];
}

- (void) reset {
    [self cancelSeek];

    _schedule = 0;
    _duration = 0;

    [self clearLyricContent];
}

- (void) clearLyricContent {
    _lyricParser = NULL;
    _currentLyricLine = -1;
    _offset = 0;

    [_lyricLines removeAllObjects];

    _active = false;
    _animationTimer = nil;
    
    [_lyricLines removeAllObjects];
}


- (int) splitLyricLines {
    [_lyricLines removeAllObjects];
    if (!_lyricParser)
        return 0;
    
    _lyricParser->VerifyTimestamp(_duration);
    
    int width = CGRectGetWidth(self.bounds) - 20;
    if (width < 60) // too small space!
        return 0;

    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f); 
//    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), _textSize, &transform);
    CTFontRef font = CTFontCreateWithName((CFStringRef)_textFont, _textSize, &transform); //plj
    
    CFStringRef keys[] = { kCTFontAttributeName, kCTForegroundColorFromContextAttributeName };
    CFTypeRef values[] = { font, kCFBooleanTrue };
    
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                                                    (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                                                    &kCFTypeDictionaryKeyCallBacks,
                                                    &kCFTypeDictionaryValueCallBacks);
	
    // 拆分长歌词。added by plj
	if (m_type == LyricType_Karaoke) {
		static UIFont *lfont=[UIFont fontWithName:_textFont size:_textSize];
		CGSize size = [@"T" sizeWithFont:lfont constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:UILineBreakModeWordWrap];
		int oneHeight = size.height;
		int lineCount = _lyricParser->GetLineCount();
		for (int index = 0; index < lineCount; index++) {
			const CLyricLine* pLyricLine = _lyricParser->GetLyricLine(index);
			std::vector<int> vpos;
			vpos.push_back(0);
			pLyricLine = _lyricParser->GetLyricLine(index);
			NSString *sline = [NSString stringWithUTF8String:pLyricLine->GetText()];
			CGSize sz = [sline sizeWithFont:lfont constrainedToSize:CGSizeMake(width, 2000) lineBreakMode:UILineBreakModeWordWrap];
			int c = (int)((1.0 * sz.height)/oneHeight);
			
			for (int i = 1; i < c; i++) {
				vpos.push_back(pLyricLine->GetWordCount()/c * i);
			}

			if (vpos.size() > 1) {
				_lyricParser->DivideLyricLine(index, vpos);
			}
		}
	}
    
    
    
    for (int index = 0; index < _lyricParser->GetLineCount(); index++) {
        const CLyricLine* pLyricLine = _lyricParser->GetLyricLine(index);
        LyricSplitedLine* lineSplited = [LyricSplitedLine lineWithLyricLine:pLyricLine textAttributes:attributes width:width verbatim:_lyricParser->IsVerbatim() delegate:self];
        [_lyricLines addObject:lineSplited];
    }
	
	CFRelease(attributes);
	CFRelease(font);

    return (int)_lyricLines.count;
}
    
- (void) updateLyricContent {
    if (_lyricParser == nil || !_lyricParser->IsLyricValid())
        return;

    [self splitLyricLines];
    
    [self refreshLyricView];
}

- (void) refreshLyricView {
    if (!_lyricParser || !_lyricParser->IsLyricValid())
        return;
    if (_lyricLines == nil || _lyricLines.count == 0)
        return;
    
    const CLyricLine* pLyricLine = NULL;
    if (_lyricParser) {
        pLyricLine = _lyricParser->GetLyricLine(_currentLyricLine);
        if (!pLyricLine || !pLyricLine->IsScheduleMatched(_schedule)) {
            _currentLyricLine = _lyricParser->GetLineCursorOfSchedule(_schedule);
            pLyricLine = _lyricParser->GetLyricLine(_currentLyricLine);
        }
    }
    if (!pLyricLine) {
        _offset = 0;
    } else {
        int curTime = pLyricLine->GetTimestamp();
        int totalTime = pLyricLine->GetElapsed();
        int elapsed = _schedule - curTime;
        if (elapsed < 0) {
            _offset = 0;
        } else {
            int count = 1;
            if (pLyricLine) {
                LyricSplitedLine* lineSplited = [_lyricLines objectAtIndex:_currentLyricLine];
                count = [lineSplited subLineCount];
            }
            _offset = (_lineHeight * count) * ((float)elapsed / totalTime);
        }
    }
    
    [self setNeedsDisplay];
}

- (void) drawEmptyInfo:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);

    CGRect rcLine = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight/2);
//	OffsetRectY(&rcLine, 22);
    NSString* info;
    switch (_lyricStatus) {
        case lyricStatLoading:
            info = @"正在搜索歌词";
            break;
        case lyricStatError:
            info = @"下载歌词失败";
            break;
        case lyricStatSucceed:
        case lyricStatDefault:
        case lyricStatNoneLrc:
        default:
            info = @"获取歌词";
            break;
    }
    [info drawInRect:rcLine 
            withFont:[UIFont fontWithName:_textFont size:_textSize-3] 
       lineBreakMode:UILineBreakModeTailTruncation 
           alignment:UITextAlignmentCenter];

    CGContextRestoreGState(context);
}

- (void) drawGuide:(CGRect)rect duration:(int)duration {
   /* if (duration > 3000)
        return; */
    
	rect = CGRectMake(rect.origin.x, rect.origin.y + 6, rect.size.width, rect.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    
    rect.size.width = 14;//20;
    rect.size.height = 14;//20;
    for (int i = 0; i < (duration + 900) / 1000; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i % 8]];
        UIImage *image = [UIImage imageNamed:@"SongStudio_timing"];

        if (i < 3)
            [image drawInRect:rect];
        rect.origin.x += 25;
    }
    
    CGContextRestoreGState(context);
}

- (void) drawTime:(int)schedule {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    NSString *info = TimeToString(schedule, FALSE);

    CGRect rect = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight/2);
    [info drawInRect:rect 
            withFont:[UIFont fontWithName:@"Helvetica" size:_textSize] 
       lineBreakMode:UILineBreakModeClip 
           alignment:UITextAlignmentCenter];
    
    CGContextRestoreGState(context);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f);
    CGContextSetTextMatrix(context, transform);

    if (_lyricLines.count > 0) {
        [self drawLyric:rect];
    } else {
        [self drawEmptyInfo:rect];
    }
    
    if (_seeking) {
        [self drawScheduleLine:rect];
    }
    
    CGContextRestoreGState(context);
}

- (void) drawScheduleLine:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGColorRef lineColor = [UIColor whiteColor].CGColor;
    const int height = 18;
    int lineY = (int)CGRectGetMidY(self.bounds);
    CGRect rcSchedule = CGRectMake(CGRectGetMinX(self.bounds), lineY - height, CGRectGetWidth(self.bounds), height);
    
    // schedule line
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, lineColor);
    CGContextMoveToPoint(context, CGRectGetMinX(rcSchedule), lineY);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rcSchedule), lineY);
    CGContextStrokePath(context);
    
    // schedule text
	UIColor *tmpColor = UIColorFromRGBAValue(0xFFFFFF, 80);
    CGColorRef textColor = tmpColor.CGColor;//[UIColor whiteColor].CGColor;
    NSString* scheuleText = TimeToString(_schedule, _schedule >= _duration);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, textColor);
    [scheuleText drawInRect:rcSchedule 
                   withFont:[UIFont fontWithName:@"Helvetica" size:14] 
              lineBreakMode:UILineBreakModeClip 
                  alignment:UITextAlignmentLeft];
	
    [scheuleText drawInRect:rcSchedule 
                   withFont:[UIFont fontWithName:@"Helvetica" size:14] 
              lineBreakMode:UILineBreakModeClip 
                  alignment:UITextAlignmentRight];
    
    CGContextRestoreGState(context);
}

- (void) drawLyric:(CGRect)rect {
	static UIFont *lfont=[UIFont fontWithName:_textFont size:_textSize];
    if (!_lyricParser || !_lyricParser->IsLyricValid() || _lyricLines.count <= 0) {
        return;
    }
    //NSDate* date1 = [NSDate dateWithTimeIntervalSinceNow:0];
#if 1
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_currentLyricLine >= _lyricParser->GetLineCount())
		return;
	
	if (m_type == LyricType_Karaoke) {
		CLyricParagraph paragraph = _lyricParser->GetParagraphCursorOfSchedule(_schedule);
		int paragraphStartLine = paragraph.startLine;
		int paragraphEndLine = paragraph.endLine;
		
		if (paragraphStartLine < 0 ) {
			// TODO: 可以画一些其他的东西
//			[self drawTime:_schedule];
//			return;
			if (_currentLyricLine == 0)
				paragraphStartLine = 0;
			else
				return;
		}
		
		int align = ALIGN_LEFT;
		CGRect vol0 = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);
		OffsetRectY(&vol0, -_lineHeight/3);
		CGRect vol1 = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);
		OffsetRectY(&vol1, _lineHeight/3);
		CGRect *rcCurrent = (_currentLyricLine - paragraphStartLine) % 2 == 0 ? &vol0 : &vol1;
		CGRect *rcNext = (_currentLyricLine - paragraphStartLine) % 2 == 0 ? &vol1 : &vol0;
		int currentLinePlayedTime = 0;
		
		
		
		LyricSplitedLine* cline = [_lyricLines objectAtIndex:_currentLyricLine];
		if (rcCurrent == &vol0) {
			align = ALIGN_LEFT;
		} else {
			align = ALIGN_RIGHT;
		}
		if ([cline lyricLine]->IsScheduleMatched(_schedule)) {
			[cline drawHighlightedInContext:context baseRect:*rcCurrent lineHeight:_lineHeight extend:FALSE schedule:_schedule verbatim:_lyricParser->IsVerbatim() align:align];
		} else {
			[cline drawInContext:context baseRect:*rcCurrent lineHeight:_lineHeight extend:FALSE schedule:_schedule align:align];
		}
		
		currentLinePlayedTime = _schedule -[cline lyricLine]->GetTimestamp();
		bool isDisplayingPrevLine = true;

		LyricSplitedLine* nline = NULL;
		if (currentLinePlayedTime < [cline lyricLine]->GetElapsed()/3) {
			if (_currentLyricLine - paragraphStartLine > 0) {
				nline = [_lyricLines objectAtIndex:_currentLyricLine - 1];
			}
		} else {
			isDisplayingPrevLine = false;
			if (_currentLyricLine < paragraphEndLine - 1) {
				nline = [_lyricLines objectAtIndex:_currentLyricLine + 1];
			}
		}
		if (nline != NULL) {
			if (rcNext == &vol0) {
				align = ALIGN_LEFT;
			} else {
				align = ALIGN_RIGHT;
			}
//                NSLog(@"绘制 %@", tutf8str);
			if (isDisplayingPrevLine) {
				int sc = [nline lyricLine]->GetTimestamp() + [nline lyricLine]->GetElapsed();
				[nline drawHighlightedInContext:context baseRect:*rcNext lineHeight:_lineHeight extend:FALSE schedule:sc verbatim:_lyricParser->IsVerbatim() align:align];
			} else {
				[nline drawInContext:context baseRect:*rcNext lineHeight:_lineHeight extend:FALSE schedule:-1 align:align];
			}
		} else {
//                NSLog(@"开始行或结束行");
		}
			
		if (paragraph.startTime != 0) {
	//        CGRect grect = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);
			CGRect grect = LeftTopRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);
			[self drawGuide:grect duration:paragraph.endTime - _schedule];
		}
	} else if (m_type == LyricType_SignleLine) {
		LyricSplitedLine* line = [_lyricLines objectAtIndex:_currentLyricLine];
		
		CGRect rcLine = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);

		if ([line lyricLine]->IsScheduleMatched(_schedule)) {
			[line drawHighlightedInContext:context baseRect:rcLine lineHeight:_lineHeight extend:FALSE schedule:_schedule verbatim:_lyricParser->IsVerbatim() align:ALIGN_CENTER];
		} else {
			[line drawInContext:context baseRect:rcLine lineHeight:_lineHeight extend:FALSE schedule:_schedule align:ALIGN_CENTER];
		}
	} else if (m_type == LyricType_Default) {
		// line draw
		CGRect rcHighlightedLine = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);
		OffsetRectY(&rcHighlightedLine, _lineHeight/2 - _offset);
		
		CGRect rcLine = rcHighlightedLine;
		
		//CGSize size = {0.f, 1.f};
		//CGContextSetShadowWithColor(context, size, 10.f, UIColorFromRGBValue(0x969e52).CGColor);
		//CGContextSetTextDrawingMode(context, kCGTextFillStroke);
		
		// above lines
		OffsetRectY(&rcLine, -_lineHeight);
		for (int index = _currentLyricLine - 1; index >= 0; --index) {
			if (!CGRectIntersectsRect(rcLine, self.bounds))
				break;
			LyricSplitedLine* line = [_lyricLines objectAtIndex:index];
			int count = [line drawInContext:context baseRect:rcLine lineHeight:_lineHeight extend:TRUE schedule:_schedule align:ALIGN_CENTER];
			OffsetRectY(&rcLine, -_lineHeight * count);
		}
		
		// nether lines
		rcLine = rcHighlightedLine;
		for (int index = _currentLyricLine >= 0 ? _currentLyricLine : 0; index < _lyricParser->GetLineCount(); index++) {
			if (!CGRectIntersectsRect(rcLine, self.bounds))
				break;
			LyricSplitedLine* line = [_lyricLines objectAtIndex:index];
			int count = 0;
			if ([line lyricLine]->IsScheduleMatched(_schedule)) {
				count = [line drawHighlightedInContext:context baseRect:rcLine lineHeight:_lineHeight extend:FALSE schedule:_schedule verbatim:_lyricParser->IsVerbatim() align:ALIGN_CENTER];
			} else {
				count = [line drawInContext:context baseRect:rcLine lineHeight:_lineHeight extend:FALSE schedule:_schedule align:ALIGN_CENTER];
			}
			
			OffsetRectY(&rcLine, _lineHeight * count);
		}

	}

#else
    // NSString draw
    CGRect rcCurLine = CenterRect(self.bounds, CGRectGetWidth(self.bounds), _lineHeight);
    OffsetRectY(&rcCurLine, _lineHeight - _offset);

    for (int i = 0; i < _lyricParser->GetLineCount(); i++) {
        CGRect rcLine = CGRectOffset(rcCurLine, 0, _lineHeight * (i - _currentLyricLine));
        if (!CGRectIntersectsRect(rcLine, self.bounds))
            continue;
        const CLyricLine* pLyricLine = _lyricParser->GetLyricLine(i);
        if (i == _currentLyricLine && pLyricLine->IsScheduleMatched(_schedule)) {
            [self drawLyricLineHighlightted:[NSString stringWithUTF8String:pLyricLine->GetText()]
                                       rect:rcLine offtime:_schedule - pLyricLine->GetTimestamp()];
        } else {
            [self drawLyricLine:[NSString stringWithUTF8String:pLyricLine->GetText()]
                           rect:rcLine offtime:_schedule - (pLyricLine->GetTimestamp() + pLyricLine->GetElapsed())];
        }
    }
#endif
    //NSDate* date2 = [NSDate dateWithTimeIntervalSinceNow:0];
    //NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    //NSLog(@"lyric %f", time * 1000);
}

- (void) drawLyricLine:(NSString*)text rect:(CGRect)rect offtime:(int)time {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    UIColor* textColor = _textColor;
    if (time > 0 && time < GradentColorTime) {
        textColor = GetGradentColor(_textColorHighlighted, _textColor, time, GradentColorTime);
    }
    [textColor setFill];
    
    [text drawInRect:rect 
            withFont:[UIFont fontWithName:_textFont size:_textSize] 
       lineBreakMode:UILineBreakModeWordWrap 
           alignment:UITextAlignmentCenter];
    
    CGContextRestoreGState(context);
}

- (void) drawLyricLineHighlightted:(NSString*)text rect:(CGRect)rect offtime:(int)time {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    UIColor* textColor = _textColorHighlighted;
    if (time > 0 && time < GradentColorTime) {
        textColor = GetGradentColor(_textColor, _textColorHighlighted, time, GradentColorTime);
    }
    [textColor setFill];
    
    [text drawInRect:rect 
            withFont:[UIFont fontWithName:_textFont size:_textSize] 
       lineBreakMode:UILineBreakModeMiddleTruncation 
           alignment:UITextAlignmentCenter];
    
    CGContextRestoreGState(context);
}

- (void) startLyricAnimatioin {
    if (_lyricStatus != 1 || !_active) {
        return;
    }
    if (_animationTimer) {
        return;
    }
    
    if (_lyricParser == nil || !_lyricParser->IsLyricValid())
        return;
    NSAssert(_lyricLines != nil && _lyricLines.count > 0, @"Logic error!");

    if (_currentLyricLine == -1) {
        _currentLyricLine = 0;
    }
    _animationTimer = [NSTimer timerWithTimeInterval:LYRIC_REFRESH_RATE target:self selector:@selector(animationTimerCallback:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSDefaultRunLoopMode];
    [_animationTimer retain];
}

- (void) stopLyricAnimatioin {
    if (!_animationTimer) {
        return;
    }
    [_animationTimer invalidate];
    [_animationTimer release];
    _animationTimer = nil;
}

- (void) animationTimerCallback:(NSTimer*)timer {
    if (timer != _animationTimer) {
        return;
    }
    if (_seeking) {
        return;
    }
    [self refreshLyricView];
}

- (void) scrollToSchedule:(int)schedule {
    _schedule = schedule;
    [self refreshLyricView];
}

- (void) beginSeek:(float)offset {
    _seeking = TRUE;
    _seekScheduleCache = _schedule;
    if ([delegate respondsToSelector:@selector(onLyricSeekBegin:)])
        [delegate onLyricSeekBegin:self];
    [self seekToOffset:offset];
    [self setNeedsDisplay]; // force update, display schedule line.
}

- (void) seekToOffset:(float)offset {
    if (!_seeking) {
        return;
    }
    if (!_lyricParser || !_lyricParser->IsLyricValid()) {
        return;
    }

    NSAssert(_seeking, @"Logic error!");
    
    if (offset == 0.0) {
        return;
    }
    
    //NSLog(@"Offset: %f", offset);
    
    if (_currentLyricLine < 0 || _currentLyricLine >= _lyricLines.count)
        _currentLyricLine = _lyricParser->GetLineCursorOfSchedule(_schedule);
    
    if (_currentLyricLine <= 0) {
        if (_offset == 0 && offset > 0)
            return;
        _currentLyricLine = 0;
    }
    if (_currentLyricLine >= _lyricLines.count) {
        if (_offset == 0 && offset < 0)
            return;
        _currentLyricLine = _lyricLines.count - 1;
        _offset = _lineHeight * [(LyricSplitedLine*)[_lyricLines objectAtIndex:_currentLyricLine] subLineCount];
    }

    // _offset value should be between [0, _lineHeight)
    LyricSplitedLine* pLine = (LyricSplitedLine*)[_lyricLines objectAtIndex:_currentLyricLine];
    int count = [pLine subLineCount];
    int height = _lineHeight * count;
    _offset -= offset;
    if (_offset < 0.0) {
        int i = 0;
        for (i = _currentLyricLine - 1; i >= 0; i--) {
            pLine = (LyricSplitedLine*)[_lyricLines objectAtIndex:i];
            count = [pLine subLineCount];
            height = _lineHeight * count;
            _offset += height;
            if (_offset >= 0) {
                _currentLyricLine = i;
                break;
            }
        }
    } else if (_offset >= height) {
        int i = 0;
        for (i = _currentLyricLine + 1; i < _lyricLines.count; i++) {
            pLine = (LyricSplitedLine*)[_lyricLines objectAtIndex:i];
            count = [pLine subLineCount];
            height = _lineHeight * count;
            _offset -= height;
            if (_offset < height) {
                _currentLyricLine = i;
                break;
            }
        }
    }

    _schedule = [pLine calcScheduleByOffsetScale:((float)_offset / height)];
    if ([delegate respondsToSelector:@selector(onLyricSeekValueChange:)])
        [delegate onLyricSeekValueChange:self];

    //NSLog(@"seek: %f, line: %d, offset: %d schedule: %d", offset, _currentLyricLine, _offset, _schedule);
    [self refreshLyricView];
}

- (void) cancelSeek {
    _seeking = FALSE;
    _schedule = _seekScheduleCache;
    
    if ([delegate respondsToSelector:@selector(onLyricSeekCancel:)])
        [delegate onLyricSeekCancel:self];
    
    _seekScheduleCache = 0;
    [self refreshLyricView];
    [self setNeedsDisplay]; // force update, undisplay schedule line.
}

- (void) endSeek:(float)offset {
    [self seekToOffset:offset];
    _seeking = FALSE;

    if ([delegate respondsToSelector:@selector(onLyricSeekEnd:)])
        [delegate onLyricSeekEnd:self];

    if ([(id)delegate respondsToSelector:@selector(onUIEventSeek:schedule:)])
        [delegate onUIEventSeek:self schedule:(_schedule / 1000)];
    
    [self refreshLyricView];
    [self setNeedsDisplay]; // force update, undisplay schedule line.
}


BOOL g_sIsLyricDraging = FALSE;

// _draging value: 0 ended, -1 start, 1 draging
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_seekEnabled) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    UITouch* touch = [touches anyObject];
    _draging = -1;
    _pointStartSeek = [touch locationInView:self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_seekEnabled) {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat dx = point.x - _pointStartSeek.x;
    CGFloat dy = point.y - _pointStartSeek.y;
    _pointStartSeek = point;

    if (_draging == -1) {
        if (fabsf(dy) > fabsf(dx)) {
            _draging = 1;
            g_sIsLyricDraging = TRUE;
            [self beginSeek:dy];
        } else {
            _draging = 0;
        }
    } else if (_draging == 1) {
        [self seekToOffset:dy];
    } else {
        // not in draging, do nothing
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_seekEnabled) {
        [super touchesEnded:touches withEvent:event];
        return;
    }

    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //CGFloat dx = point.x - _pointStartSeek.x;
    CGFloat dy = point.y - _pointStartSeek.y;
    
    if (_draging == 1) {
        [self endSeek:dy];
    } else {
        //float dist = dy - dx;
        //[self handleUserTapAction:nil];
        //}
    }
    g_sIsLyricDraging = FALSE;    
    _draging = 0;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!_seekEnabled) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }

    if (_draging == 1) {
        [self cancelSeek];
    }

    _draging = 0;
    g_sIsLyricDraging = FALSE;
}

- (void) loadLyric:(NSURL *)url {
	
    if (!m_bIsLoading)
	{
        m_bIsLoading = TRUE;
		
		NSString *fname = [url lastPathComponent];
		NSString *ext = [url pathExtension];
		if (!([ext isEqualToString:@"lrcx"] || [ext isEqualToString:@"lrc"])) {
			NSString *query = [url query];
			NSString *p = [[query queryDict] objectForKey:@"bzid"];
			fname = [p stringByAppendingPathExtension:@"lrcx"];
		}
		NSString *file = [[Session sharedSession] getPath:eLyricsPath file:fname];
		
		[_request cancel];
		[_request release];
		NSURLRequest *rq = [NSURLRequest requestWithURL:url];
		_request = [[AFDownloadRequestOperation alloc] initWithRequest:rq targetPath:file shouldResume:YES];
		[_request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			
			CLyricParser *parser = new CLyricParser();
			parser->setParagraph(m_type == LyricType_Karaoke);
			parser->LoadLyricFile([responseObject UTF8String]);
			[self setLyricParser:parser];
			[self setLyricStatus:lyricStatSucceed];
			[self setActive:TRUE];
			
			m_bIsLoading = NO;
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			
			NSLog(@"LyricScrollView: %@ requestFailed %@", url, error);
			
			NSFileManager *fm = [NSFileManager defaultManager];
			if ([fm fileExistsAtPath:file]) {
				NSLog(@"LyricScrollView: request failed, will using cached file");
				CLyricParser *parser = new CLyricParser();
				parser->setParagraph(m_type == LyricType_Karaoke);
				parser->LoadLyricFile([file UTF8String]);
				[self setLyricParser:parser];
				[self setLyricStatus:lyricStatSucceed];
				[self setActive:TRUE];
			} else {
				[self setLyricStatus:lyricStatError];
			}
			
			m_bIsLoading = NO;
		}];
		
		NSFileManager *fm = [NSFileManager defaultManager];
		if ([fm fileExistsAtPath:file]) {
			NSLog(@"LyricScrollView: loadLyric will using cached file");
			CLyricParser *parser = new CLyricParser();
			parser->setParagraph(m_type == LyricType_Karaoke);
			parser->LoadLyricFile([file UTF8String]);
			[self setLyricParser:parser];
			[self setLyricStatus:lyricStatSucceed];
			[self setActive:TRUE];
		} else {
			[self setLyricStatus:lyricStatLoading];	
		}
		[_request start];
    }
}

- (void) cancelLoad {
	[_request cancel];
	self.request = nil;

	m_bIsLoading = NO;
}


@end
