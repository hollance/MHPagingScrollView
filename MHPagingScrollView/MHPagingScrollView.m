
#import "MHPagingScrollView.h"

@interface MHPage : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) NSUInteger index;

@end

@implementation MHPage

@end

@implementation MHPagingScrollView
{
	NSMutableSet *_recycledPages;
	NSMutableSet *_visiblePages;
	NSUInteger _firstVisiblePageIndexBeforeRotation;  // for autorotation
	CGFloat _percentScrolledIntoFirstVisiblePage;
}

- (void)commonInit
{
	_recycledPages = [[NSMutableSet alloc] init];
	_visiblePages  = [[NSMutableSet alloc] init];

	self.pagingEnabled = YES;
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.contentOffset = CGPointZero;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self commonInit];
	}
	return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	// This allows for touch handling outside of the scroll view's bounds.

	CGPoint parentLocation = [self convertPoint:point toView:self.superview];

	CGRect responseRect = self.frame;
	responseRect.origin.x -= _previewInsets.left;
	responseRect.origin.y -= _previewInsets.top;
	responseRect.size.width += (_previewInsets.left + _previewInsets.right);
	responseRect.size.height += (_previewInsets.top + _previewInsets.bottom);

	return CGRectContainsPoint(responseRect, parentLocation);
}

- (void)selectPageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	CGPoint newContentOffset = CGPointMake(self.bounds.size.width * index, 0);
	[self tilePagesAtPoint:newContentOffset];

	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}

	self.contentOffset = newContentOffset;

	if (animated)
		[UIView commitAnimations];
}

- (NSUInteger)indexOfSelectedPage
{
	CGFloat width = self.bounds.size.width;
	NSUInteger currentPage = (self.contentOffset.x + width/2.0) / width;
	return currentPage;
}

- (UIView *)selectedPage
{
	for (MHPage *page in _visiblePages)
	{
		if (page.index == [self indexOfSelectedPage])
			return page.view;
	}
	return nil;
}

- (NSUInteger)numberOfPages
{
	return [_pagingDelegate numberOfPagesInPagingScrollView:self];
}

- (CGSize)contentSizeForPagingScrollView
{
	CGRect rect = self.bounds;
	return CGSizeMake(rect.size.width * [self numberOfPages], rect.size.height);
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
	for (MHPage *page in _visiblePages)
	{
		if (page.index == index)
			return YES;
	}
	return NO;
}

- (UIView *)dequeueReusablePage
{
	MHPage *page = [_recycledPages anyObject];
	if (page != nil)
	{
		UIView *view = page.view;
		[_recycledPages removeObject:page];
		return view;
	}
	return nil;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
	CGRect rect = self.bounds;
	rect.origin.x = rect.size.width * index;
	return rect;
}

- (void)tilePagesAtPoint:(CGPoint)newOffset
{
	CGFloat pageWidth = self.bounds.size.width;
	CGFloat minX = newOffset.x - _previewInsets.left;
	CGFloat maxX = newOffset.x + pageWidth + _previewInsets.right - 1.0;

	NSUInteger firstNeededPageIndex = MAX(minX / pageWidth, 0);
	NSUInteger lastNeededPageIndex = MIN(maxX / pageWidth, (NSInteger)[self numberOfPages] - 1);

	for (MHPage *page in _visiblePages)
	{
		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex)
		{
			[_recycledPages addObject:page];
			[page.view removeFromSuperview];
		}
	}

	[_visiblePages minusSet:_recycledPages];

	for (NSUInteger i = firstNeededPageIndex; i <= lastNeededPageIndex; ++i)
	{
		if (![self isDisplayingPageForIndex:i])
		{
			UIView *pageView = [_pagingDelegate pagingScrollView:self pageForIndex:i];
			pageView.frame = [self frameForPageAtIndex:i];
			pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[self addSubview:pageView];

			MHPage *page = [[MHPage alloc] init];
			page.index = i;
			page.view = pageView;
			[_visiblePages addObject:page];
		}
	}
}

- (void)reloadPages
{
	self.contentSize = [self contentSizeForPagingScrollView];
	[self tilePagesAtPoint:self.contentOffset];
}

- (void)scrollViewDidScroll
{
	[self tilePagesAtPoint:self.contentOffset];
}

- (void)beforeRotation
{
	CGFloat offset = self.contentOffset.x;
	CGFloat pageWidth = self.bounds.size.width;

	if (offset >= 0)
		_firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
	else
		_firstVisiblePageIndexBeforeRotation = 0;

	_percentScrolledIntoFirstVisiblePage = offset / pageWidth - _firstVisiblePageIndexBeforeRotation;
}

- (void)afterRotation
{
	self.contentSize = [self contentSizeForPagingScrollView];

	for (MHPage *page in _visiblePages)
		page.view.frame = [self frameForPageAtIndex:page.index];

	CGFloat pageWidth = self.bounds.size.width;
	CGFloat newOffset = (_firstVisiblePageIndexBeforeRotation + _percentScrolledIntoFirstVisiblePage) * pageWidth;
	self.contentOffset = CGPointMake(newOffset, 0);
}

- (void)didReceiveMemoryWarning
{
	[_recycledPages removeAllObjects];
}

@end
