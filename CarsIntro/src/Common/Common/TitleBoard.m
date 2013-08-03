//
//  TitleBoard.m
//  DropDownList
//
//  Created by kingyee on 11-9-19.
//  Copyright 2011 Kingyee. All rights reserved.
//

#import "TitleBoard.h"
#import "UIView+Chat.h"


@implementation TitleBoardItem
@synthesize title;

- (void)dealloc {
	self.title = nil;
	[super dealloc];
}

@end

@interface TitleBoard() <UITableViewDataSource, UITableViewDelegate>
{
	NSString		*_searchText;
	NSString		*_selectedText;
	NSMutableArray	*_resultList;
	int				nSelected;
	UIView			*_viewBorderDDlist;
	BOOL			__isHiden;
	NSMutableArray	*_titles;
	int				tableViewCellHeight;
	UIButton        *btnBackground;
	UITableView		*_tableView;
    
    UIPickerView    *pickerView;
}
@property (nonatomic, copy)NSString		*_searchText;
@property (nonatomic, copy)NSString		*_selectedText;
@property (nonatomic, retain)NSMutableArray	*_resultList;
@property (nonatomic, assign) int		tableViewCellHeight;
@end

@implementation TitleBoard
@synthesize _searchText, _selectedText, _resultList, delegate=_delegate;
@synthesize tableViewCellHeight;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)dealloc {
    [pickerView release];
	[_searchText release];
	[_selectedText release];
	[_resultList release];
	[_viewBorderDDlist removeFromSuperview];
	[btnBackground removeFromSuperview];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		tableViewCellHeight = 34;
		
		UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(97, 0, 125, 40)];//115
		navLabel.backgroundColor = [UIColor clearColor];
		navLabel.textColor = [UIColor whiteColor];
        navLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:49.0/255.0 blue:49.0/255.0 alpha:1];
		navLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
		navLabel.textAlignment = UITextAlignmentCenter;
		navLabel.text = @"";
		navLabel.tag = 1001;
		[self addSubview:navLabel];
		[navLabel release];
		
		/* self.navigationItem.titleView中显示的label的右边的image **/
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(navLabel.frame.origin.x + navLabel.frame.size.width-40, 1, 50, 40)];
        
		imageView.image = [UIImage imageNamed:@"SongStudio_Detail"];
		imageView.tag = 1002;
		[self addSubview:imageView];
		[imageView release];
		
		[self addTarget:self action:@selector(btnTitleView:) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

- (void)initData
{
	if (!_resultList) {
		_resultList = [[NSMutableArray alloc] initWithCapacity:1];		
	}
	[_resultList removeAllObjects];
}

- (void)updateView:(NSArray *)_arrTitles selectIndex:(NSInteger)_selectIndex
{
	/* 替换self.navigationItem.titleView的view **/
	[self initData];
	[_resultList addObjectsFromArray:_arrTitles];
	nSelected = _selectIndex;
	
	UILabel *labelTitle = (UILabel *)[self viewWithTag:1001];
	labelTitle.text = [[_arrTitles objectAtIndex:nSelected] title];
	
//	[self createView];
//    [self createPicker];
	[_tableView reloadData];
}

- (void)showNavigationTextViewCustom
{
}

/*
- (void)createPicker {
    
    
    int nBorder = 4;
	int nWidth = 175;
	if (!_viewBorderDDlist) {
		// 此处用UIWindow的目的是可以将视图显示到UINavigationBar上面
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];
		}
		
		_viewBorderDDlist = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width - nWidth) / 2, 34, nWidth, 0)];
		_viewBorderDDlist.backgroundColor = [UIColor clearColor];
		
		btnBackground =[UIButton buttonWithType:UIButtonTypeCustom];
		btnBackground.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height) ;
		btnBackground.backgroundColor = [UIColor clearColor] ;
		[btnBackground addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside ];
		[window addSubview:btnBackground];
		
		// _viewBorderDDlist的背景拉伸图片
		[_viewBorderDDlist addChatImage:[UIImage imageNamed:@"userRankingBubble"] point:CGPointMake(43, 14)];//37, 14
		
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        
        [window addSubview:pickerView];
        
//		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(nBorder, nBorder + 6, nWidth - 2 * nBorder, 0)];
		[_viewBorderDDlist addSubview:pickerView];
//		_tableView.delegate = self;
//		_tableView.dataSource = self;
//		[_tableView setBackgroundColor:[UIColor clearColor]];
//		[_tableView release];
		
		// 改变父试图的frame，父父试图自动resieze子视图的frame，很是蛋疼啊。
		[_viewBorderDDlist setAutoresizesSubviews:NO];
		
		[window addSubview:_viewBorderDDlist];
		[_viewBorderDDlist release];
	}
    [self setDDListHidden:__isHiden];
    __isHiden = !__isHiden;
}
*/

- (void)createView
{
//	[_tableView setBackgroundColor:[UIColor clearColor]];
//	_ddList._delegate = self;
	int nBorder = 4;
	int nWidth = 156;
	if (!_viewBorderDDlist) {
		// 此处用UIWindow的目的是可以将视图显示到UINavigationBar上面
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		if (!window) {
			window = [[UIApplication sharedApplication].windows objectAtIndex:0];
		}
		
		_viewBorderDDlist = [[UIView alloc] initWithFrame:CGRectMake((window.frame.size.width - nWidth) / 2, 54, nWidth, 0)];
		_viewBorderDDlist.backgroundColor = [UIColor clearColor];
		
		btnBackground =[UIButton buttonWithType:UIButtonTypeCustom];
		btnBackground.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
		btnBackground.backgroundColor = [UIColor clearColor];
		[btnBackground addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
		[window addSubview:btnBackground];
		
		// _viewBorderDDlist的背景拉伸图片
		[_viewBorderDDlist addChatImage:[UIImage imageNamed:@"userRankingBubble"] point:CGPointMake(94, 12)];//37, 14
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(nBorder, nBorder + 6, nWidth - 2 * nBorder, 0)];
		[_viewBorderDDlist addSubview:_tableView];
        _tableView.separatorColor = [UIColor colorWithRed:212.0/255.0 green:207.0/255.0 blue:232.0/255.0 alpha:1];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView setBackgroundColor:[UIColor clearColor]];
		[_tableView release];
		
		// 改变父试图的frame，父父试图自动resieze子视图的frame，很是蛋疼啊。
//		[_viewBorderDDlist setAutoresizesSubviews:YES];
		
		[window addSubview:_viewBorderDDlist];
		[_viewBorderDDlist release];
	}
    [self setDDListHidden:__isHiden];
    __isHiden = !__isHiden;
}

- (void)setDDListHidden:(BOOL)hidden {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.2];
    int nBorder = hidden ? 0 : 4;
    int nWidth = 156;
    int rowCount = _resultList.count < 7 ? _resultList.count : 7;
	NSInteger height = hidden ? 0 : rowCount * tableViewCellHeight;
	//    NSInteger height = hidden ? 0 : 20;
	NSInteger newHeight =  hidden ? 0 : height + (nBorder + 4) * 2;
//	newHeight = MAX(newHeight, );
	
    // 注意:因为_ddList是_viewBorderDDlist的子view，所以_ddList的view的frame的坐标是相对_viewBorderDDlist的坐标
    [_tableView setFrame:CGRectMake(nBorder, nBorder + 8, nWidth - 2 *nBorder, height)];
    [_viewBorderDDlist setFrame:CGRectMake(_viewBorderDDlist.frame.origin.x	, _viewBorderDDlist.frame.origin.y, _viewBorderDDlist.frame.size.width, newHeight)];//height + nBorder * 2
    [_viewBorderDDlist addChatImage:[UIImage imageNamed:@"userRankingBubble"] point:CGPointMake(94, 12)];
	
	UIImageView *titleTag = (UIImageView *)[self viewWithTag:1002];

	[titleTag setImage:[UIImage imageNamed:@"SongStudio_Detail"]];
	/**
	 The first is the angle in radians the other 3 parameters are the axis (x, y, z). So for example if you want to rotate 180 degrees around the z axis just call the function like this:
	 
	 myView.layer.transform = CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0);
	 and apply the result to the transform property of the view you want to rotate.
	 
	 * 45度 2 * M_PI / 8 = 0.78  (45度为圆的1/8)
	 * 180度 2 * M_PI / 2 = M_PI (180度为园的1/2)
	 * http://blog.sina.com.cn/s/blog_9dfacc400100zua5.html
	 */
	[CATransaction begin];
	[CATransaction setAnimationDuration:0.5];
	if (hidden) {
		titleTag.layer.transform = CATransform3DIdentity;
	} else {
		titleTag.layer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
		[_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:nSelected inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
	[CATransaction commit];
	btnBackground.hidden = hidden;

	[UIView commitAnimations];
}


- (void)buttonClick:(UIButton *)btn
{
	NSLog(@"buttonClick");
	[self setDDListHidden:YES];
    __isHiden = NO;
	btnBackground.hidden = YES;
}

- (void)btnTitleView:(UIButton *)sender
{
    NSLog(@"btnTitleView clicked");
	[self createView];
//    [self createPicker];
//    if (!_ddList) {
//        _ddList = [[DDList alloc] initWithStyle:UITableViewStylePlain];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_resultList count];
//    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    UIView *selectView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    selectView.backgroundColor = [UIColor clearColor];
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 2, 140, 30)];
//    selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    selectImageView.image = [UIImage imageNamed:@"userRankSelect.png"];
    [selectView addSubview:selectImageView];
    cell.selectedBackgroundView = selectView;
    [selectImageView release];
//	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    // Configure the cell...
	NSUInteger row = [indexPath row];
//	cell.textLabel.text = [_resultList objectAtIndex:row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1];
    cell.textLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.33f];
    cell.textLabel.shadowOffset = CGSizeMake(0, 0.5f);
    cell.textLabel.text = [[_resultList objectAtIndex:row] title];
	cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return tableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedText = [[_resultList objectAtIndex:[indexPath row]] title];
//	[_delegate passValue:_selectedText];
	[self setDDListHidden:YES];
	__isHiden = NO;
	[_delegate didSelectAtIndex:indexPath];
}

@end

