//
//  MainViewController.m
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "MainViewController.h"

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
    

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.data[sender.clickedRow
                                                                          ][@"url"]]];
    
}



#pragma mark - Network tools
-(void)reloadData
{
    
    
    
    
    
    
    
    [self.tableView reloadData];
}

#pragma mark - Interface methods

- (IBAction)refreshClicked:(id)sender
{
    [self reloadData];
}
@end
