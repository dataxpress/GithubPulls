//
//  TGAppDelegate.h
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainViewController.h"


@interface TGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet MainViewController *mainViewController;
@property (assign) IBOutlet NSWindow *window;

@end
