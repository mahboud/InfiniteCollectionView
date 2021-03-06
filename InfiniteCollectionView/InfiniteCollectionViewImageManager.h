//
//  InfiniteCollectionViewImageManager.h
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InfiniteCollectionViewImageManager
    : NSObject <NSURLSessionDelegate> {
}

@property(nonatomic) NSInteger numberOfSections;
@property(nonatomic) NSInteger numberOfItems;

- (UIImage *)getImageForPath:(NSIndexPath *)path
           completionHandler:(void (^)(UIImage *))completionHandler;

@end
