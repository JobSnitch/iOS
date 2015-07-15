//
//  EmployeeInfoViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeInfoViewController.h"
#import "HomeCenterView.h"

@interface EmployeeInfoViewController () <HomeDelegate>
@property (strong, nonatomic)   HomeCenterView *centerView;

@end

@implementation EmployeeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerView = nil;
}

-(void) viewWillAppear:(BOOL)animated {
    [self showCenterView];
}

-(void) viewDidDisappear:(BOOL)animated {
    if (self.centerView) {
        [self.centerView removeFromSuperview];
        self.centerView = nil;
    }
}

#pragma mark - show center view
-(void) handleLogoTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded){
        [self showCenterView];
    }
}

-(void) showCenterView {
    self.centerView = [[[NSBundle mainBundle] loadNibNamed:@"HomeCenterView" owner:self options:nil] objectAtIndex:0];
    self.centerView.delegate = self;
    [self finalPositionCenterView];
    [self.view addSubview:self.centerView];
    [self initialPositionCenterView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(animateCenterView) userInfo:nil repeats:NO];
}

-(void) animateCenterView {
    CGAffineTransform climb;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        climb = CGAffineTransformMakeTranslation(0.0, -109.0 * [UIScreen mainScreen].scale);
    } else {
        climb = CGAffineTransformMakeTranslation(0.0, -109.0);
    }
    
    AnimationBlock moveCenter = ^(void){
        [self.centerView setTransform:CGAffineTransformIdentity];
        [self.view layoutIfNeeded];
    };
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                     animations:moveCenter completion:nil];
    
}

-(void) finalPositionCenterView {
    [self.centerView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    [self.centerView setCenter:self.view.center];
}

-(void) initialPositionCenterView {
    CGAffineTransform hideUnder = CGAffineTransformMakeScale(1.0, 0.2);
    self.centerView.transform = hideUnder;
    
}

#pragma mark - HomeDelegate
-(void) delegateShowAbout {
    [self performSegueWithIdentifier:@"InfoToAbout" sender:self];
}

-(void) delegateShowContact {
    [self performSegueWithIdentifier:@"InfoToContact" sender:self];
}

-(void) delegateShowBugRep {
    [self performSegueWithIdentifier:@"InfoToBugReport" sender:self];
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
