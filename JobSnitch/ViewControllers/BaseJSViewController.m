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
#import "JSSessionManager.h"
@import MobileCoreServices;

@interface BaseJSViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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

-(void)GoToViewController:(NSString *)viewControllerName{
    UIStoryboard *reflectionStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [reflectionStoryboard instantiateViewControllerWithIdentifier:viewControllerName];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - pickers
-(void) bringPickersToFront {
    if (self.jobtypePicker) {
        [self.view bringSubviewToFront:self.jobtypePicker];
    }
    if (self.industryPicker) {
        [self.view bringSubviewToFront:self.industryPicker];
    }
}

- (void) setupJobtypePicker {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.jobtypePicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght, _screenWidth, hght)];
    self.jobtypePicker.viewHeight = hght;
    [self.jobtypePicker addTargetForDoneButton:self action:@selector(jobtypeDone)];
    [self.jobtypePicker addTargetForCancelButton:self action:@selector(jobtypeCancel)];
    [self.view addSubview:self.jobtypePicker];
    
    self.jobtypePicker.hidden = true;
    self.jobtypePicker.picker.dataSource = self;
    self.jobtypePicker.picker.delegate = self;
    
    [self downloadJobCategories];
}

- (void) setupIndustryPicker {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.industryPicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght, _screenWidth, hght)];
    self.industryPicker.viewHeight = hght;
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

-(void) setupJobtypePickerOffset:(CGFloat) offset {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.jobtypePicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght-offset, _screenWidth, hght)];
    self.jobtypePicker.viewHeight = hght;
    [self.jobtypePicker addTargetForDoneButton:self action:@selector(jobtypeDone)];
    [self.jobtypePicker addTargetForCancelButton:self action:@selector(jobtypeCancel)];
    [self.view addSubview:self.jobtypePicker];
    
    self.jobtypePicker.hidden = true;
    self.jobtypePicker.picker.dataSource = self;
    self.jobtypePicker.picker.delegate = self;
    
    [self downloadJobCategories];
//    self.allJobTypes = @[
//                         @"Full-time",
//                         @"Freelance",
//                         @"Part-time",
//                         ];
}

-(void) setupIndustryPickerOffset:(CGFloat) offset {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.industryPicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght-offset, _screenWidth, hght)];
    self.industryPicker.viewHeight = hght;
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
    self.jobtypePicker.frame = CGRectMake(0, _screenHeight, _screenWidth, self.industryPicker.viewHeight);
    self.jobtypePicker.hidden = false;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.jobtypePicker.frame = CGRectMake(0, _screenHeight-self.industryPicker.viewHeight,
                                                               _screenWidth, self.industryPicker.viewHeight);
                     } completion:^(BOOL finished) {
                         self.pickerSelectionJT = self.allJobTypes[0];
                         self.pickerSelectionI = nil;
                     }];
    
}

- (void) hideJobtypePicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.jobtypePicker.frame = CGRectMake(0, _screenHeight, _screenWidth, self.industryPicker.viewHeight);
                     } completion:^(BOOL finished) {
                         self.jobtypePicker.hidden = true;
                     }];
}

- (void) showIndustryPicker
{
    self.industryPicker.frame = CGRectMake(0, _screenHeight, _screenWidth, self.industryPicker.viewHeight);
    self.industryPicker.hidden = false;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.industryPicker.frame = CGRectMake(0, _screenHeight-self.industryPicker.viewHeight,
                                                                _screenWidth, self.industryPicker.viewHeight);
                     }completion:^(BOOL finished) {
                         self.pickerSelectionI = self.allIndustries[0];
                         self.pickerSelectionJT = nil;
                     }];
}

- (void) hideIndustryPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.industryPicker.frame = CGRectMake(0, _screenHeight, _screenWidth, self.industryPicker.viewHeight);
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

#pragma mark - photos
-(void) takePhoto {
    [self startCameraControllerFromViewController: self usingDelegate: self];
}

// presents the UIImagePickerController for accepting a newly-captured photo
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if ((delegate == nil) || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum] == YES) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        cameraUI = nil;
        return NO;
    }
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for trimming movies.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *picture = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData *photoData = UIImageJPEGRepresentation(picture, 1.0);
        
        NSString *photoName = @"JSPhoto.JPG";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *photoPath = [documentsDir stringByAppendingPathComponent:photoName];
        
        [photoData writeToFile:photoPath atomically:YES];        
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(UIImage *) getAvatarPhoto {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *photoName = @"JSPhoto.JPG";
    NSString *photoPath = [documentsDir stringByAppendingPathComponent:photoName];
    UIImage *theImage = [UIImage imageWithContentsOfFile:photoPath];
    return theImage;
}

#pragma mark - GetAllJobCategories
-(void) downloadJobCategories {
    [[JSSessionManager sharedManager] getJobCategoriesWithCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                NSArray * resArray = [[JSSessionManager sharedManager] processJobCategoriesResults:results];
                [self useJobCategories:resArray];
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"GetAllJobCategories"];
        }
    }];
}

-(void) useJobCategories:(NSArray *) jobArray {
    if (jobArray && jobArray.count) {
        self.allJobTypes = [jobArray valueForKey:@"EnglishName"];
        [self.jobtypePicker.picker reloadAllComponents];
    }
}

#pragma mark - GetSpecificUser
-(void) downloadUserInfo:(NSString *) userID {
    if (!userID || [userID isEqualToString:@""]) {
        return;
    }
    [[JSSessionManager sharedManager] getUserInfoForUser:userID withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                UserRecord *currUser = [[JSSessionManager sharedManager] processUserInfoResults:results];
                [self performSelectorOnMainThread:@selector(setupFromUserInfo:) withObject:currUser waitUntilDone:NO];
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"GetSpecificUser"];
        }
    }];
}

-(void) setupFromUserInfo:(UserRecord *)currUser {
    
}



@end
