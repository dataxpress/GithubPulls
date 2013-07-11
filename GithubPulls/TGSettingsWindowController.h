//
//  TGSettingsWindowController.h
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TGSettingsWindowController : NSWindowController
- (IBAction)saveClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;
@property (assign) IBOutlet NSTextField *usernameField;
@property (assign) IBOutlet NSSecureTextField *passwordField;
@property (assign) IBOutlet NSTextView *reposField;

@end
