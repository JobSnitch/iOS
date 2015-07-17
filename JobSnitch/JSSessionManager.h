//
//  JSSessionManager.h
//  JobSnitch
//
//  Created by Andrei Sava on 17/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface JSSessionManager : AFHTTPSessionManager

+ (JSSessionManager *)sharedManager;                  // singleton

- (void) monitorReachability;

- (NSURLSessionDataTask *)getJobCategoriesWithCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;

- (void) firstLevelError:(NSError *)error forService:(NSString *) service;
- (BOOL) checkResult: (NSDictionary *)results;


- (NSArray *) processJobCategoriesResults: (NSDictionary *)results;
@end
