//
//  GFECollectionViewDataSource.m
//  GFExercise
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import "GFECollectionViewDataSource.h"
#import "GFECollectionViewCell.h"
#import "GFECollectionViewLayout.h"
#import "GFEImageManager.h"
#import "geometry.h"

@implementation GFECollectionViewDataSource
{
	GFECollectionViewLayout *_layout;
	NSInteger _realNumberOfSections;
	NSInteger _realNumberOfRows;
	GFEImageManager *_imageManager;
}
- (void)setup
{
	_layout = [[GFECollectionViewLayout alloc] init];
	self.collectionView.collectionViewLayout = _layout;
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.showsVerticalScrollIndicator = NO;
	//	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	_layout.itemSize = CGSizeMake(item_width, item_height);
	_imageManager = [[GFEImageManager alloc] init];
	_realNumberOfSections = _imageManager.numberOfSections;
	_realNumberOfRows = _imageManager.numberOfRows;
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;
	
	[self.collectionView registerNib: [UINib nibWithNibName:@"GFECollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GFECollectionViewCell"];
}

#define page_fulls_forward	100 // basically enough so that a peron who is trying to get to the left or top edge gets tired and gives us a chance to reset

- (void) showCollectionView {
	[_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page_fulls_forward * _realNumberOfRows inSection:page_fulls_forward * _realNumberOfSections] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally | UICollectionViewScrollPositionCenteredVertically animated:NO];
	[UIView animateWithDuration: 1.0
					 animations:^{
						 _collectionView.alpha = 1.0;
					 }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	
	return _realNumberOfSections * 1000;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	
	return _realNumberOfRows * 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *cellId;

	cellId = @"GFECollectionViewCell";
	GFECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

	cell.label.text = [NSString stringWithFormat:@"(%ld,%ld)", (long)indexPath.row, (long)indexPath.section];
	cell.imageView.image = [_imageManager getImageForPath:indexPath completionHandler:^(UIImage *image) {
		dispatch_async(dispatch_get_main_queue(), ^ {
			GFECollectionViewCell *cell = (GFECollectionViewCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
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
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat width = item_width;
	CGFloat height = item_height;

	return CGSizeMake(width, height);
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self scrollBackToStart];

}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (decelerate == NO)
		[self scrollBackToStart];
}

- (void)scrollBackToStart
{
	CGPoint offset = self.collectionView.contentOffset;
	
	NSInteger section = offset.x / (item_width + gap_between_top_and_side_of_cells);
	CGFloat xOffset = ((NSInteger) offset.x) % (item_width + gap_between_top_and_side_of_cells);
	NSInteger newSection = 0;
	if (section > (page_fulls_forward + 1) * _realNumberOfSections) {
		newSection = page_fulls_forward * _realNumberOfSections + section % _realNumberOfSections;
	}
	else if (section < (page_fulls_forward - 2) * _realNumberOfSections) {
		newSection = page_fulls_forward * _realNumberOfSections + section % _realNumberOfSections;
	}
	CGFloat newXOffset = 0;
	if (newSection)
		newXOffset = newSection * (item_width + gap_between_top_and_side_of_cells) + xOffset;

	NSInteger row = offset.y / (item_height+ gap_between_top_and_side_of_cells);
	CGFloat yOffset = ((NSInteger) offset.y) % (item_height + gap_between_top_and_side_of_cells);
	NSInteger newRow = 0;
	if (row > (page_fulls_forward + 1) * _realNumberOfRows) {
		newRow = page_fulls_forward * _realNumberOfRows + row % _realNumberOfRows;
	}
	else if (row < (page_fulls_forward - 2) * _realNumberOfRows) {
		newRow = page_fulls_forward * _realNumberOfRows + row % _realNumberOfRows;
	}
	CGFloat newYOffset = 0;
	if (newRow)
		newYOffset = newRow * (item_height + gap_between_top_and_side_of_cells) + yOffset;

	
//	NSLog(@"%s - %@;  xLoc = %ld,  xOff = %f,  newSection = %ld", __PRETTY_FUNCTION__, NSStringFromCGPoint(offset), section, xOffset, newSection	);
	self.collectionView.contentOffset = CGPointMake(newXOffset ?: offset.x, newYOffset ?: offset.y);;

}

@end
