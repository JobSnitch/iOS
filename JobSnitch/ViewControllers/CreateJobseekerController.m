//
//  CreateJobseekerController.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "CreateJobseekerController.h"
#import "CreateTopView.h"

@interface CreateJobseekerController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *oTopView;
@property (weak, nonatomic) IBOutlet UITextField *oPostalField;
@property (weak, nonatomic) IBOutlet UISlider *oProxySlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *oScrollView;

@property (strong, nonatomic)  CreateTopView *oTopViewReal;
@property (nonatomic, strong) UILabel * sliderLabel;
@property (nonatomic)   int noOfJobTypes;
@property (nonatomic)   int noOfIndustries;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation * myLocation;

@end

const float kMagicHeight1 = 1268.0;
#pragma mark - init
@implementation CreateJobseekerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noOfJobTypes = 0;
    _noOfIndustries = 0;
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
}

-(void) setupCustomViews {
   CGRect topFrame = CGRectMake(0, 0,
                                 self.oTopView.frame.size.width, self.oTopView.frame.size.height);
    
    self.oTopViewReal = [[[NSBundle mainBundle] loadNibNamed:@"CreateTopView" owner:self options:nil] objectAtIndex:0];
    [self.oTopViewReal setFrame:topFrame];
    [self.oTopView addSubview:self.oTopViewReal];
    
    [self.oTopViewReal setupFields:self];
    // overwrite
    self.oTopViewReal.oPhoneField.returnKeyType = UIReturnKeyNext;
}

-(void) viewDidAppear:(BOOL)animated {
    [self sliderAction2:self.oProxySlider];
}

-(void) viewDidLayoutSubviews {
    self.oWidthConstraint.constant = self.view.bounds.size.width-20.0;
    self.oHeightConstraint.constant = kMagicHeight1 + 56.0* (_noOfJobTypes + _noOfIndustries);
    
    [self.view layoutIfNeeded];
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

- (IBAction)actionFindme:(id)sender {
    [self initLocation];
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
    NSLog(@"%f, %f, %f, %@", self.myLocation.coordinate.longitude,
          self.myLocation.coordinate.latitude,
          self.myLocation.altitude,
          self.myLocation.description);
    [self.locationManager stopUpdatingLocation];
    
}


#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
