
@interface AppViewController : UIViewController <UIScrollViewDelegate>
{
	int numPages;
	NSMutableSet* recycledPages;
	NSMutableSet* visiblePages;
	CGFloat previewWidth;

	int firstVisiblePageIndexBeforeRotation;      // for autorotation
	CGFloat percentScrolledIntoFirstVisiblePage;
}

@property (nonatomic, retain) IBOutlet UIScrollView* pagingScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction)pageTurn;

- (void)reloadPages;

@end
