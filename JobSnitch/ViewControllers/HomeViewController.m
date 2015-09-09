//
//  HomeViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCenterView.h"
#import "HomeUpperView.h"
#import "HomeLowerView.h"

const float kArrowHeight = 61.0;
@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *oLogoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oImageVertConstraint;

@property (strong, nonatomic)   HomeCenterView *centerView;
@property (strong, nonatomic)   HomeUpperView *upperView;
@property (strong, nonatomic)   HomeLowerView *lowerView;
@property (nonatomic, strong)   UITapGestureRecognizer *logoTapRecognizer;
@property (nonatomic, strong)   UITapGestureRecognizer *upperTapRecognizer;
@property (nonatomic, strong)   UITapGestureRecognizer *lowerTapRecognizer;
@property (nonatomic)   BOOL    restrictedUpper;
@property (nonatomic)   BOOL    restrictedLower;
@property (nonatomic)           CGAffineTransform lowerTransform;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUpperView];
    [self initLowerView];
    [self initRecognizers];

}

-(void) initRecognizers {
    self.oLogoImageView.userInteractionEnabled = YES;
    if (_logoTapRecognizer) _logoTapRecognizer = nil;
    _logoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleLogoTap:)];
    [self.oLogoImageView addGestureRecognizer:_logoTapRecognizer];
    
    self.upperView.userInteractionEnabled = YES;
    if (_upperTapRecognizer) _upperTapRecognizer = nil;
    _upperTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(handleUpperTap:)];
    [self.upperView addGestureRecognizer:_upperTapRecognizer];
    
    self.lowerView.userInteractionEnabled = YES;
    if (_lowerTapRecognizer) _lowerTapRecognizer = nil;
    _lowerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(handleLowerTap:)];
    [self.lowerView addGestureRecognizer:_lowerTapRecognizer];
    
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.view.bounds.size.height < 481.0) {
        self.upperView.oTopConstraint.constant = 116.0;
        self.upperView.oAccountTopConstraint.constant = 20.0;
        
        self.lowerView.oTopConstraint.constant = 80.0;
        self.lowerView.oAccountTopConstraint.constant = 20.0;
        
        [self.view layoutIfNeeded];
    }
}

#pragma mark - upper/bottom views

-(void) initUpperView {
    self.upperView = nil;
    self.upperView = [[[NSBundle mainBundle] loadNibNamed:@"HomeUpperView" owner:self options:nil] objectAtIndex:0];
    [self restrictedPositionUpperView];
    self.upperView.parent = self;
    [self.upperView setupFields:self];
    [self.view addSubview:self.upperView];
    _restrictedUpper = TRUE;
}

-(void) initLowerView {
    self.lowerView = nil;
    self.lowerView = [[[NSBundle mainBundle] loadNibNamed:@"HomeLowerView" owner:self options:nil] objectAtIndex:0];
    [self restrictedPositionLowerView];
    self.lowerView.parent = self;
    [self.lowerView setupFields:self];
    [self.view addSubview:self.lowerView];
    _restrictedLower = TRUE;
}

-(void) restrictedPositionUpperView {
    if (self.view.bounds.size.height < 570.0) {
        [self.upperView setFrame:CGRectMake(0, kArrowHeight-425.0, self.view.bounds.size.width, 425.0)];
    } else {
        [self.upperView setFrame:CGRectMake(0, kArrowHeight-550.0, self.view.bounds.size.width, 550.0)];
    }
}

-(void) restrictedPositionLowerView {
    if (self.view.bounds.size.height < 570.0) {
        [self.lowerView setFrame:CGRectMake(0, self.view.bounds.size.height - kArrowHeight, self.view.bounds.size.width, 423.0)];
    } else {
        [self.lowerView setFrame:CGRectMake(0, self.view.bounds.size.height - kArrowHeight, self.view.bounds.size.width, 550.0)];
    }
}

-(void) showUpperView {
    CGAffineTransform descend, descend2;
    if (self.view.bounds.size.height < 481.0) {
        descend = CGAffineTransformMakeTranslation(0.0, (325.0-kArrowHeight) );
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            descend2 = CGAffineTransformMakeTranslation(0.0, (325.0-kArrowHeight)*0.5*[UIScreen mainScreen].scale);
        } else {
            descend2 = CGAffineTransformMakeTranslation(0.0, (325.0-kArrowHeight)*0.5);
        }
    } else if (self.view.bounds.size.height < 570.0) {
        descend = CGAffineTransformMakeTranslation(0.0, (425.0-kArrowHeight));
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            descend2 = CGAffineTransformMakeTranslation(0.0, (425.0-kArrowHeight)*0.5*[UIScreen mainScreen].scale);
        } else {
            descend2 = CGAffineTransformMakeTranslation(0.0, (425.0-kArrowHeight)*0.5);
        }
    } else {
        descend = CGAffineTransformMakeTranslation(0.0, (550.0-kArrowHeight));
        descend2 = CGAffineTransformMakeTranslation(0.0, (550.0-kArrowHeight)*0.5);
    }
    
    if (self.oLogoImageView.hidden == TRUE) {
        self.oLogoImageView.hidden = FALSE;
        self.centerView.hidden = TRUE;
        [self initialPositionCenterView];
    }
    
    AnimationBlock descendUpper = ^(void){
        [self.upperView setTransform:descend];
        [self.oLogoImageView setTransform:descend2];
        [self.lowerView setTransform:CGAffineTransformIdentity];
        [self.view layoutIfNeeded];
    };
    CompletionBlock removeImage = ^(BOOL finished) {
        _restrictedLower = TRUE;
    };
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                     animations:descendUpper completion:removeImage];
}

-(void) showLowerView {
    CGAffineTransform climb, climb2;
    if (self.view.bounds.size.height < 481.0) {
        climb = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-325.0));
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            climb2 = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-325.0)*0.5*[UIScreen mainScreen].scale);
        } else {
            climb2 = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-325.0)*0.5);
        }
    } else if (self.view.bounds.size.height < 570.0) {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            climb2 = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-423.0)*0.5*[UIScreen mainScreen].scale);
        } else {
            climb2 = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-423.0)*0.5);
        }
        climb = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-423.0));
    } else {
        climb = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-550.0));
        climb2 = CGAffineTransformMakeTranslation(0.0, (kArrowHeight-550.0)*0.5);
    }
    
    if (self.oLogoImageView.hidden == TRUE) {
        self.oLogoImageView.hidden = FALSE;
        self.centerView.hidden = TRUE;
        [self initialPositionCenterView];
    }
    
    AnimationBlock climbLower = ^(void){
        [self.lowerView setTransform:climb];
        [self.oLogoImageView setTransform:climb2];
        [self.upperView setTransform:CGAffineTransformIdentity];
        [self.view layoutIfNeeded];
    };
    CompletionBlock removeImage = ^(BOOL finished) {
        _restrictedUpper = TRUE;
        self.lowerTransform = climb;
    };
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                     animations:climbLower completion:removeImage];
}

-(void) hideUpperView {
    AnimationBlock climbUpper = ^(void){
        [self.oLogoImageView setTransform:CGAffineTransformIdentity];
        [self.upperView setTransform:CGAffineTransformIdentity];
        [self.view layoutIfNeeded];
    };

    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                     animations:climbUpper completion:nil];
}

-(void) hideLowerView {
    AnimationBlock descendLower = ^(void){
        [self.oLogoImageView setTransform:CGAffineTransformIdentity];
        [self.lowerView setTransform:CGAffineTransformIdentity];
        [self.view layoutIfNeeded];
    };
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                     animations:descendLower completion:nil];
}


-(void) handleUpperTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (_restrictedUpper) {         // expand
            [self showUpperView];
            _restrictedUpper = FALSE;
        } else {
            [self hideUpperView];
            _restrictedUpper = TRUE;
        }
    }
}

-(void) handleLowerTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded){
        if (_restrictedLower) {         // expand
            [self showLowerView];
            _restrictedLower = FALSE;
        } else {
            [self hideLowerView];
            _restrictedLower = TRUE;
        }
    }
}

#pragma mark - show center view
-(void) handleLogoTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded){
        [self showCenterView];
    }
}

-(void) showCenterView {
    self.centerView = nil;
    self.centerView = [[[NSBundle mainBundle] loadNibNamed:@"HomeCenterView" owner:self options:nil] objectAtIndex:0];
    self.centerView.delegate = self;
    [self finalPositionCenterView];
    [self.view insertSubview:self.centerView belowSubview:self.oLogoImageView];
    [self initialPositionCenterView];
    if (!_restrictedLower) {
        [self hideLowerView];
    }
    if (!_restrictedUpper) {
        [self hideUpperView];
    }

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
        [self.oLogoImageView setTransform:climb];
        [self.view layoutIfNeeded];
    };
    CompletionBlock removeImage = ^(BOOL finished) {
        self.oLogoImageView.hidden = TRUE;
        [self.oLogoImageView setTransform:CGAffineTransformIdentity];
    };

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionBeginFromCurrentState
                     animations:moveCenter completion:removeImage];
    
}

-(void) finalPositionCenterView {
    [self.centerView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    [self.centerView setCenter:self.view.center];
}

-(void) initialPositionCenterView {
    CGAffineTransform hideUnder = CGAffineTransformMakeScale(1.0, 0.2);
    self.centerView.transform = hideUnder;

}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger thisTag = textField.tag;
    if (thisTag < 900) {        // lower
        [self raiseLowerHigher:50.0];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger thisTag = textField.tag;
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = nil;
    if (thisTag < 900) {        // lower
        nextResponder = [self.lowerView viewWithTag:nextTag];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
            [self raiseLowerHigher:100.0];
        } else {
            [textField resignFirstResponder];
            [self.lowerView setTransform:self.lowerTransform];
        }
    } else {                    // upper
        nextResponder = [self.upperView viewWithTag:nextTag];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    return NO;
}

-(void) raiseLowerHigher: (CGFloat) ty {
    CGAffineTransform higherLowerTransform = self.lowerTransform;
    higherLowerTransform.ty -= ty;
    [self.lowerView setTransform:higherLowerTransform];
}

#pragma mark - HomeDelegate
-(void) delegateForgotPassword {
    [self performSegueWithIdentifier:@"HomeToForgotPassword" sender:self];
}

-(void) delegateLoginFacebook {
    
}

-(void) delegateCreateJSeeker {
    [self performSegueWithIdentifier:@"HomeToCreateJSeeker" sender:self];
}

-(void) delegateCreateEmployer {
    [self performSegueWithIdentifier:@"HomeToCreateEmployer" sender:self];
}

-(void) delegateShowAbout {
    [self performSegueWithIdentifier:@"HomeToAbout" sender:self];
}

-(void) delegateShowContact {
    [self performSegueWithIdentifier:@"HomeToContact" sender:self];
}

-(void) delegateShowBugRep {
    [self performSegueWithIdentifier:@"HomeToBugReport" sender:self];
}

-(void) delegateConnectEmployer {
    [self ValidateEmployer];
}

- (void) ValidateEmployer {
    // check empty fields
    NSString *message = @"Please fill in the fields and try logging in again.";
    if ( !self.lowerView.oEmailText.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if ( !self.lowerView.oPasswordText.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if (![self NSStringIsValidEmail:self.lowerView.oEmailText.text])
    {
        message = @"Email address not valid";
        [self createWarningView:message];
        return ;
    }
    [self processLoginEmployer];
}

-(void) processLoginEmployer {
//    // how to perform Login?
    NSString *userName = self.lowerView.oEmailText.text;
    NSString *userPass = self.lowerView.oPasswordText.text;
    userName = testUserName;
    userPass = testUserPass;
    [self performSegueWithIdentifier:@"HomeToEmployer" sender:self];
}

-(void) delegateConnectEmployee {
    [self ValidateEmployee];
}

- (void) ValidateEmployee {
    // check empty fields
    NSString *message = @"Please fill in the fields and try logging in again.";
    if ( !self.upperView.oEmailText.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if ( !self.upperView.oPasswordText.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    if (![self NSStringIsValidEmail:self.upperView.oEmailText.text])
    {
        message = @"Email address not valid";
        [self createWarningView:message];
        return ;
    }
    [self processLoginEmployee];
}

-(void) processLoginEmployee {
//    // how to perform Login?
    NSString *userName = self.upperView.oEmailText.text;
    NSString *userPass = self.upperView.oPasswordText.text;
    userName = testUserName;
    userPass = testUserPass;
    [self performSegueWithIdentifier:@"HomeToEmployee" sender:self];
}

#pragma mark - network
-(void) doWhenInternetIsPresent {
    
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
