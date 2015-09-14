//
//  JSSessionManager.h
//  JobSnitch
//
//  Created by Andrei Sava on 17/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "UserRecord.h"
#import "PostingRecord.h"
#import "ApplicationRecord.h"
#import "CompanyRecord.h"

@interface JSSessionManager : AFHTTPSessionManager

+ (JSSessionManager *)sharedManager;                  // singleton

- (void) monitorReachability;

- (NSURLSessionDataTask *)getJobCategoriesWithCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getUserInfoForUser: (NSString *) user
                              withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getPostingsForUser: (NSString *) user
                              withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getPostingWithId: (NSString *) postingId
                            withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)userHasAlreadyAppliedForJob: (NSString *) postingId
                                       withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getApplicationsForJob: (NSString *) postingId
                                 withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getApplicationWithId: (NSString *) applId
                            withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)updatePostingWithParam: (NSString *) param
                                   withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)deletePostingWithId: (NSString *) postingId
                            withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)postNewApplicationWithParam: (NSString *) param
                                   withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)updateApplicationWithParam: (NSString *) param
                                  withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)postNewUserAccountWithParam: (NSString *) param
                                       withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)postNewPostingWithParam: (NSDictionary *) params
                                   withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getPostingsForCompany: (NSString *) companyId
                              withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getCompanyForUser: (NSString *) user
                             withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;
- (NSURLSessionDataTask *)getCompanyForId: (NSString *) companyId
                             withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion;


- (void) firstLevelError:(NSError *)error forService:(NSString *) service;
- (BOOL) checkResult: (NSDictionary *)results;

- (NSArray *) processJobCategoriesResults: (NSDictionary *)results;
- (UserRecord *) processUserInfoResults: (NSDictionary *)results;
- (BOOL) processNewPostingResults: (NSDictionary *)results;
- (NSMutableArray *) processAllPostingsResults: (NSDictionary *)results;
- (PostingRecord *) processPostingWithId: (NSDictionary *)results;
- (BOOL) processAlreadyAppliedForJob: (NSDictionary *)results;
- (NSArray *) processApplicationsResults: (NSDictionary *)results;
- (ApplicationRecord *) processApplicationWithId: (NSDictionary *)results;
- (BOOL) processUpdatePostingResults: (NSDictionary *)results;
- (BOOL) processDeletePosting: (NSDictionary *)results;
- (BOOL) processNewApplicationResults: (NSDictionary *)results;
- (BOOL) processUpdateApplicationResults: (NSDictionary *)results;
- (BOOL) processNewUserAccountResults: (NSDictionary *)results;
- (NSMutableArray *) processAllPostingsComResults: (NSDictionary *)results;
- (CompanyRecord *) processCompanyUserResults: (NSDictionary *)results;
- (CompanyRecord *) processCompanyIdResults: (NSDictionary *)results;

@end
