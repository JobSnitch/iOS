//
//  BaseJSViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeFirstView.h"

@class UserRecord;
@class EmployeeRecord;
@class EmployerRecord;
@class CompanyRecord;

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
@property (nonatomic, strong)   CompanyRecord *currentCompany;

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

-(void) getCompanyProfileForUser:(NSString *) userID;
-(void) setupDataAndViews: (NSArray *) postings;
@end
