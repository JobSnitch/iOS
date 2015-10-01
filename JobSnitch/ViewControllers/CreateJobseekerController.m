//
//  CreateJobseekerController.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "CreateJobseekerController.h"
#import "CreateTopView.h"
#import "JSPickerView.h"
#import "EmployeeRecord.h"

@interface CreateJobseekerController () <UITableViewDelegate, UITableViewDataSource, PhotoDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *oTopView;
@property (weak, nonatomic) IBOutlet UITextField *oPostalField;
@property (weak, nonatomic) IBOutlet UISlider *oProxySlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *oScrollView;
@property (weak, nonatomic) IBOutlet UIButton *oIndustryButton;
@property (weak, nonatomic) IBOutlet UIButton *oJobTypeButton;
@property (weak, nonatomic) IBOutlet UITableView *oJobTypeTable;
@property (weak, nonatomic) IBOutlet UITableView *oIndustryTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oJobTypeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oIndustryHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *oTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *oCreateButton;
@property (weak, nonatomic) IBOutlet UISwitch *oMorningSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oAfternoonSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oEveningSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *oNightSwitch;

@property (strong, nonatomic)   CreateTopView *oTopViewReal;
@property (nonatomic, strong)   UILabel * sliderLabel;
@property (nonatomic, strong)   NSMutableArray *currentJobTypes;
@property (nonatomic, strong)   NSMutableArray *currentIndustries;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation * myLocation;
@property (nonatomic)   PersonContext myContext;

@end

const float kMagicHeight1 = 1268.0;
#pragma mark - init
@implementation CreateJobseekerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myContext = creationContext;
    self.currentEmployee = [[EmployeeRecord alloc] init];
    [self setupTables];
    [self setupCustomViews];
    [self setupSlider];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    self.oPostalField.delegate = self;
    self.oPostalField.tag = 1004;
    self.oPostalField.returnKeyType = UIReturnKeyDone;
    self.currentJobTypes = [[NSMutableArray alloc] init];
    self.currentIndustries = [[NSMutableArray alloc] init];
}

-(void) setupTables {
    self.oJobTypeTable.delegate = self;
    self.oJobTypeTable.dataSource = self;
    
    self.oIndustryTable.delegate = self;
    self.oIndustryTable.dataSource = self;
    
}

-(void) setupCustomViews {
   CGRect topFrame = CGRectMake(0, 0,
                                 self.oTopView.frame.size.width, self.oTopView.frame.size.height);
    
    self.oTopViewReal = [[[NSBundle mainBundle] loadNibNamed:@"CreateTopView" owner:self options:nil] objectAtIndex:0];
    [self.oTopViewReal setFrame:topFrame];
    [self.oTopView addSubview:self.oTopViewReal];
    
    [self.oTopViewReal setupFields:self];
    self.oTopViewReal.parent = self;
    // overwrite
    self.oTopViewReal.oPhoneField.returnKeyType = UIReturnKeyNext;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self customizeSettings:self];
    UIImage *avatarImage = [super getAvatarPhoto];
    if (avatarImage && self.oTopViewReal) {
        [self.oTopViewReal.oPhotoButton setImage:avatarImage forState:UIControlStateNormal];
    }
}

-(void) viewDidAppear:(BOOL)animated {
    [self sliderAction2:self.oProxySlider];
}

-(void) viewDidLayoutSubviews {
    self.oWidthConstraint.constant = self.view.bounds.size.width-20.0;
    if (self.currentJobTypes && self.currentJobTypes.count) {
        self.oJobTypeHeightConstraint.constant = self.currentJobTypes.count * [self tableView:self.oJobTypeTable
                                                                      heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    if (self.currentIndustries && self.currentIndustries.count) {
        self.oIndustryHeightConstraint.constant = self.currentIndustries.count * [self tableView:self.oIndustryTable
                                                                         heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    self.oHeightConstraint.constant = kMagicHeight1 + self.oJobTypeHeightConstraint.constant + self.oIndustryHeightConstraint.constant;
    [super bringPickersToFront];

    [self.view layoutIfNeeded];
}

#pragma mark - settings context
-(void) customizeSettings:(id)sender {
    if (sender == self) {
        [super setupJobtypePicker];
        [super setupIndustryPicker];
    } else {
        _myContext = settingContext;
        self.oTitleLabel.text = @"Jobseeker Settings";
        [self.oCreateButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [super setupJobtypePickerOffset:49.0];
        [super setupIndustryPickerOffset:49.0];
    }
}

-(void) setupEmployee:(id) sender {
    if (sender != self) {               // settings
        [self downloadUserInfo:testUserID2];
    }
}

-(void) setupFromUserInfo:(UserRecord *)currUser {
    if (currUser.PostalCode) {
        self.oPostalField.text = currUser.PostalCode;
    }
    if (currUser.Email) {
        self.oTopViewReal.oEmailField.text = currUser.Email;
    }
    if (currUser.FirstName || currUser.LastName) {                      // my interpretation
        self.oTopViewReal.oUsernameField.text = [NSString stringWithFormat:@"%@ %@", currUser.FirstName, currUser.LastName];
    }
    self.oMorningSwitch.on = currUser->availability.MondayAM;
    self.oAfternoonSwitch.on = currUser->availability.MondayPM;
    self.oEveningSwitch.on = currUser->availability.MondayEvening;
    
    [self.view setNeedsDisplay];
}


// handle for UIKeyboardDidShowNotification
- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.oScrollView setContentOffset:CGPointMake(0, 56.0*2) animated:YES];
}

// handle for UIKeyboardDidHideNotification
-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.oScrollView setContentOffset:CGPointMake(0, 0) animated:NO];      // bug if YES?
}

#pragma mark - slider
-(void) setupSlider {
    [self.oProxySlider addTarget:self action:@selector(sliderAction1:) forControlEvents:UIControlEventValueChanged];
    [self.oProxySlider addTarget:self action:@selector(sliderAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.oProxySlider addTarget:self action:@selector(sliderAction2:) forControlEvents:UIControlEventTouchUpOutside];
    self.oProxySlider.minimumValue = 0.0;
    self.oProxySlider.maximumValue = 1.0;
    self.oProxySlider.continuous = YES;
    self.oProxySlider.value = 0.5;
    
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.sliderLabel setBackgroundColor:[UIColor clearColor]];
    [self.sliderLabel setTextAlignment:NSTextAlignmentCenter];
    [self.oProxySlider addSubview:self.sliderLabel];

}

-(void) sliderAction1:(id)sender {
    [self updateLabel];
}

-(void) sliderAction2:(id)sender {
    float roundVal = 0.0;
    NSString *text = @"";
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Black" size:9],
                                     NSForegroundColorAttributeName: [UIColor redColor]};

    if (self.oProxySlider.value < 0.2) {
        roundVal = 0.1;
        text = @"2km";
    } else if (self.oProxySlider.value < 0.4) {
        roundVal = 0.3;
        text = @"5km";
    } else if (self.oProxySlider.value < 0.6) {
        roundVal = 0.5;
        text = @"10km";
    } else if (self.oProxySlider.value < 0.8) {
        roundVal = 0.7;
        text = @"15km";
    } else {
        roundVal = 0.9;
        text = @"20km";
    }
    [self.oProxySlider setValue:roundVal animated:YES];
    self.sliderLabel.attributedText = [[NSAttributedString alloc] initWithString:text
                                                                      attributes:text1Attribute];
    [self updateLabel];
}

-(void) updateLabel {
    CGRect trackRect = [self.oProxySlider trackRectForBounds:self.oProxySlider.bounds];
    CGRect thumbRect = [self.oProxySlider thumbRectForBounds:self.oProxySlider.bounds trackRect:trackRect
                                                       value:self.oProxySlider.value];
    self.sliderLabel.center = CGPointMake(thumbRect.origin.x + thumbRect.size.width*0.5,  thumbRect.origin.y + thumbRect.size.height*0.5);
    [self.oProxySlider bringSubviewToFront:self.sliderLabel];
}

#pragma mark - actions
- (IBAction)actionFindme:(id)sender {
    [self initLocation];
}

- (IBAction)actionAddJobType:(id)sender {
    [super showJobtypePicker];
}

- (IBAction)actionAddIndustry:(id)sender {
    [super showIndustryPicker];
}

- (IBAction)actionCreateJobseeker:(id)sender {
    switch (_myContext) {
        case creationContext:
            [self ValidateAndCreate];
            break;
        case settingContext:
            [self ValidateAndSave];
            break;
        default:
            break;
    }
}

-(void) ValidateAndSave {
}

-(void) ValidateAndCreate {
    // check empty fields
    NSString *message = @"Please fill in the required fields and try again.";
    if ( !self.oTopViewReal.oUsernameField.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if ( !self.oTopViewReal.oPasswordField.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if ( !self.oTopViewReal.oEmailField.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if ( !self.oPostalField.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if (![self NSStringIsValidEmail:self.oTopViewReal.oEmailField.text])
    {
        message = @"Email address not valid";
        [self createWarningView:message];
        return ;
    }
    
    [self performSegueWithIdentifier:@"CreateEmpToEmployee" sender:self];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.oTopViewReal viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        [self.oScrollView setContentOffset:CGPointMake(0, 56.0*(textField.tag-1000+3)) animated:YES];
    } else {
        UIResponder* nextResponder = [self.oScrollView viewWithTag:nextTag];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
            [self.oScrollView setContentOffset:CGPointMake(0, 56.0*(textField.tag-1000+3)) animated:YES];
        } else {
        // Not found, so remove keyboard.
            [textField resignFirstResponder];
            [self.oScrollView setContentOffset:CGPointMake(0, 0) animated:NO];      // bug if YES?
        }
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - CLLocationManagerDelegate
- (void) initLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

// Failed to get current location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to Get Your Location");
}

// Got location and now update
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.myLocation = nil;
    self.myLocation = [newLocation copy];
//    NSLog(@"%f, %f, %f, %@", self.myLocation.coordinate.longitude,
//          self.myLocation.coordinate.latitude,
//          self.myLocation.altitude,
//          self.myLocation.description);
    [self.locationManager stopUpdatingLocation];
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.oJobTypeTable) {
        if (self.currentJobTypes) {
            return self.currentJobTypes.count;
        } else {
            return 0;
        }
    } else {
        if (self.currentIndustries) {
            return self.currentIndustries.count;
        } else {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=nil;
    if (tableView == self.oJobTypeTable) {
        if (!self.currentJobTypes || !(indexPath.row < self.currentJobTypes.count)) {
            return cell;
        }
    } else {
        if (!self.currentIndustries || !(indexPath.row < self.currentIndustries.count)){
            return cell;
        }
    }
    static NSString *CellIdentifier = @"JobSeekerTableID";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        NSArray* contentSubViews = [cell.contentView subviews];
        for (UIView* viewToRemove in contentSubViews)
        {
            [viewToRemove removeFromSuperview];
        }
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                                     NSForegroundColorAttributeName: [UIColor redColor]};
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 19.0f, 200.0f, 18.0f)];
    [cell.contentView addSubview:l1];
    l1.textAlignment = NSTextAlignmentLeft;
    NSString *content = nil;
    if (tableView == self.oJobTypeTable) {
        content = self.currentJobTypes[indexPath.row];
    } else {
        content = self.currentIndustries[indexPath.row];
    }

    l1.attributedText = [[NSAttributedString alloc] initWithString:content
                                                        attributes:text1Attribute];
    return cell;
}

#pragma mark - overwrite

-(void) refreshScreen {
    if (super.pickerSelectionJT) {
        [self.currentJobTypes addObject:super.pickerSelectionJT];
        [self.oJobTypeTable reloadData];
    }
    if (super.pickerSelectionI) {
        [self.currentIndustries addObject:super.pickerSelectionI];
        [self.oIndustryTable reloadData];
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - PhotoDelegate
-(void) delegateTakePhoto {
    [super takePhoto];
}

#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
