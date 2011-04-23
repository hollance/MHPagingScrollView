

#import "AppViewController.h"

@implementation AppViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)releaseObjects
{
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self releaseObjects];
}

- (void)dealloc
{
	[self releaseObjects];
	[super dealloc];
}

@end
