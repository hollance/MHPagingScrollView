
#import "AppViewController.h"
#import "PageView.h"

@implementation AppViewController

@synthesize scrollView, pageControl;

- (void)addPageAtIndex:(int)index
{
	CGRect rect = CGRectMake(pageSize.width * index, 0, pageSize.width, pageSize.height);
	PageView* pageView = [[PageView alloc] initWithFrame:rect index:index];
	[scrollView addSubview:pageView];
	[pageView release];

	numPages++;
	[scrollView setContentSize:CGSizeMake(numPages * pageSize.width, pageSize.height)];
	pageControl.numberOfPages = numPages;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	numPages = 0;
	pageSize = scrollView.bounds.size;

	for (int t = 0; t < 2; ++t)
		[self addPageAtIndex:t];

	pageControl.currentPage = 0;
}

- (void)releaseObjects
{
    [scrollView release], scrollView = nil;
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

	CGFloat width = scrollView.bounds.size.width;
	scrollView.contentOffset = CGPointMake(width * pageControl.currentPage, 0);

	[UIView commitAnimations];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)theScrollView
{
	CGFloat width = theScrollView.bounds.size.width;
	pageControl.currentPage = (theScrollView.contentOffset.x + width/2.0f) / width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)theScrollView
{
	CGFloat width = theScrollView.bounds.size.width;
	int currentPage = (theScrollView.contentOffset.x + width/2.0f) / width;

	if (currentPage == numPages - 1)
		[self addPageAtIndex:numPages];
}

@end
