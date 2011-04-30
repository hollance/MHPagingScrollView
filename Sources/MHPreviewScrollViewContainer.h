
/*!
 * Allows a paging UIScrollView to show previews of the pages on either side of
 * the current page.
 *
 * The size of a page in a scroll view with paging enabled is always equal to
 * the bounds of the scroll view. The current SDK does not allow you to make 
 * the page size smaller. If you want to show a preview of the pages on either
 * side of the current page, you need to fake a smaller page size by making the 
 * scroll view itself smaller and turning off clipping so that it draws the
 * other pages outside its bounds.
 *
 * However, the scroll view will not receive touch events on anything outside
 * its bounds. To resolve that, you have to place the scroll view on a UIView,
 * the MHPreviewScrollViewContainer, which passes on such touches to the scroll
 * view. It can also be used to draw the background behind the scroll view.
 */
@interface MHPreviewScrollViewContainer : UIView
{
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@end
