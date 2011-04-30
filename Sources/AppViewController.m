
#import "AppViewController.h"
#import "PageView.h"

@implementation AppViewController

@synthesize pagingScrollView, pageControl;

- (void)viewDidLoad
{
	[super viewDidLoad];

	recycledPages = [[NSMutableSet alloc] init];
	visiblePages  = [[NSMutableSet alloc] init];

	pagingScrollView.contentOffset = CGPointZero;
	pageControl.currentPage = 0;

	previewWidth = 50.0f;
	numPages = 2;

	[self reloadPages];
}

- (void)releaseObjects
{
	[recycledPages release], recycledPages = nil;
	[visiblePages release], visiblePages = nil;
    [pagingScrollView release], pagingScrollView = nil;
	[pageControl release], pageControl = nil;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self releaseObjects];
}

- (void)dealloc
{
	[self releaseObjects];
	[super dealloc];
}

#pragma mark -
#pragma mark Actions

- (IBAction)pageTurn
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

	CGFloat width = pagingScrollView.bounds.size.width;
	pagingScrollView.contentOffset = CGPointMake(width * pageControl.currentPage, 0);

	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Page Recycling and Configuration

- (CGSize)contentSizeForPagingScrollView
{
	CGRect rect = pagingScrollView.bounds;
	return CGSizeMake(rect.size.width * numPages, rect.size.height);
}

- (int)indexOfCurrentPage
{
	CGFloat width = pagingScrollView.bounds.size.width;
	int currentPage = (pagingScrollView.contentOffset.x + width/2.0f) / width;
	return currentPage;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
	for (PageView* page in visiblePages)
	{
		if (page.pageIndex == index)
			return YES;
	}
	return NO;
}

- (PageView*)dequeueRecycledPage
{
	PageView* page = [recycledPages anyObject];
	if (page != nil)
	{
		[[page retain] autorelease];
		[recycledPages removeObject:page];
	}
	return page;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
	CGRect rect = pagingScrollView.bounds;
	rect.origin.x = rect.size.width * index;
	return rect;
}

- (void)configurePage:(PageView*)page forIndex:(NSUInteger)index
{
	page.pageIndex = index;
	page.frame = [self frameForPageAtIndex:index];
}

- (void)tilePages 
{
	CGRect visibleBounds = pagingScrollView.bounds;
	CGFloat pageWidth = CGRectGetWidth(visibleBounds);
	visibleBounds.origin.x -= previewWidth;
	visibleBounds.size.width += previewWidth*2;

	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / pageWidth);
	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, numPages - 1);

	for (PageView* page in visiblePages)
	{
		if (page.pageIndex < firstNeededPageIndex || page.pageIndex > lastNeededPageIndex)
		{
			[recycledPages addObject:page];
			[page removeFromSuperview];
		}
	}

	[visiblePages minusSet:recycledPages];

	for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; ++i)
	{
		if (![self isDisplayingPageForIndex:i])
		{
			PageView* page = [self dequeueRecycledPage];
			if (page == nil)
				page = [[[PageView alloc] init] autorelease];

			[self configurePage:page forIndex:i];
			[pagingScrollView addSubview:page];
			[visiblePages addObject:page];
		}
	}
}

- (void)reloadPages
{
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	pageControl.numberOfPages = numPages;
	[self tilePages];
}

#pragma mark -
#pragma mark View Controller Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	CGFloat offset = pagingScrollView.contentOffset.x;
	CGFloat pageWidth = pagingScrollView.bounds.size.width;

	if (offset >= 0)
		firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
	else
		firstVisiblePageIndexBeforeRotation = 0;

	percentScrolledIntoFirstVisiblePage = offset / pageWidth - firstVisiblePageIndexBeforeRotation;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	pagingScrollView.contentSize = [self contentSizeForPagingScrollView];

	for (PageView* page in visiblePages)
	{
		page.frame = [self frameForPageAtIndex:page.pageIndex];
	}

	CGFloat pageWidth = pagingScrollView.bounds.size.width;
	CGFloat newOffset = (firstVisiblePageIndexBeforeRotation + percentScrolledIntoFirstVisiblePage) * pageWidth;
	pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)theScrollView
{
	pageControl.currentPage = [self indexOfCurrentPage];
	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)theScrollView
{
	int currentPage = [self indexOfCurrentPage];
	if (currentPage == numPages - 1)
	{
		numPages++;
		[self reloadPages];
	}
}

@end
