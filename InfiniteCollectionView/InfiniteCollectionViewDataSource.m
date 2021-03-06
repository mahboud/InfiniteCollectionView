//
//  InfiniteCollectionViewCollectionViewDataSource.m
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import "InfiniteCollectionViewDataSource.h"
#import "InfiniteCollectionViewCell.h"
#import "InfiniteCollectionViewImageManager.h"
#import "InfiniteCollectionViewLayout.h"
#import "geometry.h"

@implementation InfiniteCollectionViewDataSource {
  InfiniteCollectionViewLayout *_layout;
  NSInteger _realNumberOfSections;
  NSInteger _realNumberOfItems;
  InfiniteCollectionViewImageManager *_imageManager;
  CGSize collectionSize;
  NSIndexPath *tvSelectedIndexPath;
}
#define page_fulls_forward                                                     \
  2 // basically enough so that a peron who is trying to get to the left or top
    // edge gets tired and gives us a chance to reset

- (void)setup {
  _layout = [[InfiniteCollectionViewLayout alloc] init];
  self.collectionView.collectionViewLayout = _layout;
  self.collectionView.showsHorizontalScrollIndicator = NO;
  self.collectionView.showsVerticalScrollIndicator = NO;
  //	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  _layout.itemSize = CGSizeMake(item_width, item_height);
  _imageManager = [[InfiniteCollectionViewImageManager alloc] init];
  _realNumberOfSections = _imageManager.numberOfSections;
  _realNumberOfItems = _imageManager.numberOfItems;
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;

  collectionSize.width = _realNumberOfItems * 4;
  collectionSize.height = _realNumberOfSections * 4;
  _layout.collectionSize = collectionSize;
  [self.collectionView registerNib:
                           [UINib nibWithNibName:@"InfiniteCollectionViewCell"
                                          bundle:nil]
        forCellWithReuseIdentifier:@"InfiniteCollectionViewCell"];
}

- (void)showCollectionView {
  tvSelectedIndexPath =
      [NSIndexPath indexPathForItem:page_fulls_forward * _realNumberOfItems
                          inSection:page_fulls_forward * _realNumberOfSections];
  [self.collectionView setNeedsFocusUpdate];

  [_collectionView
      scrollToItemAtIndexPath:tvSelectedIndexPath
             atScrollPosition:
                 UICollectionViewScrollPositionCenteredHorizontally |
                 UICollectionViewScrollPositionCenteredVertically
                     animated:NO];
  [UIView animateWithDuration:1.0
                   animations:^{
                     _collectionView.alpha = 1.0;
                   }];
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {

  return collectionSize.height;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

  return collectionSize.width;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
  NSString *cellId;

  cellId = @"InfiniteCollectionViewCell";
  InfiniteCollectionViewCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                forIndexPath:indexPath];

  cell.label.text =
      [NSString stringWithFormat:@"(%ld,%ld)", (long)indexPath.section,
                                 (long)indexPath.item];
  cell.imageView.image = [_imageManager
        getImageForPath:indexPath
      completionHandler:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
          InfiniteCollectionViewCell *cell =
              (InfiniteCollectionViewCell *)[self.collectionView
                  cellForItemAtIndexPath:indexPath];
          if (cell) {
            [UIView transitionWithView:cell.imageView
                duration:0.5f
                options:UIViewAnimationOptionTransitionCrossDissolve
                animations:^(void) {
                  cell.imageView.image = image;
                }
                completion:^(BOOL finished) {
                  [cell setDownloaded];
                  if (finished) {
                  }
                }];
          }
        });
      }];
  if (cell.imageView.image)
    [cell setDownloaded];
  else
    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpeg"];
  return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat width = item_width;
  CGFloat height = item_height;

  return CGSizeMake(width, height);
}

#if TARGET_OS_TV
- (NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:
    (UICollectionView *)collectionView {
  return tvSelectedIndexPath;
}

- (void)collectionView:(UICollectionView *)collectionView
     didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context
    withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
  NSLog(@"%s: visited here", __PRETTY_FUNCTION__);
#if TARGET_OS_TV
  NSIndexPath *oldIndexPath = context.previouslyFocusedIndexPath;
//	if (oldIndexPath) {
//		tvSelectedIndexPath = [NSIndexPath
//indexPathForItem:oldIndexPath.item - 1 inSection:oldIndexPath.section - 1];
//		[self.collectionView setNeedsFocusUpdate];
////		[self.collectionView updateFocusIfNeeded];
//	}
#endif
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}
#else
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self scrollBackToStart];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  if (decelerate == NO)
    [self scrollBackToStart];
}

- (void)scrollBackToStart {
  CGPoint offset = self.collectionView.contentOffset;

  NSInteger section =
      offset.y / (item_height + gap_between_top_and_side_of_cells);
  CGFloat yOffset =
      ((NSInteger)offset.y) % (item_height + gap_between_top_and_side_of_cells);
  NSInteger newSection = 0;
  if (section > (page_fulls_forward + 1) * _realNumberOfSections) {
    newSection = page_fulls_forward * _realNumberOfSections +
                 section % _realNumberOfSections;
  } else if (section < (page_fulls_forward - 2) * _realNumberOfSections) {
    newSection = page_fulls_forward * _realNumberOfSections +
                 section % _realNumberOfSections;
  }
  CGFloat newYOffset = 0;
  if (newSection)
    newYOffset =
        newSection * (item_height + gap_between_top_and_side_of_cells) +
        yOffset;

  NSInteger item = offset.x / (item_width + gap_between_top_and_side_of_cells);
  CGFloat xOffset =
      ((NSInteger)offset.x) % (item_width + gap_between_top_and_side_of_cells);
  NSInteger newItem = 0;
  if (item > (page_fulls_forward + 1) * _realNumberOfItems) {
    newItem =
        page_fulls_forward * _realNumberOfItems + item % _realNumberOfItems;
  } else if (item < (page_fulls_forward - 2) * _realNumberOfItems) {
    newItem =
        page_fulls_forward * _realNumberOfItems + item % _realNumberOfItems;
  }
  CGFloat newXOffset = 0;
  if (newItem)
    newXOffset =
        newItem * (item_width + gap_between_top_and_side_of_cells) + xOffset;

  NSLog(@"%s - %@;  xLoc = %ld,  xOff = %f,  newSection = %ld, newItem = %ld",
        __PRETTY_FUNCTION__, NSStringFromCGPoint(offset), section, xOffset,
        newSection, newItem);
  self.collectionView.contentOffset =
      CGPointMake(newXOffset ?: offset.x, newYOffset ?: offset.y);
  ;
}
#endif

@end
