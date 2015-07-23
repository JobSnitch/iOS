//
//  AppDelegate.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "JSSessionManager.h"
#import "AFNetworkActivityLogger.h"

@interface AppDelegate () <UIAlertViewDelegate>
@property (nonatomic) BOOL alertPresent;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _alertPresent = FALSE;
    [[JSSessionManager sharedManager] monitorReachability];
    [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [self setupAppearance];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setupAppearance {
    [[UISlider appearance] setMaximumTrackTintColor:[UIColor redColor] ];           // if CGContextPath bug, comment this
    [[UISlider appearance] setMinimumTrackTintColor:[UIColor redColor] ];
}

#pragma mark - internet
-(void) internetLost {
    if (_alertPresent) return;            // don't want multiple
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert: no internet connection."
                                                    message:@"Please turn on internet connection to get full app functionality."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    _alertPresent = TRUE;
    [alert show];
    return;
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _alertPresent = FALSE;
}

-(void) internetReconnect {
    if ([self.window.rootViewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController * rootController = (HomeViewController *) self.window.rootViewController;
        if (rootController.isViewLoaded && rootController.view.window) {
            // viewController is visible
            [rootController doWhenInternetIsPresent];
        }
    }
}

@end
