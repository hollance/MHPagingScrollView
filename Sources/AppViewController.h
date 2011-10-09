
#import "MHPagingScrollView.h"

@interface AppViewController : UIViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate>
{
	int numPages;
}

@property (nonatomic, retain) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (IBAction)pageTurn;

@end
