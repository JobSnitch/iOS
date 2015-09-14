//
//  JSSessionManager.m
//  JobSnitch
//
//  Created by Andrei Sava on 17/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "JSSessionManager.h"

@interface JSSessionManager ()
@property (nonatomic) BOOL connected;
@end

static BOOL hasBeenDisconnected = FALSE;

@implementation JSSessionManager

+ (JSSessionManager *)sharedManager {
    static JSSessionManager *sharedMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *baseURL = [NSURL URLWithString:baseJobSnitchURL];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sharedMgr = [[JSSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:config];
        [sharedMgr setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [sharedMgr setResponseSerializer:[AFJSONResponseSerializer serializer]];
        sharedMgr.connected = TRUE;
    });
    
    return sharedMgr;
}

#pragma mark -  reachability
- (void) monitorReachability {
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability
     setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
         switch (status) {
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 _connected = TRUE;
                 NSLog(@"----WWAN");
                 if (hasBeenDisconnected) {
                     hasBeenDisconnected = FALSE;
                     [((AppDelegate *)[UIApplication sharedApplication].delegate) internetReconnect];
                 }
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 _connected = TRUE;
                 NSLog(@"----WIFI");
                 if (hasBeenDisconnected) {
                     hasBeenDisconnected = FALSE;
                     [((AppDelegate *)[UIApplication sharedApplication].delegate) internetReconnect];
                 }
                 break;
             case AFNetworkReachabilityStatusNotReachable:
                 _connected = FALSE;
                 NSLog(@"----Not Reachable");
                 [((AppDelegate *)[UIApplication sharedApplication].delegate) internetLost];
                 hasBeenDisconnected = TRUE;
                 break;
             default:
                 break;
         }
     }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - launch tasks
-(BOOL) preLaunch {
    if (!_connected) {
        NSLog(@"ERROR: Internet Not Reachable");
        return FALSE;
    }
    self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    return TRUE;
}

#pragma mark - specific calls
- (NSURLSessionDataTask *)getJobCategoriesWithCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = @"jobEntry.svc/JobCategory/GetAllJobCategories";
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getUserInfoForUser: (NSString *) user
                              withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobAccount.svc/UserAccount/GetSpecificUser/%@", user];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getPostingsForUser: (NSString *) user
                              withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/GetAllJobPosting/%@", user];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getPostingWithId: (NSString *) postingId
                            withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion; {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/GetJobPosting?JobPostingId=%@", postingId];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)userHasAlreadyAppliedForJob: (NSString *) postingId
                                 withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/UserHasAlreadyAppliedForJob/%@", postingId];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getApplicationsForJob: (NSString *) postingId
                                 withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/GetApplicationsForJob/%@", postingId];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getApplicationWithId: (NSString *) applId
                                withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/GetApplicationDetails/%@", applId];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)deletePostingWithId: (NSString *) postingId
                               withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/DeleteJobPosting/%@", postingId];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getPostingsForCompany: (NSString *) companyId
                                 withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobCompany.svc/JobCompany/GetAllPostingsForCompany/%@", companyId];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getCompanyForUser: (NSString *) user
                             withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobCompany.svc/JobCompany/GetCompanyForUser/%@", user];
    return [self getForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)getCompanyForId: (NSString *) companyId
                           withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    
    NSDictionary *params = nil;
    NSString *service = [NSString stringWithFormat:@"jobCompany.svc/JobCompany/GetCompanyProfile/%@", companyId];
    return [self getForService:service withParams:params withCompletion:completion];
}


- (NSURLSessionDataTask *)postNewPostingWithParam: (NSDictionary *) params
                                   withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
//    NSDictionary *params = @{
//                             @"jobPosting": [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                             };
    NSLog(@"params: %@", params);
    NSString *service = [NSString stringWithFormat:@"jobCompany.svc/JobCompany/NewjobPosting"];
    return [self postForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)updatePostingWithParam: (NSString *) param
                                  withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    NSDictionary *params = @{
                             @"JobPosting": [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             };
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/UpdateJobPosting"];
    return [self postForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)postNewApplicationWithParam: (NSString *) param
                                       withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    NSDictionary *params = @{
                             @"jobApplication": [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             };
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/SubmitJobApplication"];
    return [self postForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)updateApplicationWithParam: (NSString *) param
                                      withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    NSDictionary *params = @{
                             @"jobApplication": [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             };
    NSString *service = [NSString stringWithFormat:@"jobEntry.svc/JobPosting/UpdateApplicationStatus"];
    return [self postForService:service withParams:params withCompletion:completion];
}

- (NSURLSessionDataTask *)postNewUserAccountWithParam: (NSString *) param
                                       withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    if (![self preLaunch]) return nil;
    NSDictionary *params = @{
                             @"AccountInformation": [param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             };
    NSString *service = [NSString stringWithFormat:@"jobAccount.svc/UserAccount/CreateUserAccountInfoEntry"];
    return [self postForService:service withParams:params withCompletion:completion];
}


#pragma mark - general calls
- (NSURLSessionDataTask *) getForService: (NSString *)service
                              withParams:  (NSDictionary *)params
                          withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    NSURLSessionDataTask *task = [self GET:service parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject, nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                       NSLog(@"%@", response);                                                     // for development
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    return task;
}

- (NSURLSessionDataTask *) postForService: (NSString *)service
                              withParams:  (NSDictionary *)params
                          withCompletion:( void (^)(NSDictionary *results, NSError *error) )completion {
    NSURLSessionDataTask *task = [self POST:service parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
                                       if (httpResponse.statusCode == 200) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(responseObject, nil);
                                           });
                                       } else {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               completion(nil, nil);
                                           });
                                       }
                                       
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                       NSLog(@"%@", response);                                                     // for development
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(nil, error);
                                       });
                                   }];
    return task;
}

- (void) firstLevelError:(NSError *)error forService:(NSString *) service {
    NSLog(@"API SERVICES ERROR for %@: %@", service, error);
}

- (BOOL) checkResult: (NSDictionary *)results {
    if (results) {                      // trivial, for now
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark - process results
- (NSArray *) processJobCategoriesResults: (NSDictionary *)results {
    NSArray *retArray = (NSArray *) results;
    return retArray;
}

- (UserRecord *) processUserInfoResults: (NSDictionary *)results {
    UserRecord *retUser = nil;
    if (results) {
        retUser = [[UserRecord alloc] init];
        retUser.Email = [results valueForKey:@"Email"];
        retUser.FirstName = [results valueForKey:@"FirstName"];
        retUser.Interests = [results valueForKey:@"Interests"];
        retUser.LastName = [results valueForKey:@"LastName"];
        retUser.PostalCode = [results valueForKey:@"PostalCode"];
        retUser.UserId = [results valueForKey:@"UserId"];
        NSDictionary *avail = [results valueForKey:@"AvailabilitySchedule"];
        if (avail) {
            retUser->availability.MondayAM = [[avail valueForKey:@"MondayAM"] boolValue];
            retUser->availability.TuesdayAM = [[avail valueForKey:@"TuesdayAM"] boolValue];
            retUser->availability.WednesdayAM = [[avail valueForKey:@"WednesdayAM"] boolValue];
            retUser->availability.ThursdayAM = [[avail valueForKey:@"ThursdayAM"] boolValue];
            retUser->availability.FridayAM = [[avail valueForKey:@"FridayAM"] boolValue];
            retUser->availability.SaturdayAM = [[avail valueForKey:@"SaturdayAM"] boolValue];
            retUser->availability.SundayAM = [[avail valueForKey:@"SundayAM"] boolValue];
            retUser->availability.MondayEvening = [[avail valueForKey:@"MondayEvening"] boolValue];
            retUser->availability.TuesdayEvening = [[avail valueForKey:@"TuesdayEvening"] boolValue];
            retUser->availability.WednesdayEvening = [[avail valueForKey:@"WednesdayEvening"] boolValue];
            retUser->availability.ThursdayEvening = [[avail valueForKey:@"ThursdayEvening"] boolValue];
            retUser->availability.FridayEvening = [[avail valueForKey:@"FridayEvening"] boolValue];
            retUser->availability.SaturdayEvening = [[avail valueForKey:@"SaturdayEvening"] boolValue];
            retUser->availability.SundayEvening = [[avail valueForKey:@"SundayEvening"] boolValue];
            retUser->availability.MondayPM = [[avail valueForKey:@"MondayPM"] boolValue];
            retUser->availability.TuesdayPM = [[avail valueForKey:@"TuesdayPM"] boolValue];
            retUser->availability.WednesdayPM = [[avail valueForKey:@"WednesdayPM"] boolValue];
            retUser->availability.ThursdayPM = [[avail valueForKey:@"ThursdayPM"] boolValue];
            retUser->availability.FridayPM = [[avail valueForKey:@"FridayPM"] boolValue];
            retUser->availability.SaturdayPM = [[avail valueForKey:@"SaturdayPM"] boolValue];
            retUser->availability.SundayPM = [[avail valueForKey:@"SundayPM"] boolValue];
        }
    }
//    NSLog(@"results: %@", results);
    return retUser;
}

- (BOOL) processNewPostingResults: (NSDictionary *)results {
    BOOL ret = TRUE;
    ret = [[results valueForKey:@"CreateNewJobPostingResult"] boolValue];
    return ret;
}
- (NSMutableArray *) processAllPostingsResults: (NSDictionary *)results {
    NSMutableArray *retArray = nil;
//    NSLog(@"AllPostings: %@", results);
    if (results) {
        retArray = [[NSMutableArray alloc] init];
        for (NSDictionary *posting in results) {
            PostingRecord *currPost = [[PostingRecord alloc] init];
            currPost.isActive = [[posting valueForKey:@"Active"] boolValue];
            NSDictionary *avail = [posting valueForKey:@"AvailabilitySchedule"];
            if (avail) {
                currPost.morningShift = [[avail valueForKey:@"MondayAM"] boolValue];
                currPost.afternoonShift = [[avail valueForKey:@"MondayPM"] boolValue];
                currPost.eveningShift = [[avail valueForKey:@"MondayEvening"] boolValue];
            }
//            currPost.CompanyId = [[posting valueForKey:@"CompanyId"] integerValue];
            currPost.CompanyId = [posting valueForKey:@"CompanyId"] ;
            currPost.descrption = [posting valueForKey:@"DescriptionEnglish"];
            NSDictionary *categ = [posting valueForKey:@"JobCategory"];
            if (categ) {
                currPost.JobCategoryId = [[categ valueForKey:@"JobCategoryId"] integerValue];
                currPost.JobCategoryName = [categ valueForKey:@"EnglishName"];
            }
            currPost.JobLocation = [posting valueForKey:@"JobLocation"];
            currPost.JobPostingId = [[posting valueForKey:@"JobPostingId"] integerValue];
            currPost.title = [posting valueForKey:@"TitleEnglish"];
            
            [retArray addObject:currPost];
        }
    }
    return retArray;
}

- (PostingRecord *) processPostingWithId: (NSDictionary *)results {
    PostingRecord * resPosting = nil;
    NSLog(@"posting: %@", results);
    return resPosting;
}

- (BOOL) processAlreadyAppliedForJob: (NSDictionary *)results {
    BOOL ret = FALSE;
    NSLog(@"AlreadyApplied:%@", results);
    return ret;
}

- (NSArray *) processApplicationsResults: (NSDictionary *)results {
    NSMutableArray *retArray = nil;
//    NSLog(@"AllApplications: %@", results);
    if (results) {
        retArray = [[NSMutableArray alloc] init];
        for (NSDictionary *appl in results) {
            ApplicationRecord *currAppl = [[ApplicationRecord alloc] init];
            NSDictionary *account = [appl valueForKey:@"Account"];
            if (account) {
                NSDictionary *avail = [account valueForKey:@"AvailabilitySchedule"];
                if (avail) {
                    currAppl.morningShift = [[avail valueForKey:@"MondayAM"] boolValue];
                    currAppl.afternoonShift = [[avail valueForKey:@"MondayPM"] boolValue];
                    currAppl.eveningShift = [[avail valueForKey:@"MondayEvening"] boolValue];
                }
                currAppl.email = [account valueForKey:@"Email"];
                currAppl.FirstName = [account valueForKey:@"FirstName"];
                currAppl.LastName = [account valueForKey:@"LastName"];
            }
            currAppl.ApplicationId = [appl valueForKey:@"ApplicationId"] ;
            currAppl.ApplicationStatus = [appl valueForKey:@"ApplicationStatus"];
            currAppl.JobPostingId = [appl valueForKey:@"JobPostingId"] ;
            currAppl.textResource = [appl valueForKey:@"Message"];
            currAppl.UserId = [appl valueForKey:@"UserId"] ;
            currAppl.VideoIncluded = [[appl valueForKey:@"VideoIncluded"] boolValue];

            [retArray addObject:currAppl];
        }
    }
    return retArray;
}

- (ApplicationRecord *) processApplicationWithId: (NSDictionary *)results {
    ApplicationRecord * currAppl = nil;
    NSLog(@"Application: %@", results);
    if (results) {
        currAppl = [[ApplicationRecord alloc] init];
        NSDictionary *account = [results valueForKey:@"Account"];
        if (account) {
            NSDictionary *avail = [account valueForKey:@"AvailabilitySchedule"];
            if (avail) {
                currAppl.morningShift = [[avail valueForKey:@"MondayAM"] boolValue];
                currAppl.afternoonShift = [[avail valueForKey:@"MondayPM"] boolValue];
                currAppl.eveningShift = [[avail valueForKey:@"MondayEvening"] boolValue];
            }
            currAppl.email = [account valueForKey:@"Email"];
            currAppl.FirstName = [account valueForKey:@"FirstName"];
            currAppl.LastName = [account valueForKey:@"LastName"];
        }
        currAppl.ApplicationId = [results valueForKey:@"ApplicationId"] ;
        currAppl.ApplicationStatus = [results valueForKey:@"ApplicationStatus"];
        currAppl.JobPostingId = [results valueForKey:@"JobPostingId"] ;
        currAppl.textResource = [results valueForKey:@"Message"];
        currAppl.UserId = [results valueForKey:@"UserId"] ;
        currAppl.VideoIncluded = [[results valueForKey:@"VideoIncluded"] boolValue];
    }
    return currAppl;
}

- (BOOL) processUpdatePostingResults: (NSDictionary *)results {
    BOOL ret = TRUE;
    NSLog(@"results:%@", results);
    return ret;
}

- (BOOL) processDeletePosting: (NSDictionary *)results {
    BOOL ret = TRUE;
    NSLog(@"results:%@", results);
    return ret;
}

- (BOOL) processNewApplicationResults: (NSDictionary *)results {
    BOOL ret = TRUE;
    NSLog(@"results:%@", results);
    return ret;
}

- (BOOL) processUpdateApplicationResults: (NSDictionary *)results {
    BOOL ret = TRUE;
    NSLog(@"results:%@", results);
    return ret;
}

- (BOOL) processNewUserAccountResults: (NSDictionary *)results {
    BOOL ret = TRUE;
    NSLog(@"results:%@", results);
    return ret;
}

- (NSMutableArray *) processAllPostingsComResults: (NSDictionary *)results {
    NSMutableArray *retArray = nil;
//    NSLog(@"AllPostings: %@", results);
    if (results) {
        retArray = [[NSMutableArray alloc] init];
        for (NSDictionary *posting in results) {
            PostingRecord *currPost = [[PostingRecord alloc] init];
            currPost.isActive = [[posting valueForKey:@"Active"] boolValue];
            NSDictionary *avail = [posting valueForKey:@"AvailabilitySchedule"];
            if (avail) {
                currPost.morningShift = [[avail valueForKey:@"MondayAM"] boolValue];
                currPost.afternoonShift = [[avail valueForKey:@"MondayPM"] boolValue];
                currPost.eveningShift = [[avail valueForKey:@"MondayEvening"] boolValue];
            }
//            currPost.CompanyId = [[posting valueForKey:@"CompanyId"] integerValue];
            currPost.CompanyId = [posting valueForKey:@"CompanyId"];
            currPost.descrption = [posting valueForKey:@"DescriptionEnglish"];
            NSDictionary *categ = [posting valueForKey:@"JobCategory"];
            if (categ) {
                currPost.JobCategoryId = [[categ valueForKey:@"JobCategoryId"] integerValue];
                currPost.JobCategoryName = [categ valueForKey:@"EnglishName"];
            }
            currPost.JobLocation = [posting valueForKey:@"JobLocation"];
            currPost.JobPostingId = [[posting valueForKey:@"JobPostingId"] integerValue];
            currPost.title = [posting valueForKey:@"TitleEnglish"];
            
            [retArray addObject:currPost];
        }
    }
    return retArray;
}

- (CompanyRecord *) processCompanyUserResults: (NSDictionary *)results {
    CompanyRecord * resCompany = nil;
    if (results) {
        resCompany = [[CompanyRecord alloc] init];
        resCompany.CompanyId = [[results valueForKey:@"CompanyId"] integerValue];
        resCompany.City = [results valueForKey:@"City"];
        resCompany.NameEnglish = [results valueForKey:@"NameEnglish"];
        resCompany.Province = [results valueForKey:@"Province"];
    }
    return resCompany;
}

- (CompanyRecord *) processCompanyIdResults: (NSDictionary *)results {
    CompanyRecord *resCompany = nil;
    if (results) {
        resCompany = [[CompanyRecord alloc] init];
        resCompany.CompanyId = [[results valueForKey:@"CompanyId"] integerValue];
        resCompany.City = [results valueForKey:@"City"];
        resCompany.NameEnglish = [results valueForKey:@"NameEnglish"];
        resCompany.Province = [results valueForKey:@"Province"];
    }
    return resCompany;
}


@end


