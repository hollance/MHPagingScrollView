
#import "MHPreviewScrollViewContainer.h"

@implementation MHPreviewScrollViewContainer

@synthesize scrollView;

- (void)dealloc
{
	[scrollView release];
	[super dealloc];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
	UIView* child = [super hitTest:point withEvent:event];
	if (child == self)
		return self.scrollView;
	else
		return child;
}

@end
