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

@class MHPagingScrollView;

/*!
 * Delegate protocol for MHPagingScrollView.
 */
@protocol MHPagingScrollViewDelegate <NSObject>

/*!
 * Asks the delegate to return the number of pages.
 */
- (NSInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView;

/*!
 * Asks the delegate for a page to insert. The delegate should ask for a
 * reusable view using dequeueReusablePageView.
 */
- (UIView *)pagingScrollView:(MHPagingScrollView *)pagingScrollView pageForIndex:(NSInteger)index;

@end

/*!
 * A paging scroll view that uses a reusable page mechanism like UITableView.
 *
 * MHPagingScrollView allows you to show partial previews of the pages to the
 * left and right of the current page. The bounds of the scroll view always 
 * correspond to a single page. To allow these previews, make the scroll view
 * smaller to make room for the preview pages and set the previewInsets
 * property.
 */
@interface MHPagingScrollView : UIScrollView

/*! The delegate for paging events. */
@property (nonatomic, assign) IBOutlet id <MHPagingScrollViewDelegate> pagingDelegate;

/*! The width of the preview pages. */
@property (nonatomic, assign) UIEdgeInsets previewInsets;

/*!
 * Makes the page at the requested index visible.
 */
- (void)selectPageAtIndex:(NSInteger)index animated:(BOOL)animated;

/*!
 * Returns the index of the page that is currently visible.
 */
- (int)indexOfSelectedPage;

/*!
 * Returns a reusable UIView object.
 */
- (UIView *)dequeueReusablePage;

/*!
 * Reloads the pages. Call this method when the number of pages has changed.
 */
- (void)reloadPages;

/*!
 * Call this from your view controller's UIScrollViewDelegate.
 */
- (void)scrollViewDidScroll;

/*!
 * Call this from your view controller's willRotateToInterfaceOrientation if
 * you want to support autorotation.
 */
- (void)beforeRotation;

/*!
 * Call this from your view controller's willAnimateRotationToInterfaceOrientation
 * if you want to support autorotation.
 */
- (void)afterRotation;

/*!
 * Call this from your view controller's didReceiveMemoryWarning.
 */
- (void)didReceiveMemoryWarning;

@end
