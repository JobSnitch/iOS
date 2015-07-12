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
#import "PostingExpandedView.h"


@interface EmployerFirstViewController ()

@property (weak, nonatomic)     UIScrollView *oScrollView;
@property (nonatomic, strong)   EmployerRecord *currentEmployer;
@property (nonatomic, strong)  NSMutableArray *subviews;
@property (nonatomic) CGFloat   scrollViewHeight;
@property (nonatomic) CGFloat   rowHeight;
@property (nonatomic, strong)   EmployerFirstView *mainView;

@end

@implementation EmployerFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowHeight = self.view.bounds.size.width * 78.0 / 414.0;
    [self.view removeConstraints:self.view.constraints];
    [self setupEmployer];
    
    [self setupView];
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
//        if ([aView isMemberOfClass:[PostingExpandedView class]]) {
//            [((PostingExpandedView *)aView) layoutFields:CGSizeMake(self.view.bounds.size.width, 408.0)];
//            aView.backgroundColor = [UIColor blueColor];
//            [aView setFrame:CGRectMake(0, aView.frame.origin.y, self.view.bounds.size.width, 408.0)];
//        }
    }
    
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
    [self setupMainView];
}

-(void) setupHeader {
    self.mainView.oTopImage.image = [UIImage imageNamed:self.currentEmployer.imageName];
    self.mainView.oNameLabel.text = self.currentEmployer.name;
}

-(void) setupMainView {
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
    [currView postData];
    [self.oScrollView addSubview:currView];
    [self.subviews addObject:currView];
}

-(void) setupNewPostingFor:(BusinessRecord *)currBusiness {
    CGFloat buttonWidth = self.rowHeight *82.0/78.0;
    CGRect topFrame = CGRectMake(self.view.bounds.size.width- buttonWidth, self.scrollViewHeight,
                                 buttonWidth, self.rowHeight);
    UIButton *newPosting = [UIButton buttonWithType: UIButtonTypeCustom];
    [newPosting setFrame: topFrame];
    [newPosting setImage:[UIImage imageNamed:@"new_posting.png"] forState:UIControlStateNormal];
    [newPosting addTarget:self action:@selector(doNewPosting:)forControlEvents:UIControlEventTouchDown];
    [self.oScrollView addSubview:newPosting];
    [self.subviews addObject:newPosting];
}

-(void) doNewPosting:(id) sender {
    CGFloat startY = ((UIView *)sender).frame.origin.y;
    [self setupAddPostingView: startY];
    [self lowerBelowViews: startY];
    [self.oScrollView setContentSize:CGSizeMake(self.oScrollView.bounds.size.width, self.oScrollView.bounds.size.height + 408.0)];
}

-(void) setupAddPostingView:(CGFloat)startY  {
    CGRect topFrame = CGRectMake(0, startY,
                                 self.view.bounds.size.width, 408.0);
    PostingExpandedView *currView = nil;
    currView = [[PostingExpandedView alloc] initWithFrame:topFrame];
    [self.oScrollView addSubview:currView];
    [self.subviews addObject:currView];
}

-(void) lowerBelowViews:(CGFloat)startY  {
    CGAffineTransform descend = CGAffineTransformMakeTranslation(0.0, 408.0 - self.rowHeight );
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
