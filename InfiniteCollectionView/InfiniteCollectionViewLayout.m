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
	NSInteger maxRows;
	NSInteger maxSections;
}
-(void)prepareLayout{
		maxSections = self.collectionView.numberOfSections;
		maxRows = [self.collectionView numberOfItemsInSection:0];
}

-(CGSize)collectionViewContentSize {
	return CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	attributes.size = _itemSize;

	attributes.center = CGPointMake((_itemSize.width + gap_between_top_and_side_of_cells) * (indexPath.section + 0.5), (_itemSize.height + gap_between_top_and_side_of_cells) * (indexPath.row + 0.5));
	return attributes;
}


-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {

	NSMutableArray* attributes = [NSMutableArray array];

	NSInteger topRowVisible = CGRectGetMinY(rect) / (_itemSize.height + gap_between_top_and_side_of_cells);
	NSInteger bottomRowVisible = CGRectGetMaxY(rect) / (_itemSize.height + gap_between_top_and_side_of_cells);
	NSInteger firstSectionVisible = CGRectGetMinX(rect) / (_itemSize.width + gap_between_top_and_side_of_cells);
	NSInteger lastSectionVisible = CGRectGetMaxX(rect) / (_itemSize.width + gap_between_top_and_side_of_cells);

	if (topRowVisible < 0)
		topRowVisible = 0;
	if (firstSectionVisible < 0)
		firstSectionVisible = 0;
//	NSLog(@"top %ld, bottom %ld, first %ld, last %ld; attrib = %@", topRowVisible, bottomRowVisible, firstSectionVisible, lastSectionVisible, attributes);
	for(NSInteger row = topRowVisible ; row <= bottomRowVisible; row++) {
		if (row >= maxRows)
			break;
		for (NSInteger section = firstSectionVisible; section <= lastSectionVisible; section++) {
			if (section >= maxSections)
				break;
			NSIndexPath* indexPath = [NSIndexPath indexPathForItem:row inSection:section];
			[attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
		}
	}

	return attributes;
}



@end