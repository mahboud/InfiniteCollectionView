//
//  InfiniteCollectionViewCollectionVIewLayout.m
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import "InfiniteCollectionViewLayout.h"
#import "geometry.h"

@implementation InfiniteCollectionViewLayout
{
	NSInteger maxItems;
	NSInteger maxSections;
}
-(void)prepareLayout{
		maxSections = self.collectionView.numberOfSections;
		maxItems = [self.collectionView numberOfItemsInSection:0];
}

-(CGSize)collectionViewContentSize {
	return CGSizeMake((_collectionSize.width + 2) * (_itemSize.width + gap_between_top_and_side_of_cells),
					  (_collectionSize.height + 2) * (_itemSize.height + gap_between_top_and_side_of_cells));
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	attributes.size = _itemSize;

	attributes.center = CGPointMake((_itemSize.width + gap_between_top_and_side_of_cells) * (indexPath.item + 0.5), (_itemSize.height + gap_between_top_and_side_of_cells) * (indexPath.section + 0.5));
	return attributes;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {

	NSMutableArray* attributes = [NSMutableArray array];

	NSInteger topItemVisible = CGRectGetMinX(rect) / (_itemSize.width + gap_between_top_and_side_of_cells);
	NSInteger bottomItemVisible = CGRectGetMaxX(rect) / (_itemSize.width + gap_between_top_and_side_of_cells);
	NSInteger firstSectionVisible = CGRectGetMinY(rect) / (_itemSize.height + gap_between_top_and_side_of_cells);
	NSInteger lastSectionVisible = CGRectGetMaxY(rect) / (_itemSize.height + gap_between_top_and_side_of_cells);

	if (topItemVisible < 0)
		topItemVisible = 0;
	if (firstSectionVisible < 0)
		firstSectionVisible = 0;
//	NSLog(@"top %ld, bottom %ld, first %ld, last %ld; attrib = %@", topItemVisible, bottomItemVisible, firstSectionVisible, lastSectionVisible, attributes);
	for (NSInteger section = firstSectionVisible; section <= lastSectionVisible; section++) {
		if (section >= maxSections)
			break;
		for(NSInteger item = topItemVisible ; item <= bottomItemVisible; item++) {
			if (item >= maxItems)
				break;
			NSIndexPath* indexPath = [NSIndexPath indexPathForItem:item inSection:section];
			[attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
		}
	}

	return attributes;
}



@end
