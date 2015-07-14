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

@interface EmployerFirstViewController () <UITextFieldDelegate, UITextViewDelegate, EmployerFirstParent,
                                                EmployerContainerDelegate>

@property (weak, nonatomic)     UIScrollView *oScrollView;
@property (nonatomic, strong)   EmployerRecord *currentEmployer;
@property (nonatomic, strong)   NSMutableArray *subviews;
@property (nonatomic) CGFloat   scrollViewHeight;
@property (nonatomic) CGFloat   rowHeight;
@property (nonatomic, strong)   EmployerFirstView *mainView;
@property (nonatomic, strong)   PostingExpandedView *postingView;
@property (weak, nonatomic)     PostingRestrictedView *suprview;
@property (nonatomic, strong)   ApplicationsViewController *applController;

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
        if ([aView isMemberOfClass:[PostingRestrictedView class]]) {
            [((PostingRestrictedView *)aView) layoutFields:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * 78.0 / 414.0)];
            [aView setFrame:CGRectMake(0, aView.frame.origin.y, self.view.bounds.size.width, self.rowHeight)];
        }
    }
    [super bringPickersToFront];
    
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

#pragma mark - interface
-(void) setupView {
    self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"EmployerFirstView" owner:self options:nil] objectAtIndex:0];
    [self.mainView setFrame:self.view.frame];
    [self.view addSubview:self.mainView];
    
    [self setupHeader];
    [self setupScrollView];
}

-(void) setupHeader {
    self.mainView.oTopImage.image = [UIImage imageNamed:self.currentEmployer.imageName];
    self.mainView.oNameLabel.text = self.currentEmployer.name;
}

-(void) setupScrollView {
    self.subviews = [[NSMutableArray alloc] init];
    self.oScrollView = self.mainView.oScrollView;
    [self.mainView bringSubviewToFront:self.mainView.oScrollView];
    self.scrollViewHeight = 0;
    for (BusinessRecord *currBusiness in self.currentEmployer.businesses) {
        [self setupBusinessViewFor:currBusiness];
        self.scrollViewHeight += 48.0;
        [self setupPostingViewsFor:currBusiness];
        [self setupNewPostingFor:currBusiness];
        self.scrollViewHeight += self.rowHeight+ 4.0;
    }
    [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight)];
}

-(void) setupBusinessViewFor:(BusinessRecord *)currBusiness {
     CGRect topFrame = CGRectMake(0, self.scrollViewHeight,
                                 self.oScrollView.bounds.size.width, 48.0);
    BusinessRestrictedView *currView = nil;
    currView = [[[NSBundle mainBundle] loadNibNamed:@"BusinessRestrictedView" owner:self options:nil] objectAtIndex:0];
    [currView setFrame:topFrame];
    currView.oNameLabel.text = currBusiness.name;
    currView.oAddressLabel.text = currBusiness.address;
    currView.oBusinessImage.image = [UIImage imageNamed:currBusiness.imageName];
    [self.oScrollView addSubview:currView];
    [self.subviews addObject:currView];
}

-(void) setupPostingViewsFor:(BusinessRecord *)currBusiness {
    for (PostingRecord *currPosting in currBusiness.postings) {
        [self setupPostingViewFor:currPosting];
        self.scrollViewHeight += self.rowHeight+ 4.0;
    }
}

-(void) setupPostingViewFor:(PostingRecord *) currPosting {
    CGRect topFrame = CGRectMake(0, self.scrollViewHeight,
                                 self.view.bounds.size.width, self.rowHeight);
    PostingRestrictedView *currView = nil;
    currView = [[[NSBundle mainBundle] loadNibNamed:@"PostingRestrictedView" owner:self options:nil] objectAtIndex:0];
    [currView setFrame:topFrame];
    currView.oTitleLabel.text = currPosting.title;
    currView.oDescrLabel.text = currPosting.descrption;
    currView.oShortLabel.text = [NSString stringWithFormat:@"%d", currPosting.noShortlisted];
    currView.oApplicLabel.text = [NSString stringWithFormat:@"%d", currPosting.noApplications];
    currView.oExpandButton.currPosting = currPosting;
    currView.oCurvedButton.currPosting = currPosting;
    [currView postData];
    currView.parent = self;
    [self.oScrollView addSubview:currView];
    [self.subviews addObject:currView];
}

-(void) setupNewPostingFor:(BusinessRecord *)currBusiness {
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

-(void) setupAddPostingView:(CGFloat)startY forBusiness:(BusinessRecord *) currBusiness {
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
        [self findAndDelete:((PostingEditView *)self.postingView).currPosting];
        [self removePostingView];
        self.subviews = nil;
        self.mainView = nil;
        [self setupView];
    } else {
        CGFloat startY = self.postingView.frame.origin.y;
        [self removePostingView];
        [self raiseBelowViews:startY];
        [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight)];
    }
}

-(void) delegateHasSaved:(id)sender {
    if ([self.postingView isKindOfClass:[PostingEditView class]]) {
        [self.suprview.oExpandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
        [self findandReplace:((PostingEditView *)self.postingView).currPosting];
        self.suprview.oTitleLabel.text = self.postingView.oJTitleText.text;
        self.suprview.oDescrLabel.text = self.postingView.oDescriptionText.text;
        CGFloat startY = self.postingView.frame.origin.y;
        [self removePostingView];
        [self raiseBelowViews:startY];
        [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.scrollViewHeight)];
    } else {
        [self savePosting];
        [self removePostingView];
        self.subviews = nil;
        self.mainView = nil;
        [self setupView];
    }
}

-(void) savePosting{
    BusinessRecord * currBusiness = ((PostingAddView *)self.postingView).currBusiness;
    NSMutableArray *postings = [currBusiness.postings  mutableCopy];
    currBusiness.postings = nil;
    PostingRecord *currPosting = nil;
    currPosting = [[PostingRecord alloc] init];
    [self setupFromFields:currPosting];
    [postings addObject:currPosting];
    
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
                [self setupFromFields:currPosting];
                break;
            }
        }
    }
}

-(void) setupFromFields:(PostingRecord *) currPosting {
    currPosting.title = self.postingView.oJTitleText.text;
    currPosting.descrption = self.postingView.oDescriptionText.text;
    currPosting.noApplications = 0;
    currPosting.noShortlisted = 0;
    currPosting.morningShift = self.postingView.oMorningSwitch.on;
    currPosting.afternoonShift = self.postingView.oAfternoonSwitch.on;
    currPosting.eveningShift = self.postingView.oEveningSwitch.on;
    currPosting.nightShift = self.postingView.oNightSwitch.on;
    currPosting.type = self.postingView.oJTypeLabel.text;
    currPosting.industry = self.postingView.oIndustryLabel.text;
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
    BusinessRecord *currBusiness = nil;
    for (BusinessRecord *aBusiness in self.currentEmployer.businesses) {
        for (PostingRecord *aPosting in aBusiness.postings) {
            if (aPosting == currPosting) {
                currBusiness = aBusiness;
                break;
            }
        }
    }
    if (currBusiness && currPosting) {
        self.applController.currentEmployer = self.currentEmployer;
        self.applController.currBusiness = currBusiness;
        self.applController.currPosting = currPosting;
    }
}

#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
