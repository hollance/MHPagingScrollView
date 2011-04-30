This is largely based on WWDC 2010 session 104 and the PhotoScroller sample,
without the CATiledLayer pinch-to-zoom stuff.

I added the ability to see previews of the pages on the left and right.

I moved most of the logic into a UIScrollView subclass that uses a delegate
much in the way UITableView uses a data source.
