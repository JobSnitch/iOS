//
//  BaseJSViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeRecord.h"
#import "EmployerRecord.h"
#import "EmployeeFirstView.h"

@interface BaseJSViewController : UIViewController
@property (nonatomic, strong) UIImageView *backgroundGradient;
@property (nonatomic, strong)   NSString *pickerSelectionJT;
@property (nonatomic, strong)   NSString *pickerSelectionI;

// for Employee
@property (nonatomic, strong)   EmployeeRecord *currentEmployee;
@property (nonatomic, strong)   EmployeeFirstView *employeeHeaderView;
@property (nonatomic, strong)   NSArray *jobCategories;

// for Employer
@property (nonatomic, strong)   EmployerRecord *currentEmployer;

-(void) initBackground;
-(void) setupJobtypePicker;
-(void) setupIndustryPicker;
-(void) setupJobtypePickerOffset:(CGFloat) offset;
-(void) setupIndustryPickerOffset:(CGFloat) offset;
-(void) bringPickersToFront;
-(void) showJobtypePicker;
-(void) showIndustryPicker;

-(void) setupEmployer;
-(void) setupEmployee;
-(void) setupEmployeeView;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(void) createWarningView:(NSString *)message;

-(void) takePhoto;
-(UIImage *) getAvatarPhoto;

-(void)GoToViewController:(NSString *)viewControllerName;

-(void) downloadJobCategories;
-(void) useJobCategories:(NSArray *) jobArray;

-(void) downloadUserInfo:(NSString *) userID;
-(void) setupFromUserInfo:(UserRecord *)currUser;

-(void) deleteFileAtPath: (NSString *) filePath;
@end
