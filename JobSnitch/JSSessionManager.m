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

@end


