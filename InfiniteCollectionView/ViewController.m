//
//  ViewController.m
//  InfiniteCollectionView
//
//  Created by mahboud on 11/18/14.
//  Copyright (c) 2014 mahboud. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteCollectionViewDataSource.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) InfiniteCollectionViewDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_dataSource = [[InfiniteCollectionViewDataSource alloc] init];
	_dataSource.collectionView = _collectionView;

	[_dataSource setup];
	
	_collectionView.alpha = 0;
}

- (UIView *)preferredFocusedView
{
	return _collectionView;
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[_dataSource showCollectionView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
