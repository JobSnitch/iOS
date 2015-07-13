//
//  BaseJSViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseJSViewController : UIViewController
@property (nonatomic, strong) UIImageView *backgroundGradient;
@property (nonatomic, strong)   NSString *pickerSelectionJT;
@property (nonatomic, strong)   NSString *pickerSelectionI;

-(void) initBackground;
-(void) setupJobtypePicker;
-(void) setupIndustryPicker;
-(void) bringPickersToFront;
-(void) showJobtypePicker;
-(void) showIndustryPicker;
@end
