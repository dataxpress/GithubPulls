//
//  TGDataManager.m
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import "TGDataManager.h"

#define kUsernameKey @"usernameKey"
#define kPasswordKey @"passwordKey"
#define kReposKey @"reposKey"

@interface TGDataManager ()

@property (nonatomic, retain) NSString* username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSArray* repos;

@end

@implementation TGDataManager

+(TGDataManager *)sharedDataManager
{
    static TGDataManager* sharedDataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[TGDataManager alloc] init];
    });
    return sharedDataManager;
}

-(id)init
{
    if(self = [super init])
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        _username = [[defaults objectForKey:kUsernameKey] retain];
        _password = [[defaults objectForKey:kPasswordKey] retain];
        _repos = [[defaults objectForKey:kReposKey] retain];
    }
    return self;
}

-(void)saveUsername:(NSString *)username password:(NSString *)password repos:(NSString *)repos
{
    NSUserDefaults* userDefaults= [NSUserDefaults standardUserDefaults];
    if(username.length > 0)
    {
        self.username = username;
        [userDefaults setObject:username forKey:kUsernameKey];
    }
    if(password.length > 0)
    {
        self.password = password;
        [userDefaults setObject:password forKey:kPasswordKey];
    }
    NSArray* reposArr = [repos componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [userDefaults setObject:reposArr forKey:kReposKey];
    [userDefaults synchronize];
    self.repos = reposArr;
}




@end
