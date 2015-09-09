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
#import "NewInfoPopupParent.h"
#import "NewInfoPopupView.h"
#import "EmployerRecord.h"

@interface CreateEmployerController () <UITableViewDelegate, UITableViewDataSource, PhotoDelegate, NewInfoPopupParent, AddItemParent>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *oTopView;
@property (weak, nonatomic) IBOutlet UIView *oReqBusiness;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *oScrollView;
@property (weak, nonatomic) IBOutlet UITableView *oBusinessTable;
@property (weak, nonatomic) IBOutlet UITableView *oBillingTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oBusinessHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oBillingHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *oTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *oCreateButton;

@property (strong, nonatomic)  AddItemView *oReqBusinessReal;
@property (strong, nonatomic)  CreateTopView *oTopViewReal;
@property (nonatomic, strong)   NSString *requiredInfo;
@property (nonatomic, strong)   NSMutableArray *currentBusinesses;
@property (nonatomic, strong)   NSMutableArray *currentBillings;
@property (nonatomic, strong)   NewInfoPopupView *infoPopupView;
@property (nonatomic, strong)   NSString *infoText;
@property (nonatomic)   PersonContext myContext;
@property (nonatomic, strong)   EmployerRecord *currentEmployer;

@end

const float kMagicHeight2 = 764.0;
#pragma mark - init
@implementation CreateEmployerController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myContext = creationContext;
    self.currentEmployer = [[EmployerRecord alloc] init];
    [self setupTables];
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

-(void) setupTables {
    self.oBusinessTable.delegate = self;
    self.oBusinessTable.dataSource = self;
    
    self.oBillingTable.delegate = self;
    self.oBillingTable.dataSource = self;
    
    self.currentBillings = [[NSMutableArray alloc] init];
    self.currentBusinesses = [[NSMutableArray alloc] init];
}

-(void) setupCustomViews {
    CGRect reqFrame = CGRectMake(0, 0,
                                 self.oReqBusiness.frame.size.width, self.oReqBusiness.frame.size.height);
    CGRect topFrame = CGRectMake(0, 0,
                                 self.oTopView.frame.size.width, self.oTopView.frame.size.height);
    self.oReqBusinessReal = [[[NSBundle mainBundle] loadNibNamed:@"AddItemView" owner:self options:nil] objectAtIndex:0];
    [self.oReqBusinessReal setFrame:reqFrame];
    [self.oReqBusiness addSubview:self.oReqBusinessReal];
    self.oReqBusinessReal.oTextField.placeholder = @"Required";
    [self.oReqBusinessReal setupFields:self];
    self.oReqBusinessReal.parent = self;

    self.oTopViewReal = [[[NSBundle mainBundle] loadNibNamed:@"CreateTopView" owner:self options:nil] objectAtIndex:0];
    [self.oTopViewReal setFrame:topFrame];
    [self.oTopView addSubview:self.oTopViewReal];
    [self.oTopViewReal setupFields:self];
    self.oTopViewReal.parent = self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *avatarImage = [super getAvatarPhoto];
    if (avatarImage && self.oTopViewReal) {
        [self.oTopViewReal.oPhotoButton setImage:avatarImage forState:UIControlStateNormal];
    }
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.oWidthConstraint.constant = self.view.bounds.size.width-20.0;
    if (self.currentBusinesses && self.currentBusinesses.count) {
        self.oBusinessHeightConstraint.constant = self.currentBusinesses.count * [self tableView:self.oBusinessTable heightForRowAtIndexPath:0];
    }
    if (self.currentBillings && self.currentBillings.count) {
        self.oBillingHeightConstraint.constant = self.currentBillings.count * [self tableView:self.oBillingTable heightForRowAtIndexPath:0];
    }
    self.oHeightConstraint.constant = kMagicHeight2 + self.oBusinessHeightConstraint.constant + self.oBillingHeightConstraint.constant;

    [self.view layoutIfNeeded];
}

// handle for UIKeyboardDidShowNotification
- (void)keyboardDidShow:(NSNotification *)notification
{
//    [self.oScrollView setContentOffset:CGPointMake(0, 56.0*2) animated:YES];
}

// handle for UIKeyboardDidHideNotification
-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.oScrollView setContentOffset:CGPointMake(0, 0) animated:NO];      // bug if YES?
}

#pragma mark - settings context
-(void) customizeSettings {
    _myContext = settingContext;
    self.oTitleLabel.text = @"Employer Settings";
    [self.oCreateButton setTitle:@"SAVE" forState:UIControlStateNormal];
}

-(void) setupEmployer:(id) sender {
    if (sender != self) {               // settings
        [self downloadUserInfo:testUserID2];
    }
}

-(void) setupFromUserInfo:(UserRecord *)currUser {
    if (currUser.Email) {
        self.oTopViewReal.oEmailField.text = currUser.Email;
    }
    if (currUser.FirstName || currUser.LastName) {                      // my interpretation
        self.oTopViewReal.oUsernameField.text = [NSString stringWithFormat:@"%@ %@", currUser.FirstName, currUser.LastName];
    }
    
    [self.view setNeedsDisplay];
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSInteger thisTag = textField.tag;
    if (thisTag == 700) {
        [self.oScrollView setContentOffset:CGPointMake(0, 56.0*7) animated:YES];
    } else {
        [self.oScrollView setContentOffset:CGPointMake(0, 56.0*(thisTag-1000+2)) animated:YES];
    }
    return YES;
}

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
        if (textField.tag == 700) {
            self.requiredInfo = textField.text;
        }
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self.oScrollView setContentOffset:CGPointMake(0, 0) animated:NO];      // bug if YES?
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - actions
- (IBAction)actionAddBilling:(id)sender {
}

- (IBAction)actionCreateEmployer:(id)sender {
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
    if (![self NSStringIsValidEmail:self.oTopViewReal.oEmailField.text])
    {
        message = @"Email address not valid";
        [self createWarningView:message];
        return ;
    }
    if ( !self.oReqBusinessReal.oTextField.text.length)
    {
        [self createWarningView:message];
        return ;
    }
    
    [self performSegueWithIdentifier:@"CreateEmpToEmployer" sender:self];
}


#pragma mark - AddItemParent
-(void) delegateHasAdded {
    if ([self.oReqBusinessReal.oTextField.text isEqualToString:@""]) {           // first the required one
        UIResponder* nextResponder = self.oReqBusinessReal.oTextField;
        [nextResponder becomeFirstResponder];
    } else {
        [self initPopupView];
    }
}

-(void) initPopupView {
    self.infoPopupView = nil;
    self.infoPopupView = [[[NSBundle mainBundle] loadNibNamed:@"NewInfoPopupView" owner:self options:nil] objectAtIndex:0];
    [self.infoPopupView setFrame:CGRectMake((self.view.bounds.size.width-300.0)*0.5, (self.view.bounds.size.height-300.0)*0.5, 300.0, 300.0)];
    self.infoPopupView.parent = self;
    [self.view addSubview:self.infoPopupView];
    self.infoPopupView.oTextView.delegate = self.infoPopupView;
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.oBusinessTable) {
        if (self.currentBusinesses) {
            return self.currentBusinesses.count;
        } else {
            return 0;
        }
    } else {
        if (self.currentBillings) {
            return self.currentBillings.count;
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
    if (tableView == self.oBusinessTable) {
        if (!self.currentBusinesses || !(indexPath.row < self.currentBusinesses.count)) {
            return cell;
        }
    } else {
        if (!self.currentBillings || !(indexPath.row < self.currentBillings.count)){
            return cell;
        }
    }
    static NSString *CellIdentifier = @"EmployerTableID";
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
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    
    UILabel * l1 = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 19.0f, 200.0f, 18.0f)];
    [cell.contentView addSubview:l1];
    l1.textAlignment = NSTextAlignmentLeft;
    NSString *content = nil;
    if (tableView == self.oBusinessTable) {
        content = self.currentBusinesses[indexPath.row];
    } else {
        content = self.currentBillings[indexPath.row];
    }
    
    l1.attributedText = [[NSAttributedString alloc] initWithString:content
                                                        attributes:text1Attribute];
    return cell;
}

#pragma mark - NewInfoPopupParent
-(void) delegateHasCanceled {
    if (self.infoPopupView) {
        [self.infoPopupView removeFromSuperview];
        self.infoPopupView = nil;
    }
}

-(void) delegateHasSaved {
    if (self.infoPopupView) {
        self.infoText = self.infoPopupView.oTextView.text;
        [self.infoPopupView removeFromSuperview];
        self.infoPopupView = nil;
        [self refreshScreenTables];
    }
}

-(void) refreshScreenTables {
    if (self.self.infoText) {
        [self.currentBusinesses addObject:self.infoText];
        [self.oBusinessTable reloadData];
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
