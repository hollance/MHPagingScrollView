/*
 Based on the PhotoScroller sample code.
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "MHPagingScrollView.h"

@interface MHPage : NSObject

@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MHPage

@synthesize view;
@synthesize index;

- (void)dealloc
{
	[view release];
	[super dealloc];
}

@end

@implementation MHPagingScrollView
{
	NSMutableSet *recycledPages;
	NSMutableSet *visiblePages;

	int firstVisiblePageIndexBeforeRotation;      // for autorotation
	CGFloat percentScrolledIntoFirstVisiblePage;
}

@synthesize previewInsets;
@synthesize pagingDelegate;

- (void)commonInit
{
	recycledPages = [[NSMutableSet alloc] init];
	visiblePages  = [[NSMutableSet alloc] init];
	
	self.pagingEnabled = YES;
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.contentOffset = CGPointZero;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self commonInit];
	}
	return self;
}

- (void)dealloc
{
	[recycledPages release];
	[visiblePages release];
	[super dealloc];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	// This allows for touch handling outside of the scroll view's bounds.

	CGPoint parentLocation = [self convertPoint:point toView:self.superview];

	CGRect responseRect = self.frame;
	responseRect.origin.x -= previewInsets.left;
	responseRect.origin.y -= previewInsets.top;
	responseRect.size.width += (previewInsets.left + previewInsets.right);
	responseRect.size.height += (previewInsets.top + previewInsets.bottom);

	return CGRectContainsPoint(responseRect, parentLocation);
}

- (void)selectPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}

	self.contentOffset = CGPointMake(self.bounds.size.width * index, 0);

	if (animated)
		[UIView commitAnimations];
}

- (int)indexOfSelectedPage
{
	CGFloat width = self.bounds.size.width;
	int currentPage = (self.contentOffset.x + width/2.0f) / width;
	return currentPage;
}

- (NSInteger)numberOfPages
{
	return [pagingDelegate numberOfPagesInPagingScrollView:self];
}

- (CGSize)contentSizeForPagingScrollView
{
	CGRect rect = self.bounds;
	return CGSizeMake(rect.size.width * [self numberOfPages], rect.size.height);
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
	for (MHPage *page in visiblePages)
	{
		if (page.index == index)
			return YES;
	}
	return NO;
}

- (UIView *)dequeueReusablePage
{
	MHPage *page = [recycledPages anyObject];
	if (page != nil)
	{
		UIView *view = [[page.view retain] autorelease];
		[recycledPages removeObject:page];
		return view;
	}
	return nil;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
	CGRect rect = self.bounds;
	rect.origin.x = rect.size.width * index;
	return rect;
}

- (void)tilePages 
{
	CGRect visibleBounds = self.bounds;
	CGFloat pageWidth = CGRectGetWidth(visibleBounds);
	visibleBounds.origin.x -= previewInsets.left;
	visibleBounds.size.width += (previewInsets.left + previewInsets.right);

	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / pageWidth);
	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, [self numberOfPages] - 1);

	for (MHPage *page in visiblePages)
	{
		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex)
		{
			[recycledPages addObject:page];
			[page.view removeFromSuperview];
		}
	}

	[visiblePages minusSet:recycledPages];

	for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; ++i)
	{
		if (![self isDisplayingPageForIndex:i])
		{
			UIView *pageView = [pagingDelegate pagingScrollView:self pageForIndex:i];
			pageView.frame = [self frameForPageAtIndex:i];
			[self addSubview:pageView];

			MHPage *page = [[MHPage alloc] init];
			page.index = i;
			page.view = pageView;
			[visiblePages addObject:page];
			[page release];
		}
	}
}

- (void)reloadPages
{
    self.contentSize = [self contentSizeForPagingScrollView];
	[self tilePages];
}

- (void)scrollViewDidScroll
{
	[self tilePages];
}

- (void)beforeRotation
{
	CGFloat offset = self.contentOffset.x;
	CGFloat pageWidth = self.bounds.size.width;

	if (offset >= 0)
		firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
	else
		firstVisiblePageIndexBeforeRotation = 0;

	percentScrolledIntoFirstVisiblePage = offset / pageWidth - firstVisiblePageIndexBeforeRotation;
}

- (void)afterRotation
{
	self.contentSize = [self contentSizeForPagingScrollView];

	for (MHPage *page in visiblePages)
		page.view.frame = [self frameForPageAtIndex:page.index];

	CGFloat pageWidth = self.bounds.size.width;
	CGFloat newOffset = (firstVisiblePageIndexBeforeRotation + percentScrolledIntoFirstVisiblePage) * pageWidth;
	self.contentOffset = CGPointMake(newOffset, 0);
}

- (void)didReceiveMemoryWarning
{
	[recycledPages removeAllObjects];
}

@end
