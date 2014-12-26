//
//  InfiniteCollectionViewCollectionViewDataSource.h
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteCollectionViewDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (nonatomic) UICollectionView *collectionView;

- (void)setup;
- (void)showCollectionView;

@end
