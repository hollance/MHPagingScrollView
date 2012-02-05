
#import "MHPagingScrollView.h"

@interface MHPage : NSObject

@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MHPage

@synthesize view;
@synthesize index;

- (void)dealloc
{
	[view release];
	[super dealloc];
}

@end

@implementation MHPagingScrollView
{
	NSMutableSet *recycledPages;
	NSMutableSet *visiblePages;
	int firstVisiblePageIndexBeforeRotation;      // for autorotation
	CGFloat percentScrolledIntoFirstVisiblePage;
}

@synthesize previewInsets;
@synthesize pagingDelegate;

- (void)commonInit
{
	recycledPages = [[NSMutableSet alloc] init];
	visiblePages  = [[NSMutableSet alloc] init];

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

- (void)dealloc
{
	[recycledPages release];
	[visiblePages release];
	[super dealloc];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	// This allows for touch handling outside of the scroll view's bounds.

	CGPoint parentLocation = [self convertPoint:point toView:self.superview];

	CGRect responseRect = self.frame;
	responseRect.origin.x -= previewInsets.left;
	responseRect.origin.y -= previewInsets.top;
	responseRect.size.width += (previewInsets.left + previewInsets.right);
	responseRect.size.height += (previewInsets.top + previewInsets.bottom);

	return CGRectContainsPoint(responseRect, parentLocation);
}

- (void)selectPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}

	self.contentOffset = CGPointMake(self.bounds.size.width * index, 0);

	if (animated)
		[UIView commitAnimations];
}

- (NSInteger)indexOfSelectedPage
{
	CGFloat width = self.bounds.size.width;
	int currentPage = (self.contentOffset.x + width/2.0f) / width;
	return currentPage;
}

- (NSInteger)numberOfPages
{
	return [pagingDelegate numberOfPagesInPagingScrollView:self];
}

- (CGSize)contentSizeForPagingScrollView
{
	CGRect rect = self.bounds;
	return CGSizeMake(rect.size.width * [self numberOfPages], rect.size.height);
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
	for (MHPage *page in visiblePages)
	{
		if (page.index == index)
			return YES;
	}
	return NO;
}

- (UIView *)dequeueReusablePage
{
	MHPage *page = [recycledPages anyObject];
	if (page != nil)
	{
		UIView *view = [[page.view retain] autorelease];
		[recycledPages removeObject:page];
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

- (void)tilePages 
{
	CGRect visibleBounds = self.bounds;
	CGFloat pageWidth = CGRectGetWidth(visibleBounds);
	visibleBounds.origin.x -= previewInsets.left;
	visibleBounds.size.width += (previewInsets.left + previewInsets.right);

	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / pageWidth);
	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, [self numberOfPages] - 1);

	for (MHPage *page in visiblePages)
	{
		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex)
		{
			[recycledPages addObject:page];
			[page.view removeFromSuperview];
		}
	}

	[visiblePages minusSet:recycledPages];

	for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; ++i)
	{
		if (![self isDisplayingPageForIndex:i])
		{
			UIView *pageView = [pagingDelegate pagingScrollView:self pageForIndex:i];
			pageView.frame = [self frameForPageAtIndex:i];
			[self addSubview:pageView];

			MHPage *page = [[MHPage alloc] init];
			page.index = i;
			page.view = pageView;
			[visiblePages addObject:page];
			[page release];
		}
	}
}

- (void)reloadPages
{
	self.contentSize = [self contentSizeForPagingScrollView];
	[self tilePages];
}

- (void)scrollViewDidScroll
{
	[self tilePages];
}

- (void)beforeRotation
{
	CGFloat offset = self.contentOffset.x;
	CGFloat pageWidth = self.bounds.size.width;

	if (offset >= 0)
		firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
	else
		firstVisiblePageIndexBeforeRotation = 0;

	percentScrolledIntoFirstVisiblePage = offset / pageWidth - firstVisiblePageIndexBeforeRotation;
}

- (void)afterRotation
{
	self.contentSize = [self contentSizeForPagingScrollView];

	for (MHPage *page in visiblePages)
		page.view.frame = [self frameForPageAtIndex:page.index];

	CGFloat pageWidth = self.bounds.size.width;
	CGFloat newOffset = (firstVisiblePageIndexBeforeRotation + percentScrolledIntoFirstVisiblePage) * pageWidth;
	self.contentOffset = CGPointMake(newOffset, 0);
}

- (void)didReceiveMemoryWarning
{
	[recycledPages removeAllObjects];
}

@end
