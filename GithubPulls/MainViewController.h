//
//  MainViewController.h
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSCollectionView *mainCollectionView;
- (IBAction)refreshClicked:(id)sender;
@property (assign) IBOutlet NSTableView *tableView;

@end
