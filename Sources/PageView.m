
#import "PageView.h"

@implementation PageView

- (id)initWithFrame:(CGRect)frame index:(int)index
{
	if ((self = [super initWithFrame:frame]))
	{
		self.opaque = YES;

		self.backgroundColor = [UIColor
			colorWithRed:(float)arc4random() / 0xFFFFFFFF
			green:(float)arc4random() / 0xFFFFFFFF
			blue:(float)arc4random() / 0xFFFFFFFF
			alpha:1.0];

		self.text = [NSString stringWithFormat:@"%d", index];
		self.textColor = [UIColor whiteColor];
		self.textAlignment = UITextAlignmentCenter;
		self.font = [UIFont boldSystemFontOfSize:36];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
