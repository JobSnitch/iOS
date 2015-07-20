//
//  BaseJSViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeRecord.h"
#import "EmployeeFirstView.h"

@interface BaseJSViewController : UIViewController
@property (nonatomic, strong) UIImageView *backgroundGradient;
@property (nonatomic, strong)   NSString *pickerSelectionJT;
@property (nonatomic, strong)   NSString *pickerSelectionI;

// for Employee
@property (nonatomic, strong)   EmployeeRecord *currentEmployee;
@property (nonatomic, strong)   EmployeeFirstView *employeeHeaderView;

-(void) initBackground;
-(void) setupJobtypePicker;
-(void) setupIndustryPicker;
-(void) setupJobtypePickerOffset:(CGFloat) offset;
-(void) setupIndustryPickerOffset:(CGFloat) offset;
-(void) bringPickersToFront;
-(void) showJobtypePicker;
-(void) showIndustryPicker;

-(void) setupEmployee;
-(void) setupEmployeeView;

-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(void) createWarningView:(NSString *)message;

-(void) takePhoto;
-(UIImage *) getAvatarPhoto;

-(void) downloadJobCategories;
-(void) useJobCategories:(NSArray *) jobArray;

@end
