InfiniteCollectionView
======================

A CollectionView-based photo gallery that can be scrolled in both axes infinitely.

This project will download a set of images from a server, and then use those images to populate a UICollectionView.  The collection view can be scrolled in all directions, and when we run out of unique image files, we repeat the same ones again.

The collectionview will reset its scroll position once it has been scrolled a few pagefuls, and scrolling has stopped.  This reset will create the illusion that the user can scroll forever.  We only reset the scroll position when the scroll movement has come to a stop, as that eliminates any chance of a stutter in the scroll movement.

This project demonstrates:

- getting images using NSURLSession
- caching images for use in a collection view using NSCache
- using UICollectionViewLayout to manage a repeating set of cells
- populating the UICollectionView with images from a server, asynchronously in the background
- manioulating the UIScrollView to give the illusion of continous infinite scrolling
- enhancing scroll performance of cells with shadows by using UIBezierPath
