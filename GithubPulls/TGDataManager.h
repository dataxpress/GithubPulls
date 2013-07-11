//
//  TGDataManager.h
//  GithubPulls
//
//  Created by Tim Gostony on 7/10/13.
//  Copyright (c) 2013 Tim Gostony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGDataManager : NSObject

+(TGDataManager*)sharedDataManager;

-(void)saveUsername:(NSString*)username
           password:(NSString*)password
              repos:(NSString*)repos;

@property (nonatomic, retain, readonly) NSString* username;
@property (nonatomic, retain, readonly) NSString* password;
@property (nonatomic, retain, readonly) NSArray* repos;

@end
