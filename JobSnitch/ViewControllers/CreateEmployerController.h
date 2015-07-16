//
//  CreateEmployerController.h
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
@protocol EmployerProfileContainerDelegate <NSObject>
-(void) hasFinishedProfile;

@end

@interface CreateEmployerController : BaseJSViewController <UITextFieldDelegate>

@property (assign) id<EmployerProfileContainerDelegate> delegate;     // the parent controller implements this

-(void) customizeSettings;
@end
