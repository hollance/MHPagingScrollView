
#import "AppViewController.h"
#import "PageView.h"

@implementation AppViewController

@synthesize pagingScrollView, pageControl;

- (void)viewDidLoad
{
	[super viewDidLoad];

	numPages = 2;

	pagingScrollView.previewInsets = UIEdgeInsetsMake(0, 50, 0, 50);
	[pagingScrollView reloadPages];

	pageControl.currentPage = 0;
	pageControl.numberOfPages = numPages;
}

- (void)releaseObjects
{
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

- (void)didReceiveMemoryWarning
{
	[pagingScrollView didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions

- (IBAction)pageTurn
{
	[pagingScrollView selectPageAtIndex:pageControl.currentPage animated:YES];
}

#pragma mark -
#pragma mark View Controller Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[pagingScrollView beforeRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[pagingScrollView afterRotation];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)theScrollView
{
	pageControl.currentPage = [pagingScrollView indexOfSelectedPage];
	[pagingScrollView scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)theScrollView
{
	if ([pagingScrollView indexOfSelectedPage] == numPages - 1)
	{
		numPages++;
		[pagingScrollView reloadPages];
		pageControl.numberOfPages = numPages;
	}
}

#pragma mark -
#pragma mark MHPagingScrollViewDelegate

- (NSInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView*)pagingScrollView
{
	return numPages;
}

- (UIView*)pagingScrollView:(MHPagingScrollView*)thePagingScrollView pageForIndex:(NSInteger)index
{
	PageView* pageView = (PageView*)[thePagingScrollView dequeueReusablePage];
	if (pageView == nil)
		pageView = [[[PageView alloc] init] autorelease];

	[pageView setPageIndex:index];
	return pageView;
}

@end
