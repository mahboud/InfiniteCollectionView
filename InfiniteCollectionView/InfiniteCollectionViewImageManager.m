//
//  InfiniteCollectionViewImageManager.m
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//
#import "InfiniteCollectionViewImageManager.h"

static NSString *scheme = @"http";
static NSString *username = @"";
static NSString *password = @"";
static NSString *server = @"underthehood.realyze.com";
static NSString *basePath = @"/tests/superheroes/";


@implementation InfiniteCollectionViewImageManager
{
	NSURLSession *session;
	NSURLComponents *baseURL;
	NSCache *cache;
}

#define number_of_sections 15
#define number_of_items		5

-(NSInteger)numberOfItems
{
	return number_of_items;
}

-(NSInteger)numberOfSections
{
	return number_of_sections;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		baseURL = [[NSURLComponents alloc] init];
		baseURL.scheme = scheme;
		baseURL.host = server;
		baseURL.user = username;
		baseURL.password = password;
		baseURL.path = basePath;
		cache = [NSCache.alloc init];
//		static dispatch_once_t onceToken;
//		dispatch_once(&onceToken, ^{
//	No need for this to be a singleton since it isn't a backgroundSession
			NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

			configuration.sessionSendsLaunchEvents = YES;
			session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
			
//		});

	}
	return self;
}

- (void)downloadImage:(NSString *)file  completionHandler:(void (^)(UIImage *image))completionHandler
{
	NSURL *downloadURL = [[[baseURL URL] URLByAppendingPathComponent:file] URLByAppendingPathExtension:@"jpeg"];
	
	NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
		NSData *imageData=[NSData dataWithContentsOfFile:location.path];
		UIImage *image=[UIImage imageWithData:imageData];
		//		UIImage *image = [UIImage imageWithContentsOfFile:location.path];
		completionHandler(image);
	}];
	[downloadTask resume];

}
- (UIImage *) getImageForPath:(NSIndexPath *)path completionHandler:(void (^)(UIImage *))completionHandler
{
	NSInteger realSection, realItem;
	realItem = path.item;
	if (realItem >= number_of_items)
		realItem = realItem % number_of_items;
	realSection = path.section;
	if (realSection >= number_of_sections)
		realSection = realSection % number_of_sections;
	
	NSString *key = [NSString stringWithFormat:@"%04ld-%04ld", (long)realItem, (long)realSection];
	
	UIImage *image = [cache objectForKey:key];
	if (image == nil) {
		[self downloadImage:key completionHandler:^(UIImage *image) {
			if (image) {
				[cache setObject:image forKey:key];
				completionHandler(image);
			}
		}];
	}
	else {
		return image;
	}
	return nil;
}

@end
