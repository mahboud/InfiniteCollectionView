//
//  GFEImageManager.h
//  GFExercise
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GFEImageManager : NSObject {

}

@property (nonatomic) NSInteger numberOfSections;
@property (nonatomic) NSInteger numberOfRows;

- (UIImage *) getImageForPath:(NSIndexPath *)path completionHandler:(void (^)(UIImage *))completionHandler;

@end
