//
//  GFECollectionViewCell.m
//  GFExercise
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import "GFECollectionViewCell.h"

@implementation GFECollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setDownloaded
{
	[_activityIndicator stopAnimating];
}
@end
