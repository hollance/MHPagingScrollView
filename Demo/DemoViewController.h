
#import "MHPagingScrollView.h"

@interface DemoViewController : UIViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

- (IBAction)pageTurn;

@end
