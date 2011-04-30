
#import "PageView.h"

@implementation PageView

@synthesize pageIndex;

- (id)init
{
	if ((self = [super init]))
	{
		self.opaque = YES;

		self.backgroundColor = [UIColor
			colorWithRed:(float)arc4random() / 0xFFFFFFFF
			green:(float)arc4random() / 0xFFFFFFFF
			blue:(float)arc4random() / 0xFFFFFFFF
			alpha:1.0];

		self.textColor = [UIColor whiteColor];
		self.textAlignment = UITextAlignmentCenter;
		self.font = [UIFont boldSystemFontOfSize:36];
	}
	return self;
}

- (void)setPageIndex:(NSUInteger)newIndex
{
	pageIndex = newIndex;
	self.text = [NSString stringWithFormat:@"%d", pageIndex];
}

@end
