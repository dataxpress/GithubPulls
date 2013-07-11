//
//  TGSettingsWindowController.m
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "TGSettingsWindowController.h"
#import "TGDataManager.h"

@interface TGSettingsWindowController ()

@end

@implementation TGSettingsWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.usernameField.stringValue = [TGDataManager sharedDataManager].username;
    self.passwordField.stringValue = [TGDataManager sharedDataManager].password;
    self.reposField.string = [[TGDataManager sharedDataManager].repos componentsJoinedByString:@"\n"];
    
    
}

- (IBAction)saveClicked:(id)sender {
    
    [[TGDataManager sharedDataManager] saveUsername:self.usernameField.stringValue
                                           password:self.passwordField.stringValue
                                              repos:self.reposField.string];
    
    
    [self cancelClicked:nil];
}

- (IBAction)cancelClicked:(id)sender {
    [NSApp stopModal];
    [self close];
}


@end
