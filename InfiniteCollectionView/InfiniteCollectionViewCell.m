//
//  InfiniteCollectionViewCollectionViewCell.m
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import "InfiniteCollectionViewCell.h"

@implementation InfiniteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
	self.imageView.clipsToBounds = YES;
	self.clipsToBounds = NO;
	self.layer.shadowColor = [UIColor grayColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(2, 2);
	self.layer.shadowRadius	= 10;
	self.layer.shadowOpacity = 1.0;
}

-(void)layoutSubviews {
	[super layoutSubviews];
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
	self.layer.shadowPath = path.CGPath;


}
-(void)setDownloaded
{
	[_activityIndicator stopAnimating];
}
@end