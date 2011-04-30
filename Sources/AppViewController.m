
#import "AppViewController.h"
#import "PageView.h"

@implementation AppViewController

@synthesize scrollView, pageControl;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	CGRect rect = [[UIScreen mainScreen] bounds];
	int numPages = 3;

	CGFloat pageWidth = scrollView.bounds.size.width;
	CGFloat pageHeight = scrollView.bounds.size.height;

	[scrollView setContentSize:CGSizeMake(numPages * pageWidth, pageHeight)];

	rect = CGRectMake(0, 0, pageWidth, pageHeight);

	PageView* pageView = [[PageView alloc] initWithFrame:rect index:1];
	[scrollView addSubview:pageView];
	[pageView release];

	pageView = [[PageView alloc] initWithFrame:rect index:2];
	pageView.center = CGPointMake(pageView.center.x * 3, pageView.center.y);
	[scrollView addSubview:pageView];
	[pageView release];

	pageView = [[PageView alloc] initWithFrame:rect index:3];
	pageView.center = CGPointMake(pageView.center.x * 5, pageView.center.y);
	[scrollView addSubview:pageView];
	[pageView release];
	
	pageControl.numberOfPages = numPages;
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

@end
