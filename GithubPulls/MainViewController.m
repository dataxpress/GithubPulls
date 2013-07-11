//
//  MainViewController.m
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "MainViewController.h"
#import "NSData+Base64.h"
#import "TGSettingsWindowController.h"
#import "TGDataManager.h"

@interface MainViewController ()

@property (nonatomic, retain) NSMutableArray* data;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
       
    }
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(doubleClick:);
    [self reloadData];
}


#pragma mark - Table view data source


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.data.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.data[row][tableColumn.identifier];
}

#pragma mark - Table view delegate


-(void)doubleClick:(NSTableView*)sender
{
    NSLog(@"Doubleclick on row %d.",(int)sender.clickedRow);
    

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.data[sender.clickedRow][@"url"]]];
    
}

#pragma mark - Network tools
-(void)reloadData
{
    
    if([TGDataManager sharedDataManager].repos == nil)
    {
        [self settingsClicked:nil];
        return;
    }
    
    self.data = [NSMutableArray array];
    
    [self loadRepositories:[TGDataManager sharedDataManager].repos];
}

-(void)loadRepositories:(NSArray*)repositories
{
    [self.waitSpinner startAnimation:nil];
    
    NSString* repository = [repositories lastObject];
    NSMutableURLRequest* jsonRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/pulls",repository]]];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[TGDataManager sharedDataManager] username], [[TGDataManager sharedDataManager] password]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
    [jsonRequest setValue:authValue forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:jsonRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData* data, NSError * error) {
        
        if(data == nil || error != nil)
        {
            [self.waitSpinner stopAnimation:nil];
            NSAlert* alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"An error occurred.  Check your username, password, and make sure the list of repositories doesn't have any weird characters and is a newline-separated list in the format: organization/repo\n\n%@",error.localizedDescription];
            [alert runModal];
            return;
        }
        
        NSArray* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if([result isKindOfClass:[NSDictionary class]] && ((NSDictionary*)result)[@"message"] != nil)
        {
            [self.waitSpinner stopAnimation:nil];
            NSAlert* alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"An error occurred.  Check your username, password, and make sure the list of repositories doesn't have any weird characters and is a newline-separated list in the format: organization/repo\n\n%@",((NSDictionary*)result)[@"message"]];
            [alert runModal];
            return;
        }
        
        for(NSDictionary* pull in result)
        {
            NSMutableDictionary* tempItem = [NSMutableDictionary dictionary];
            
            tempItem[@"url"] = pull[@"_links"][@"html"][@"href"];
            tempItem[@"pullno"] = pull[@"number"];
            tempItem[@"pullname"] = pull[@"title"];
            tempItem[@"dateopened"] = pull[@"updated_at"];
            tempItem[@"reponame"] = pull[@"base"][@"repo"][@"name"];
            
            [self.data addObject:tempItem];
            
        }
        
        [self.data sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSComparisonResult result = [obj1[@"reponame"] compare:obj2[@"reponame"]];
            if(result == NSOrderedSame)
            {
                result = [obj1[@"pullno"] compare:obj2[@"pullno"]];
            }
         return result;
         }];
        
        if(repositories.count > 1)
        {
            [self loadRepositories:[repositories subarrayWithRange:NSMakeRange(0, repositories.count-1)]];
        }
        else
        {
            
            [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(reloadData) userInfo:nil repeats:NO];
            
            [self.waitSpinner stopAnimation:nil];
            [self.tableView reloadData];
        }
    }];
    
    
}

#pragma mark - Interface methods

- (IBAction)refreshClicked:(id)sender
{
    [self reloadData];
}
- (IBAction)settingsClicked:(id)sender {
    TGSettingsWindowController* settingsWinCon = [[TGSettingsWindowController alloc] initWithWindowNibName:@"TGSettingsWindowController"];
    
    
    [[NSApplication sharedApplication] runModalForWindow:settingsWinCon.window];
    
    [self refreshClicked:nil];
    
    [settingsWinCon release];
    
}
@end
