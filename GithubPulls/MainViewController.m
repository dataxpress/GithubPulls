//
//  MainViewController.m
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "MainViewController.h"
#import "NSData+Base64.h"

@interface MainViewController ()

@property (nonatomic, retain) NSMutableArray* data;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.data = [@[
                     @{@"reponame": @"iOS-Core",
                     @"pullno" : @"#90",
                     @"pullname" : @"Feature settings refactor",
                     @"dateopened" : @"Today 11:35am",
                     @"url" : @"http://github.com"}
                     
                     
                      ] mutableCopy];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.target = self;
    self.tableView.doubleAction = @selector(doubleClick:);
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

-(NSString*)username
{
#warning put a real username here
    return @"";
}
-(NSString*)password
{
#warning put a real password here
    return @"";
}


#pragma mark - Network tools
-(void)reloadData
{
    self.data = [NSMutableArray array];
    
    NSMutableURLRequest* jsonRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.github.com/repos/withbuddies/iOS-core/pulls"]];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [self username], [self password]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
    [jsonRequest setValue:authValue forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:jsonRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData* data, NSError * error) {
        
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
        
        
        [self.tableView reloadData];

    }];
    
    
}

#pragma mark - Interface methods

- (IBAction)refreshClicked:(id)sender
{
    [self reloadData];
}
@end
