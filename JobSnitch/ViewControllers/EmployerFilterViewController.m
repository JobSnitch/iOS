//
//  EmployerFilterViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 20/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployerFilterViewController.h"
#import "EmployerRecord.h"
#import "BusinessRecord.h"
#import "PostingRecord.h"
#import "JSPickerView.h"
#import "JSDatePicker.h"
#import "CompanyRecord.h"

@interface EmployerFilterViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oTopImage;
@property (weak, nonatomic) IBOutlet UITextField *oBusinessText;
@property (weak, nonatomic) IBOutlet UITextField *oJobTypeText;
@property (weak, nonatomic) IBOutlet UITextField *oPostDateText;
@property (weak, nonatomic) IBOutlet UITextField *oRecentText;
@property (weak, nonatomic) IBOutlet UIImageView *oBackImage;
@property (weak, nonatomic) IBOutlet UIButton *oFilterButton;

//@property (nonatomic, strong)   EmployerRecord *currentEmployer;

@property (strong, nonatomic) JSPickerView * jobPicker;
@property (strong, nonatomic) JSPickerView * businessPicker;
@property (strong, nonatomic) JSPickerView * recentPicker;
@property (nonatomic, strong)  NSArray *businessArray;
@property (nonatomic, strong)  NSArray *jobTypeArray;
@property (nonatomic, strong)  NSArray *recentArray;
@property (nonatomic)       CGFloat screenWidth;
@property (nonatomic)       CGFloat screenHeight;
@property (strong, nonatomic) JSDatePicker *datePicker;
@property (nonatomic, strong)   NSMutableArray *postings;

@end

@implementation EmployerFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _screenWidth = screenRect.size.width;
    _screenHeight = screenRect.size.height;

    [self setupEmployer];
    
    [self setupBusinessPicker];
    [self setupJobPicker];
    [self setupRecentPicker];
    [self setupDatePicker];

    [self setupView];
}

-(void) viewDidLayoutSubviews {
    [self.view bringSubviewToFront:self.businessPicker];
    [self.view bringSubviewToFront:self.recentPicker];
    [self.view bringSubviewToFront:self.jobPicker];
    [self.view bringSubviewToFront:self.datePicker];

    [self.view layoutIfNeeded];
}

#pragma mark - Data
-(void) setupEmployer {
    [super setupEmployer];
    if ([self.currentEmployer.name isEqualToString:@"employer"]) {
        [self downloadUserInfo:testUserID2];
    }
    
    usleep(100000);
    [self getCompanyProfileForUser:testUserID2];

//    [self setupBusinesses];
}

-(void) setupDataAndViews: (NSArray *) postings {
    self.postings = [postings mutableCopy];
    [self setupBusinesses];
}

-(void) setupBusinesses {
    NSMutableSet *locations = [NSMutableSet setWithArray:[self.postings valueForKey:@"JobLocation"]];
//    NSLog(@"loca %@", locations);
    if (locations && [locations containsObject:[NSNull null]]) {
        [locations removeObject:[NSNull null]];
    }
    if (locations && (locations.count == 0)) {
        NSString *addr = [NSString stringWithFormat:@"%@ %@", self.currentCompany.City, self.currentCompany.Province];
        [locations addObject:addr];
    }
    if (locations) {
        self.businessArray = [locations allObjects];
        [self.businessPicker.picker reloadAllComponents];
    }
}

-(void) setupPicker:(JSPickerView *) pickerView height:(CGFloat) hght {
    pickerView.viewHeight = hght;
    [self.view addSubview:pickerView];
    pickerView.hidden = true;
    pickerView.picker.dataSource = self;
    pickerView.picker.delegate = self;
}

-(void) setupBusinessPicker {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.businessPicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght, _screenWidth, hght)];
    [self setupPicker:self.businessPicker height:hght];
    [self.businessPicker addTargetForDoneButton:self action:@selector(businessDone)];
    [self.businessPicker addTargetForCancelButton:self action:@selector(businessCancel)];
    
//    self.businessArray = [self.currentEmployer.businesses valueForKey:@"name"];
}

-(void) setupRecentPicker {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.recentPicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght, _screenWidth, hght)];
    [self setupPicker:self.recentPicker height:hght];
    [self.recentPicker addTargetForDoneButton:self action:@selector(recentDone)];
    [self.recentPicker addTargetForCancelButton:self action:@selector(recentCancel)];
    
    self.recentArray = @[ @"item1", @"item2"];
}

-(void) setupJobPicker{
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.jobPicker = [[JSPickerView alloc] initWithFrame:CGRectMake(0, _screenHeight-hght, _screenWidth, hght)];
    [self setupPicker:self.jobPicker height:hght];
    [self.jobPicker addTargetForDoneButton:self action:@selector(jobDone)];
    [self.jobPicker addTargetForCancelButton:self action:@selector(jobCancel)];
    
    [self downloadJobCategories];
}

-(void) useJobCategories:(NSArray *) jobArray {
    if (jobArray && jobArray.count) {
        self.jobTypeArray = [jobArray valueForKey:@"EnglishName"];
        [self.jobPicker.picker reloadAllComponents];
    }
}

- (void) setupDatePicker {
    CGFloat hght = 216.0+JSPickerToolbarHeight;
    self.datePicker = [[JSDatePicker alloc] initWithFrame:CGRectMake(0, _screenHeight-hght, _screenWidth, hght)];
    self.datePicker.viewHeight = hght;
    [self.view addSubview:self.datePicker];
    self.datePicker.hidden = true;
    [self.datePicker addTargetForDoneButton:self action:@selector(doneDatePressed)];
    [self.datePicker addTargetForCancelButton:self action:@selector(cancelDatePressed)];
    [self.datePicker setMode:UIDatePickerModeDate];
    [self.datePicker.picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)pickerChanged:(id)sender {
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMM d yyyy" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    
    self.oPostDateText.text = [formatter stringFromDate:[(UIDatePicker*)sender date]];
}

#pragma mark - interface
-(void) setupView {
    self.oBackImage.image = [UIImage imageNamed:@"gradient_red_back_sq"];
    [self setupHeader];
    [self setupTextFields];
}

-(void) setupHeader {
    self.oTopImage.image = [UIImage imageNamed:self.currentEmployer.imageName];
    self.oNameLabel.text = self.currentEmployer.name;
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.oTopImage.image = avatarImage;
    }
}

-(void) setupTextFields {
    self.oBusinessText.returnKeyType = UIReturnKeyNext;
    self.oBusinessText.delegate = self;
    self.oJobTypeText.returnKeyType = UIReturnKeyNext;
    self.oJobTypeText.delegate = self;
    self.oPostDateText.returnKeyType = UIReturnKeyNext;
    self.oPostDateText.delegate = self;
    self.oRecentText.returnKeyType = UIReturnKeyDone;
    self.oRecentText.delegate = self;

}

# pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.oBusinessText) {
        [self showPicker:self.businessPicker textField:self.oBusinessText];
        [self.view endEditing:YES];
        return NO; // preventing keyboard from showing
    } else if (self.businessPicker.hidden == false) {
        [self hidePicker:self.businessPicker];
    }
    
    if(textField == self.oRecentText) {
        [self showPicker:self.recentPicker textField:self.oRecentText];
        [self.view endEditing:YES];
        return NO; // preventing keyboard from showing
    } else if (self.recentPicker.hidden == false) {
        [self hidePicker:self.recentPicker];
    }
    
    if(textField == self.oJobTypeText) {
        [self showPicker:self.jobPicker textField:self.oJobTypeText];
        [self.view endEditing:YES];
        return NO; // preventing keyboard from showing
    } else if (self.jobPicker.hidden == false) {
        [self hidePicker:self.jobPicker];
    }
    
    if(textField == self.oPostDateText) {
        [self showDatePicker];
        [self.view endEditing:YES];
        return NO; // preventing keyboard from showing
    } else if (self.datePicker.hidden == false) {
        [self hidePicker:(JSPickerView *) self.datePicker];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.oBusinessText)
    {
        [self hidePicker:self.businessPicker];
    }
    if(textField == self.oRecentText)
    {
        [self hidePicker:self.recentPicker];
    }
    if(textField == self.oJobTypeText)
    {
        [self hidePicker:self.jobPicker];
    }
    if(textField == self.oPostDateText)
    {
        [self hidePicker:(JSPickerView *)self.datePicker];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.businessPicker.picker) {
        return self.businessArray.count;
    }
    if (pickerView == self.recentPicker.picker) {
        return self.recentArray.count;
    }
    if (pickerView == self.jobPicker.picker) {
        return self.jobTypeArray.count;
    }
    return 0;
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = nil;
    if (pickerView == self.businessPicker.picker) {
        if (row < self.businessArray.count) {
            title = self.businessArray[row];
        }
    }
    if (pickerView == self.recentPicker.picker) {
        if (row < self.recentArray.count) {
            title = self.recentArray[row];
        }
    }
    if (pickerView == self.jobPicker.picker) {
        if (row < self.jobTypeArray.count) {
            title = self.jobTypeArray[row];
        }
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.businessPicker.picker) {
        if (row < self.businessArray.count) {
            self.oBusinessText.text = self.businessArray[row];
        }
    }
    if (pickerView == self.recentPicker.picker) {
        if (row < self.recentArray.count) {
            self.oRecentText.text = self.recentArray[row];
        }
    }
    if (pickerView == self.jobPicker.picker) {
        if (row < self.jobTypeArray.count) {
            self.oJobTypeText.text = self.jobTypeArray[row];
        }
    }
}


#pragma mark - actions
- (IBAction)actionFilter:(id)sender {
}

-(void)businessDone {
    [self hidePicker:self.businessPicker];
}

-(void)businessCancel {
    self.oBusinessText.text = @"";
    [self hidePicker:self.businessPicker];
}

-(void)recentDone {
    [self hidePicker:self.recentPicker];
}

-(void)recentCancel {
    self.oRecentText.text = @"";
    [self hidePicker:self.recentPicker];
}

-(void)jobDone {
    [self hidePicker:self.jobPicker];
}

-(void)jobCancel {
    self.oJobTypeText.text = @"";
    [self hidePicker:self.jobPicker];
}

-(void)doneDatePressed {
    [self hidePicker:(JSPickerView *)self.datePicker];
}

-(void)cancelDatePressed {
    self.oPostDateText.text = @"";
    [self hidePicker:(JSPickerView *)self.datePicker];
}

- (void) showPicker:(JSPickerView *) pickerView textField:(UITextField *) field
{
    pickerView.frame = CGRectMake(0, _screenHeight, _screenWidth, 216.0+JSPickerToolbarHeight);
    pickerView.hidden = false;
    [UIView animateWithDuration:1.0
                     animations:^{
                         pickerView.frame = CGRectMake(0, _screenHeight-(216.0+JSPickerToolbarHeight),
                                                       _screenWidth, 216.0+JSPickerToolbarHeight);
                     }];
    [field setText:[self pickerView:pickerView.picker titleForRow:0 forComponent:0 ]];
}

- (void) showDatePicker
{
    self.datePicker.frame = CGRectMake(0, _screenHeight, _screenWidth, 216.0+JSPickerToolbarHeight);
    self.datePicker.hidden = false;
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.datePicker.frame = CGRectMake(0, _screenHeight-(216.0+JSPickerToolbarHeight),
                                                       _screenWidth, 216.0+JSPickerToolbarHeight);
                     }];
    [self pickerChanged:self.datePicker.picker];
}


- (void) hidePicker:(JSPickerView *) pickerView
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         pickerView.frame = CGRectMake(0, _screenHeight, _screenWidth, pickerView.viewHeight);
                     } completion:^(BOOL finished) {
                         pickerView.hidden = true;
                     }];
}

#pragma mark - UserInfo callback
-(void) setupFromUserInfo:(UserRecord *)currUser {
    if (currUser.FirstName) {                      // my interpretation
        self.currentEmployer.name = currUser.FirstName;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).currUserNick = currUser.FirstName;
        self.oNameLabel.text = self.currentEmployer.name;
    }
    
    [self.view setNeedsDisplay];
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
