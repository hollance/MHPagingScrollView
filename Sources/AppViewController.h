
@interface AppViewController : UIViewController <UIScrollViewDelegate>
{
	CGSize pageSize;
	int numPages;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction)pageTurn;

@end
