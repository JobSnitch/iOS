//
//  EmployerFirstViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployerFirstViewController.h"
#import "EmployerRecord.h"
#import "BusinessRecord.h"
#import "BusinessRestrictedView.h"
#import "PostingRecord.h"
#import "PostingRestrictedView.h"
#import "EmployerFirstView.h"
#import "PostingAddView.h"
#import "PostingEditView.h"
#import "PostingExpandedView.h"
#import "JSAddPostingButton.h"
#import "ApplicationsViewController.h"
#import "JSSessionManager.h"
#import "CompanyRecord.h"

@interface EmployerFirstViewController () <UITextFieldDelegate, UITextViewDelegate, EmployerFirstParent,
                                                EmployerContainerDelegate>

@property (weak, nonatomic)     UIScrollView *oScrollView;
@property (nonatomic, strong)   NSMutableArray *subviews;
@property (nonatomic) CGFloat   scrollViewHeight;
@property (nonatomic) CGFloat   rowHeight;
@property (nonatomic, strong)   EmployerFirstView *mainView;
@property (nonatomic, strong)   PostingExpandedView *postingView;
@property (weak, nonatomic)     PostingRestrictedView *suprview;
@property (nonatomic, strong)   ApplicationsViewController *applController;
@property (nonatomic, strong)   PostingRecord *toPostPosting;
@property (nonatomic, strong)   NSMutableArray *postings;

@end

@implementation EmployerFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowHeight = self.view.bounds.size.width * 78.0 / 414.0;
    [self.view removeConstraints:self.view.constraints];
    [self setupEmployer];
    
    [self setupView];
    [super setupJobtypePicker];
    [super setupIndustryPicker];
}

-(void) viewDidLayoutSubviews {
    [self.mainView layoutFields:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.mainView setFrame:self.view.frame];
    for (UIView * aView in self.subviews) {
        if ([aView isMemberOfClass:[BusinessRestrictedView class]]) {
            [((BusinessRestrictedView *)aView) layoutFields:CGSizeMake(self.view.bounds.size.width, 48.0)];
            [aView setFrame:CGRectMake(0, aView.frame.origin.y, self.oScrollView.bounds.size.width, 48.0)];
        }
    }
    [super bringPickersToFront];
    
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
    
}

-(void) setupDataAndViews: (NSArray *) postings {
    self.postings = [postings mutableCopy];
    [self setupBusinesses];
}

-(void) setupBusinesses {
    if (self.postings && self.postings.count) {
        [self getCompanyInfo];
    }
    
}

#pragma mark - applications
-(void) setupApplicationsForJobs {
    for (PostingRecord *currPosting in self.postings) {
        NSString *postId = [[NSNumber numberWithInteger:currPosting.JobPostingId] stringValue];
        [self getApplicationsForPosting:postId];
        usleep(100000);
    }
}

-(void) getApplicationsForPosting:(NSString *) postId {
    if (!postId || [postId isEqualToString:@""]) {
        return;
    }
    
    [[JSSessionManager sharedManager] getApplicationsForJob:postId withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                NSArray *applications = [[JSSessionManager sharedManager] processApplicationsResults:results];
                [self setApplications:applications forPost:postId];
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"GetApplicationsForJob"];
        }
    }];
}

-(void) setApplications:(NSArray *)applications forPost:(NSString *) postId {
    if (applications) {
        for (PostingRecord *currPosting in self.postings) {
            NSString *postingid = [[NSNumber numberWithInteger:currPosting.JobPostingId] stringValue];
            if (postingid && [postingid isEqualToString:postId]) {
                currPosting.applications = [NSArray arrayWithArray:applications];
                currPosting.noApplications = (int)applications.count;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ApplicationStatus IN %@", @[@"Approved"]];
                NSArray *filteredArray = [currPosting.applications filteredArrayUsingPredicate:predicate];
                if (filteredArray) {
                    currPosting.noShortlisted = (int)filteredArray.count;
                }
                if ((currPosting.corespView != nil) && ([currPosting.corespView respondsToSelector:@selector(postData:)])) {
                    [currPosting.corespView postData:currPosting];
                    [currPosting.corespView setNeedsDisplay];
                }
            }
        }
    }
}


#pragma mark - interface
-(void) setupView {
    self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"EmployerFirstView" owner:self options:nil] objectAtIndex:0];
    [self.mainView setFrame:self.view.frame];
    [self.view addSubview:self.mainView];
    
    [self setupHeader];
}

-(void) setupHeader {
    self.mainView.oTopImage.image = [UIImage imageNamed:self.currentEmployer.imageName];
    self.mainView.oNameLabel.text = self.currentEmployer.name;
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.mainView.oTopImage.image = avatarImage;
    }
}

-(void) setupScrollView {
    self.subviews = [[NSMutableArray alloc] init];
    self.oScrollView = self.mainView.oScrollView;
    [self.mainView bringSubviewToFront:self.mainView.oScrollView];
    self.scrollViewHeight = 0;
    for (CompanyRecord *currBusiness in self.currentEmployer.businesses) {
        [self setupBusinessViewFor:currBusiness];
        self.scrollViewHeight += 48.0;
        [self setupPostingViewsFor:currBusiness];
        [self setupNewPostingFor:currBusiness];
        self.scrollViewHeight += self.rowHeight+ 4.0;
    }
    [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight)];
}

-(void) refreshView {
    if (self.mainView) {
        [self.mainView removeFromSuperview];
        self.mainView = nil;
    }
    [self setupView];
    [self setupScrollView];
}

-(void) setupBusinessViewFor:(CompanyRecord *)currBusiness {
     CGRect topFrame = CGRectMake(0, self.scrollViewHeight,
                                 self.oScrollView.bounds.size.width, 48.0);
    BusinessRestrictedView *currView = nil;
    currView = [[[NSBundle mainBundle] loadNibNamed:@"BusinessRestrictedView" owner:self options:nil] objectAtIndex:0];
    [currView setFrame:topFrame];
    currView.oNameLabel.text = currBusiness.NameEnglish;
//    currView.oAddressLabel.text = currBusiness.address;
    currView.oAddressLabel.text = [NSString stringWithFormat:@"%@ %@", currBusiness.City, currBusiness.Province];
    currView.oBusinessImage.image = [UIImage imageNamed:currBusiness.imageName];
    [self.oScrollView addSubview:currView];
    [self.subviews addObject:currView];
}

-(void) setupPostingViewsFor:(CompanyRecord *)currBusiness {
    for (PostingRecord *currPosting in currBusiness.postings) {
        [self setupPostingViewFor:currPosting];
        self.scrollViewHeight += self.rowHeight+ 4.0;
    }
}

-(void) setupPostingViewFor:(PostingRecord *) currPosting {
    
    CGRect topFrame = CGRectMake(0, self.scrollViewHeight,
                                 self.view.bounds.size.width, self.rowHeight);
    PostingRestrictedView *currView = [[PostingRestrictedView alloc] initWithFrame:topFrame];
    [currView postData:currPosting];
    currPosting.corespView = currView;
    currView.parent = self;
    [self.oScrollView addSubview:currView];
    [self.subviews addObject:currView];

}

-(void) setupNewPostingFor:(CompanyRecord *)currBusiness {
    CGFloat buttonWidth = self.rowHeight *82.0/78.0;
    CGRect topFrame = CGRectMake(self.view.bounds.size.width- buttonWidth, self.scrollViewHeight,
                                 buttonWidth, self.rowHeight);
    JSAddPostingButton *newPosting = [JSAddPostingButton buttonWithType: UIButtonTypeCustom];
    [newPosting setFrame: topFrame];
    [newPosting setImage:[UIImage imageNamed:@"new_posting.png"] forState:UIControlStateNormal];
    [newPosting addTarget:self action:@selector(doNewPosting:)forControlEvents:UIControlEventTouchDown];
    newPosting.currBusiness = currBusiness;
    [self.oScrollView addSubview:newPosting];
    [self.subviews addObject:newPosting];
}

#pragma mark - add posting
-(void) doNewPosting:(id) sender {
    if (self.postingView) {
        return;
    }
    CGFloat height = 408.0;
    CGFloat startY = ((UIView *)sender).frame.origin.y;
    [self setupAddPostingView: startY forBusiness: ((JSAddPostingButton *) sender).currBusiness];
    [self lowerBelowViews:startY viewHeight:height];
    [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight + height - self.rowHeight)];
}

-(void) setupAddPostingView:(CGFloat)startY forBusiness:(CompanyRecord *) currBusiness {
    CGFloat height = 408.0;
    CGRect topFrame = CGRectMake(0, startY,
                                 self.view.bounds.size.width, height);
    self.postingView = [[PostingAddView alloc] initWithFrame:topFrame];
    [self.oScrollView addSubview:self.postingView];
    [self.subviews addObject:self.postingView];
    self.postingView.parent = self;
    self.postingView.oJTitleText.delegate = self;
    self.postingView.oDescriptionText.delegate = self;
    ((PostingAddView *)self.postingView).currBusiness = currBusiness;
}

-(void) lowerBelowViews:(CGFloat)startY viewHeight:(CGFloat) height {
    CGAffineTransform descend = CGAffineTransformMakeTranslation(0.0, height - self.rowHeight );
    for (UIView * aView in self.subviews) {
        if (aView.frame.origin.y > startY + 0.1) {
            AnimationBlock descendUpper = ^(void){
                [aView setTransform:descend];
            };
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                             animations:descendUpper completion:nil];
        }
    }
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger thisTag = textField.tag;
    if (thisTag == 300) {
        [self.oScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y+textField.superview.frame.origin.y) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    NSInteger thisTag = textField.tag;
    UIResponder* nextResponder = [self.oScrollView viewWithTag:nextTag];
    if (nextResponder) {
        if ((thisTag == 300) && ![textField.text isEqualToString:@""]) {
            [self.postingView.oBinButton setImage:[UIImage imageNamed:@"full_bin"] forState:UIControlStateNormal];
        }
        [nextResponder becomeFirstResponder];
        [self.oScrollView setContentOffset:CGPointMake(0, textField.frame.origin.y+textField.superview.frame.origin.y + 50.0) animated:YES];
    } else {
        [textField resignFirstResponder];
        [self.oScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - UITextViewDelegate
-(BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    [self.oScrollView setContentOffset:CGPointMake(0, textView.frame.origin.y+ textView.superview.frame.origin.y) animated:YES];
    return YES;
}

-(BOOL)textViewShouldReturn:(UITextView *) textView;
{
    [textView resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - EmployerFirstParent

-(void) delegateHasCanceled:(id)sender {
    if ([self.postingView isKindOfClass:[PostingEditView class]]) {
        [self deleteExistingPosting];
        [self removePostingView];
//        [self findAndDelete:((PostingEditView *)self.postingView).currPosting];
//        [self refreshView];
    } else {
        CGFloat startY = self.postingView.frame.origin.y;
        [self removePostingView];
        [self raiseBelowViews:startY];
        [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight)];
    }
}

-(void) delegateHasSaved:(id)sender {
    if ([self.postingView isKindOfClass:[PostingEditView class]]) {
        [self findandReplace:((PostingEditView *)self.postingView).currPosting];
        [self.suprview postData:((PostingEditView *)self.postingView).currPosting];
        CGFloat startY = self.postingView.frame.origin.y;
        [self removePostingView];
        [self raiseBelowViews:startY];
        [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight)];
    } else {
        [self postPosting];
        [self removePostingView];
        self.subviews = nil;
        self.mainView = nil;
    }
}

-(void) postPosting {
    self.toPostPosting = nil;
    self.toPostPosting = [[PostingRecord alloc] init];
    [self setupFromFields:self.toPostPosting];
    [self doPostNewPosting];
}

-(void) savePosting{
    BusinessRecord * currBusiness = self.toPostPosting.ownerBusiness;
    NSMutableArray *postings = [currBusiness.postings  mutableCopy];
    currBusiness.postings = nil;
    [postings addObject:self.toPostPosting];
    currBusiness.postings = postings;
}

-(void) findAndDelete:(PostingRecord *) currPosting {
    for (BusinessRecord *currBusiness in self.currentEmployer.businesses) {
        for (PostingRecord *aPosting in currBusiness.postings) {
            if (aPosting == currPosting) {
                NSMutableArray *postings = [currBusiness.postings mutableCopy];
                [postings removeObject:aPosting];
                currBusiness.postings = nil;
                currBusiness.postings = postings;
                break;
            }
        }
    }
}

-(void) findandReplace:(PostingRecord *) currPosting {
    for (BusinessRecord *currBusiness in self.currentEmployer.businesses) {
        for (PostingRecord *aPosting in currBusiness.postings) {
            if (aPosting == currPosting) {
                [self changeFromFields:currPosting];
                break;
            }
        }
    }
}

-(void) changeFromFields:(PostingRecord *) currPosting {
    currPosting.title = self.postingView.oJTitleText.text;
    currPosting.descrption = self.postingView.oDescriptionText.text;
    currPosting.morningShift = self.postingView.oMorningSwitch.on;
    currPosting.afternoonShift = self.postingView.oAfternoonSwitch.on;
    currPosting.eveningShift = self.postingView.oEveningSwitch.on;
    currPosting.nightShift = self.postingView.oNightSwitch.on;
    currPosting.JobCategoryName = self.postingView.oJTypeLabel.text;
    currPosting.industry = self.postingView.oIndustryLabel.text;
}

-(void) setupFromFields:(PostingRecord *) currPosting {
    [self changeFromFields:currPosting];
    currPosting.ownerBusiness = ((PostingAddView *)self.postingView).currBusiness;
}

-(void) removePostingView {
    if (self.postingView) {
        [self.postingView removeFromSuperview];
        self.postingView = nil;
    }
}

-(void) raiseBelowViews:(CGFloat)startY  {
    CGAffineTransform climb = CGAffineTransformIdentity;
    for (UIView * aView in self.subviews) {
        if (aView.frame.origin.y > startY + 0.1) {
            AnimationBlock descendUpper = ^(void){
                [aView setTransform:climb];
            };
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                             animations:descendUpper completion:nil];
        }
    }
}

#pragma mark - overwrite
-(void) refreshScreen {
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    if (super.pickerSelectionJT) {
        if (self.postingView) {
            NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:super.pickerSelectionJT attributes:text1Attribute];
            [self.postingView.oJTypeLabel setAttributedText:attributedText];
        }
    }
    if (super.pickerSelectionI) {
        if (self.postingView) {
            NSAttributedString* attributedText = [[NSAttributedString alloc] initWithString:super.pickerSelectionI attributes:text1Attribute];
            [self.postingView.oIndustryLabel setAttributedText:attributedText];
        }
    }
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - edit posting
-(void) delegateExpandPosting:(id)sender {
    if (self.postingView) {
        return;
    }
    CGFloat height = 467.0;
    self.suprview = (PostingRestrictedView *)(((UIView *)sender).superview);
    CGFloat startY = self.suprview.frame.origin.y ;
    [self setupEditPostingView: startY forPosting: ((JSEditPostingButton *) sender).currPosting];
    [self.oScrollView bringSubviewToFront:self.suprview];
    [self.suprview.oExpandButton setImage:[UIImage imageNamed:@"compress_arrow_white"] forState:UIControlStateNormal];
    [self lowerBelowViews:startY viewHeight:height];
    [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight + height - self.rowHeight)];
}

-(void) setupEditPostingView:(CGFloat)startY forPosting:(PostingRecord *) currPosting {
    CGRect topFrame = CGRectMake(0, startY,
                                 self.view.bounds.size.width, 467.0);
    self.postingView = [[PostingEditView alloc] initWithFrame:topFrame];
    [self.oScrollView addSubview:self.postingView];
    [self.subviews addObject:self.postingView];
    self.postingView.parent = self;
    self.postingView.oJTitleText.delegate = self;
    self.postingView.oDescriptionText.delegate = self;
    ((PostingEditView *)self.postingView).currPosting = currPosting;
    [((PostingEditView *)self.postingView) fillFields];
}

#pragma mark - pickers
- (void)delegateAddJobType:(id)sender {
    [super showJobtypePicker];
}

- (void)delegateAddIndustry:(id)sender {
    [super showIndustryPicker];
}

- (void)delegateBroadcast:(id)sender {
    // ?
}

#pragma mark - show applications
-(void) delegateApplications:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.applController = (ApplicationsViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ApplicationsViewController"];
    [self addChildViewController:self.applController];
    [self.applController didMoveToParentViewController:self];
    self.applController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -49);
    [self prepareChildWithSender:sender];
    [self.view addSubview:self.applController.view];
    [self.applController prepareData];
    [self.applController setupFields];
    
    self.applController.delegate = self;
}

-(void) hasFinishedApplications {
    [self.applController willMoveToParentViewController:nil];
    [self.applController.view removeFromSuperview];
    [self.applController removeFromParentViewController];
    self.applController  =nil;
}


-(void)prepareChildWithSender:(id)sender{
    self.suprview = (PostingRestrictedView *)(((UIView *)sender).superview);
    PostingRecord * currPosting = ((JSEditPostingButton *) sender).currPosting;
    CompanyRecord *currBusiness = nil;
    for (CompanyRecord *aBusiness in self.currentEmployer.businesses) {
        for (PostingRecord *aPosting in aBusiness.postings) {
            if (aPosting == currPosting) {
                currBusiness = aBusiness;
                break;
            }
        }
    }
    if (currBusiness && currPosting) {
        self.applController.currEmployer = self.currentEmployer;
        self.applController.currBusiness = currBusiness;
        self.applController.currPosting = currPosting;
    }
}

#pragma mark - new posting
-(void) doPostNewPosting {
    NSDictionary *paramValue = [self formPostingParam];
    [self uploadNewPosting:paramValue];
}

//-(NSString *) formPostingParam {
//    NSString *paramValue = nil;
//    NSString *jobCateg = @"";
//    if (self.toPostPosting.JobCategoryName && ![self.toPostPosting.JobCategoryName isEqualToString:@""]) {
//        NSPredicate * predicate = [NSPredicate predicateWithFormat:@" EnglishName MATCHES %@", self.toPostPosting.JobCategoryName];
//        NSArray * matches = [self.jobCategories filteredArrayUsingPredicate:predicate];
//        NSInteger catId = [[((NSDictionary *) matches[0]) valueForKey:@"JobCategoryId"] integerValue];
//        jobCateg = [NSString stringWithFormat:@"JobCategory:{JobCategoryId:%ld,EnglishName:\"%@\"},",
//                    (long)catId, self.toPostPosting.JobCategoryName];
//    }
//    NSString *jobLoc = @"";
//    if (self.toPostPosting.ownerBusiness ) {
//        BusinessRecord *currB = self.toPostPosting.ownerBusiness;
//        if (currB.address) {
//            jobLoc = currB.address;
//        }
//    }
//    NSString *morning = (self.toPostPosting.morningShift ? @"true" : @"false");
//    NSString *aftrnoon = (self.toPostPosting.afternoonShift ? @"true" : @"false");
//    NSString *evening = (self.toPostPosting.eveningShift ? @"true" : @"false");
//    
//    paramValue = [NSString stringWithFormat:@"{JobPostingId:%d,%@TitleEnglish:\"%@\","
//                  "DescriptionEnglish:\"%@\",CompanyId:%@,JobLocation: \"%@\","
//                  "Active:true,AvailabilitySchedule{SundayAM:%@,SundayPM:%@,SundayEvening:%@,MondayAM:%@,MondayPM:%@,MondayEvening:%@,"
//                  "TuesdayAM:%@,TuesdayPM:%@,TuesdayEvening:%@,WednesdayAM:%@,WednesdayPM:%@,WednesdayEvening:%@,ThursdayAM:%@,"
//                  "ThursdayPM:%@,ThursdayEvening:%@,FridayAM:%@,FridayPM:%@,FridayEvening:%@,SaturdayAM:%@,SaturdayPM:%@,SaturdayEvening:%@}}",
//                  0, jobCateg, self.toPostPosting.title, self.toPostPosting.descrption, testUserID2, jobLoc,
//                  morning, aftrnoon, evening,
//                  morning, aftrnoon, evening,
//                  morning, aftrnoon, evening,
//                  morning, aftrnoon, evening,
//                  morning, aftrnoon, evening,
//                  morning, aftrnoon, evening,
//                  morning, aftrnoon, evening
//                  ];
//    return paramValue;
//}

-(NSDictionary *) formPostingParam {
    NSDictionary *params = nil;
    NSString *jobCateg = @"";
    NSInteger catId = 0;
    if (self.toPostPosting.JobCategoryName && ![self.toPostPosting.JobCategoryName isEqualToString:@""]) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@" EnglishName MATCHES %@", self.toPostPosting.JobCategoryName];
        NSArray * matches = [self.jobCategories filteredArrayUsingPredicate:predicate];
        catId = [[((NSDictionary *) matches[0]) valueForKey:@"JobCategoryId"] integerValue];
        jobCateg = [NSString stringWithFormat:@"JobCategory:{JobCategoryId:%ld,EnglishName:\"%@\"},",
                    (long)catId, self.toPostPosting.JobCategoryName];
    }
    NSString *jobLoc = @"";
    if (self.toPostPosting.ownerBusiness ) {
        CompanyRecord *currB = self.toPostPosting.ownerBusiness;
        if (currB.City || currB.Province) {
            jobLoc = [NSString stringWithFormat:@"%@ %@", currB.City, currB.Province];
        }
    }
//    NSString *morning = (self.toPostPosting.morningShift ? @"true" : @"false");
//    NSString *aftrnoon = (self.toPostPosting.afternoonShift ? @"true" : @"false");
//    NSString *evening = (self.toPostPosting.eveningShift ? @"true" : @"false");
    NSDictionary * catgDict = nil;
    if (catId) {
        catgDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:catId], @"JobCategoryId", nil];
    }
    NSMutableDictionary *newPost = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.toPostPosting.title, @"TitleEnglish",
                             self.toPostPosting.descrption, @"DescriptionEnglish",
                             nil];
    if (jobLoc) {
        [newPost setObject:jobLoc forKey:@"JobLocation"];
    }
    [newPost setObject:[NSNumber numberWithInteger:self.currentCompany.CompanyId] forKey:@"CompanyId"];
    if (catgDict) {
        [newPost setObject:catgDict forKey:@"JobCategory"];
    }

    params = [NSDictionary dictionaryWithObjectsAndKeys: newPost, @"jobPosting", nil];

    return params;
}

-(void) uploadNewPosting:(NSDictionary *) paramValue {
    [[JSSessionManager sharedManager] postNewPostingWithParam:paramValue withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                BOOL success = [[JSSessionManager sharedManager] processNewPostingResults:results];
                if (success) {
                    [self savePosting];
                }
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"NewJobPosting"];
        }
        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:NO];
    }];
}

#pragma mark - delete posting
-(void) deleteExistingPosting {
    PostingRecord *todeletePost = ((PostingEditView *)self.postingView).currPosting;
    if (todeletePost) {
        [self deletePosting:todeletePost];
    }
}

-(void) deletePosting:(PostingRecord *) todeletePost {
    NSInteger pid = todeletePost.JobPostingId;
    NSString *postId = [[NSNumber numberWithInteger:pid] stringValue];
    if (!postId || [postId isEqualToString:@""]) {
        return;
    }
    [[JSSessionManager sharedManager] deletePostingWithId:postId withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                BOOL success = [[JSSessionManager sharedManager] processDeletePosting:results];
                if (success) {
                    [self findAndDelete:todeletePost];
                }
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"DeleteJobPosting"];
        }
        [self performSelectorOnMainThread:@selector(refreshView) withObject:nil waitUntilDone:NO];
    }];
}


#pragma mark - get companies info
-(void) getCompanyInfo {
    self.currentEmployer.businesses = nil;
    self.currentEmployer.businesses = [[NSMutableArray alloc] init];
    NSSet *companyIDs = [NSSet setWithArray:[self.postings valueForKey:@"CompanyId"]];
    for (NSNumber * cid in companyIDs) {
        [self getCompanyProfile:[cid stringValue]];
        break;                  // only one
    }
}

- (void) getCompanyProfile:(NSString *) compId {
    if (!compId || [compId isEqualToString:@""]) {
        return;
    }
    
    [[JSSessionManager sharedManager] getCompanyForId: compId withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                CompanyRecord *currentCompany = [[JSSessionManager sharedManager] processCompanyIdResults:results];
                [self setupCompany:currentCompany];
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"GetCompanyProfile"];
        }
    }];
}

-(void) setupCompany: (CompanyRecord *) currentCompany{
    if (currentCompany) {
        currentCompany.imageName = @"mcdonalds.png";
        [self.currentEmployer.businesses addObject:currentCompany];
        currentCompany.postings = self.postings;
    }
    [self setupApplicationsForJobs];
    [self setupScrollView];     // only one
}

#pragma mark - UserInfo callback
-(void) setupFromUserInfo:(UserRecord *)currUser {
    if (currUser.FirstName) {                      // my interpretation
        self.currentEmployer.name = currUser.FirstName;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).currUserNick = currUser.FirstName;
        self.mainView.oNameLabel.text = self.currentEmployer.name;
    }
    
    [self.view setNeedsDisplay];
}

#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
