
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window, viewController;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	[self.window addSubview:self.viewController.view];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)dealloc
{
	[window release];
	[viewController release];
	[super dealloc];
}

@end
