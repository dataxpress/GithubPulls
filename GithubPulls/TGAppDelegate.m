//
//  TGAppDelegate.m
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "TGAppDelegate.h"

@implementation TGAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    [self.window setContentView:self.mainViewController.view];

}

@end
