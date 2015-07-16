//
//  BaseJSViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
#import "JSCustomUnwindSegue.h"
#import "JSPickerView.h"

@interface BaseJSViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) JSPickerView * jobtypePicker;
@property (strong, nonatomic) JSPickerView * industryPicker;
@property (nonatomic)       CGFloat screenWidth;
@property (nonatomic)       CGFloat screenHeight;
@property (nonatomic, strong)   NSArray *allJobTypes;
@property (nonatomic, strong)   NSArray *allIndustries;

@end

@implementation BaseJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = screenRect.size.width;
    _screenHeight = screenRect.size.height;
}

-(void) initBackground {
    self.backgroundGradient = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.backgroundGradient setImage:[UIImage imageNamed:@"gradient_red_back_sq.png"]];
    [self.view addSubview:self.backgroundGradient];
    [self.view sendSubviewToBack:self.backgroundGradient];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - unwind segue
- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
}

// We need to over-ride this method from UIViewController to provide a custom segue for unwinding
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier {
    
    JSCustomUnwindSegue *segue = [[JSCustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    
    return segue;
}

#pragma mark - pickers
-(void) bringPickersToFront {
    [self.view bringSubviewToFront:self.jobtypePicker];
    [self.view bringSubviewToFront:self.industryPicker];
}

- (void) setupJobtypePicker {
    self.jobtypePicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-(216.0+JSPickerToolbarHeight),
                                                                        _screenWidth, 216.0+JSPickerToolbarHeight)];
    [self.jobtypePicker addTargetForDoneButton:self action:@selector(jobtypeDone)];
    [self.jobtypePicker addTargetForCancelButton:self action:@selector(jobtypeCancel)];
    [self.view addSubview:self.jobtypePicker];
    
    self.jobtypePicker.hidden = true;
    self.jobtypePicker.picker.dataSource = self;
    self.jobtypePicker.picker.delegate = self;
    
    self.allJobTypes = @[
                         @"Full-time",
                         @"Freelance",
                         @"Part-time",
                         ];
}

- (void) setupIndustryPicker {
    self.industryPicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-(216.0+JSPickerToolbarHeight),
                                                                         _screenWidth, 216.0+JSPickerToolbarHeight)];
    [self.industryPicker addTargetForDoneButton:self action:@selector(industryDone)];
    [self.industryPicker addTargetForCancelButton:self action:@selector(industryCancel)];
    [self.view addSubview:self.industryPicker];
    
    self.industryPicker.hidden = true;
    self.industryPicker.picker.dataSource = self;
    self.industryPicker.picker.delegate = self;
    
    self.allIndustries = @[
                           @"IT & Programming",
                           @"Design & Multimedia",
                           @"Writing & Translation",
                           @"Sales & Marketing",
                           @"Admin Support",
                           ];
}

- (void) showJobtypePicker
{
    self.jobtypePicker.frame = CGRectMake(0, _screenHeight, _screenWidth, 216.0+JSPickerToolbarHeight);
    self.jobtypePicker.hidden = false;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.jobtypePicker.frame = CGRectMake(0, _screenHeight-(216.0+JSPickerToolbarHeight),
                                                               _screenWidth, 216.0+JSPickerToolbarHeight);
                     } completion:^(BOOL finished) {
                         self.pickerSelectionJT = self.allJobTypes[0];
                         self.pickerSelectionI = nil;
                     }];
    
}

- (void) hideJobtypePicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.jobtypePicker.frame = CGRectMake(0, _screenHeight, _screenWidth, 216.0+JSPickerToolbarHeight);
                     } completion:^(BOOL finished) {
                         self.jobtypePicker.hidden = true;
                     }];
}

- (void) showIndustryPicker
{
    self.industryPicker.frame = CGRectMake(0, _screenHeight, _screenWidth, 216.0+JSPickerToolbarHeight);
    self.industryPicker.hidden = false;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.industryPicker.frame = CGRectMake(0, _screenHeight-(216.0+JSPickerToolbarHeight),
                                                                _screenWidth, 216.0+JSPickerToolbarHeight);
                     }completion:^(BOOL finished) {
                         self.pickerSelectionI = self.allIndustries[0];
                         self.pickerSelectionJT = nil;
                     }];
}

- (void) hideIndustryPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.industryPicker.frame = CGRectMake(0, _screenHeight, _screenWidth, 216.0+JSPickerToolbarHeight);
                     } completion:^(BOOL finished) {
                         self.industryPicker.hidden = true;
                     }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.jobtypePicker.picker) {
        return self.allJobTypes.count;
    } else {
        return self.allIndustries.count;
    }
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (pickerView == self.jobtypePicker.picker) {
        if (row < self.allJobTypes.count) {
            title = self.allJobTypes[row];
        }
    } else {
        if (row < self.allIndustries.count) {
            title = self.allIndustries[row];
        }
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickerSelectionJT = nil;
    self.pickerSelectionI = nil;
    if (pickerView == self.jobtypePicker.picker) {
        if (row < self.allJobTypes.count) {
            self.pickerSelectionJT = self.allJobTypes[row];
        }
    } else {
        if (row < self.allIndustries.count) {
            self.pickerSelectionI = self.allIndustries[row];
        }
    }
}

#pragma mark - Picker Views done

-(void)jobtypeDone {
    [self refreshScreen];
    [self hideJobtypePicker];
}

-(void)jobtypeCancel {
    [self hideJobtypePicker];
}

-(void)industryDone {
    [self refreshScreen];
    [self hideIndustryPicker];
}

-(void)industryCancel {
    [self hideIndustryPicker];
}

-(void) refreshScreen {
    
}

#pragma mark - Employee Data
-(void) setupEmployee {
    self.currentEmployee = [[EmployeeRecord alloc] init];
    self.currentEmployee.name = @"joe_blow";
    self.currentEmployee.imageName = @"small_add_photo.png";
    
}

#pragma mark - Employee interface
-(void) setupEmployeeView {
    self.employeeHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeFirstView" owner:self options:nil] objectAtIndex:0];
    [self.employeeHeaderView setFrame:self.view.frame];
    [self.view addSubview:self.employeeHeaderView];
}

#pragma mark - field validation

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;                                                                           // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) createWarningView:(NSString *)message {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


@end
