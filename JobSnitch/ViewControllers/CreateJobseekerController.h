//
//  CreateJobseekerController.h
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
@import CoreLocation;

@protocol EmployeeProfileContainerDelegate <NSObject>
-(void) hasFinishedProfile;

@end

@interface CreateJobseekerController : BaseJSViewController <UITextFieldDelegate, CLLocationManagerDelegate>
@property (assign) id<EmployeeProfileContainerDelegate> delegate;     // the parent controller implements this

-(void) customizeSettings:(id) sender;

@end
