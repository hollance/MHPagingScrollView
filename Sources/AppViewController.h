
@interface AppViewController : UIViewController <UIScrollViewDelegate>
{
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

- (IBAction)pageTurn;

@end
