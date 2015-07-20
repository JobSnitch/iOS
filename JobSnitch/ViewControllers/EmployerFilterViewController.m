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

@interface EmployerFilterViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oTopImage;
@property (weak, nonatomic) IBOutlet UITextField *oBusinessText;
@property (weak, nonatomic) IBOutlet UITextField *oJobTypeText;
@property (weak, nonatomic) IBOutlet UITextField *oPostDateText;
@property (weak, nonatomic) IBOutlet UITextField *oRecentText;
@property (weak, nonatomic) IBOutlet UIImageView *oBackImage;
@property (weak, nonatomic) IBOutlet UIButton *oFilterButton;

@property (nonatomic, strong)   EmployerRecord *currentEmployer;

@property (strong, nonatomic) JSPickerView * jobPicker;
@property (strong, nonatomic) JSPickerView * businessPicker;
@property (strong, nonatomic) JSPickerView * recentPicker;
@property (nonatomic, strong)  NSArray *businessArray;
@property (nonatomic, strong)  NSArray *jobTypeArray;
@property (nonatomic, strong)  NSArray *recentArray;
@property (nonatomic)       CGFloat screenWidth;
@property (nonatomic)       CGFloat screenHeight;
@property (strong, nonatomic) JSDatePicker *datePicker;

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
    self.currentEmployer = [[EmployerRecord alloc] init];
    self.currentEmployer.name = @"Mc_HRManager";
    self.currentEmployer.imageName = @"small_add_photo.png";
    
    [self setupBusinesses];
}

-(void) setupBusinesses {
    NSMutableArray *businesses = [[NSMutableArray alloc] init];
    
    BusinessRecord *currBusiness = nil;
    currBusiness = [[BusinessRecord alloc] init];
    currBusiness.name = @"McDonald's 1";
    currBusiness.address = @"1692 Rue Mont Royal, Montreal QC H2J 1Z5";
    currBusiness.imageName = @"mcdonalds.png";
    [self setupPostingsFor:currBusiness];
    [businesses addObject:currBusiness];
    
    currBusiness = nil;
    currBusiness = [[BusinessRecord alloc] init];
    currBusiness.name = @"McDonald's 2";
    currBusiness.address = @"2530 Rue Masson, Montreal QC H1Y 1V8";
    currBusiness.imageName = @"mcdonalds.png";
    [self setupPostingsFor:currBusiness];
    [businesses addObject:currBusiness];
    
    self.currentEmployer.businesses = businesses;
}

-(void) setupPostingsFor:(BusinessRecord *)currBusiness {
    if ([currBusiness.name isEqualToString:@"McDonald's 1"]) {
        NSMutableArray *postings = [[NSMutableArray alloc] init];
        
        PostingRecord *currPosting = nil;
        currPosting = [[PostingRecord alloc] init];
        currPosting.title = @"CS Rep";
        currPosting.descrption = @"Take orders, .....";
        currPosting.noApplications = 23;
        currPosting.noShortlisted = 5;
        currPosting.morningShift = TRUE;
        currPosting.nightShift = TRUE;
        [postings addObject:currPosting];
        
        currPosting = nil;
        currPosting = [[PostingRecord alloc] init];
        currPosting.title = @"Manager";
        currPosting.descrption = @"Payroll, Training .....";
        currPosting.noApplications = 0;
        currPosting.noShortlisted = 0;
        currPosting.eveningShift = TRUE;
        currPosting.nightShift = TRUE;
        [postings addObject:currPosting];
        
        currBusiness.postings = postings;
    }
    if ([currBusiness.name isEqualToString:@"McDonald's 2"]) {
        NSMutableArray *postings = [[NSMutableArray alloc] init];
        
        PostingRecord *currPosting = nil;
        currPosting = [[PostingRecord alloc] init];
        currPosting.title = @"Asst. Manager";
        currPosting.descrption = @"Scheduling, .....";
        currPosting.noApplications = 4;
        currPosting.noShortlisted = 0;
        currPosting.afternoonShift = TRUE;
        [postings addObject:currPosting];
        
        currBusiness.postings = postings;
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
    
    self.businessArray = [self.currentEmployer.businesses valueForKey:@"name"];
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

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
