
#import "DemoViewController.h"
#import "PageView.h"

@implementation DemoViewController
{
	NSUInteger _numPages;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	_numPages = 2;

	self.pagingScrollView.previewInsets = UIEdgeInsetsMake(0.0, 50.0, 0.0, 50.0);
	[self.pagingScrollView reloadPages];

	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = _numPages;
}

- (void)didReceiveMemoryWarning
{
	[self.pagingScrollView didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)pageTurn
{
	[self.pagingScrollView selectPageAtIndex:self.pageControl.currentPage animated:YES];
}

#pragma mark - View Controller Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView beforeRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView afterRotation];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
	if ([self.pagingScrollView indexOfSelectedPage] == _numPages - 1)
	{
		_numPages++;
		[self.pagingScrollView reloadPages];
		self.pageControl.numberOfPages = _numPages;
	}
}

#pragma mark - MHPagingScrollViewDelegate

- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
	return _numPages;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{
	PageView *pageView = (PageView *)[thePagingScrollView dequeueReusablePage];
	if (pageView == nil)
		pageView = [[PageView alloc] init];

	[pageView setPageIndex:index];
	return pageView;
}

@end
