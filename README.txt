This is largely based on WWDC 2010 session 104 and the PhotoScroller sample,
without the CATiledLayer pinch-to-zoom stuff.

I added the ability to see previews of the pages on the left and right.

It might be cool to refactor this as follows:
	-	Put most of the logic into a PagingScrollView class, that is a subclass
		of UIScrollView.
	-	The hitTest logic that is now in MHPreviewScrollViewContainer can go 
		into PagingScrollView as well, making this class unnecessary. See:
		http://stackoverflow.com/questions/1677085/paging-uiscrollview-in-increments-smaller-than-content-size
	-	PagingScrollView is its own UIScrollViewDelegate OR you need to call its
		scrollViewDidScroll directly.
	-	PagingScrollView needs to handle auto-rotation methods. Are there
		notifications for all of them, or does the VC need to forward them?
	-	There is a PagingScrollViewDelegate that does the dequeue. PageView is
		now unknown to PagingScrollView.
	-	We now no longer store pageIndex in PageView, but need some other way
		of making this connection (probably by storing another type in the set
		that maps the visible views to indexes)
	-	AppViewController does page control thing, implements the delegate,
		creates PageViews
