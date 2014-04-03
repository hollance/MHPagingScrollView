
#import "PageView.h"

@implementation PageView

- (id)init
{
	if ((self = [super init]))
	{
		self.opaque = YES;

		self.backgroundColor = [UIColor colorWithRed:(CGFloat)arc4random() / 0xFFFFFFFF
		                                       green:(CGFloat)arc4random() / 0xFFFFFFFF
		                                        blue:(CGFloat)arc4random() / 0xFFFFFFFF
		                                       alpha:1.0];

		self.textColor = [UIColor whiteColor];
		self.textAlignment = UITextAlignmentCenter;
		self.font = [UIFont boldSystemFontOfSize:36];
	}
	return self;
}

- (void)setPageIndex:(NSUInteger)newIndex
{
	self.text = [NSString stringWithFormat:@"%lu", (unsigned long)newIndex];
}

@end
