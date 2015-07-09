//
//  CreateEmployerController.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "CreateEmployerController.h"
#import "CreateTopView.h"
#import "AddItemView.h"

@interface CreateEmployerController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *oTopView;
@property (weak, nonatomic) IBOutlet UIView *oReqBusiness;
@property (weak, nonatomic) IBOutlet UIView *oOptBusiness;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *oScrollView;

@property (strong, nonatomic)  AddItemView *oReqBusinessReal;
@property (strong, nonatomic)  AddItemView *oOptBusinessReal;
@property (strong, nonatomic)  CreateTopView *oTopViewReal;
@property (nonatomic)   int noBilling;
@property (nonatomic)   int noLocations;

@end

const float kMagicHeight2 = 876.0;
#pragma mark - init
@implementation CreateEmployerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noBilling= 0;
    _noLocations = 0;
    [self setupCustomViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

-(void) setupCustomViews {
    CGRect reqFrame = CGRectMake(0, 0,
                                 self.oReqBusiness.frame.size.width, self.oReqBusiness.frame.size.height);
    CGRect optFrame = CGRectMake(0, 0,
                                 self.oOptBusiness.frame.size.width, self.oOptBusiness.frame.size.height);
    CGRect topFrame = CGRectMake(0, 0,
                                 self.oTopView.frame.size.width, self.oTopView.frame.size.height);
    self.oReqBusinessReal = [[[NSBundle mainBundle] loadNibNamed:@"AddItemView" owner:self options:nil] objectAtIndex:0];
    [self.oReqBusinessReal setFrame:reqFrame];
    [self.oReqBusiness addSubview:self.oReqBusinessReal];
    self.oReqBusinessReal.oTextField.placeholder = @"Required";
    
    self.oOptBusinessReal = [[[NSBundle mainBundle] loadNibNamed:@"AddItemView" owner:self options:nil] objectAtIndex:0];
    [self.oOptBusinessReal setFrame:optFrame];
    [self.oOptBusiness addSubview:self.oOptBusinessReal];
    self.oOptBusinessReal.oTextField.placeholder = @"Optional";
    
    self.oTopViewReal = [[[NSBundle mainBundle] loadNibNamed:@"CreateTopView" owner:self options:nil] objectAtIndex:0];
    [self.oTopViewReal setFrame:topFrame];
    [self.oTopView addSubview:self.oTopViewReal];

    [self.oTopViewReal setupFields:self];
}


-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.oWidthConstraint.constant = self.view.bounds.size.width-20.0;
    self.oHeightConstraint.constant = kMagicHeight2 + 56.0* (_noBilling + _noLocations);

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
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self.oScrollView setContentOffset:CGPointMake(0, 0) animated:NO];      // bug if YES?
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


#pragma mark - other

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
