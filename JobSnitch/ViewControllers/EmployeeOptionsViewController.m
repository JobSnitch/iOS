//
//  EmployeeOptionsViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeOptionsViewController.h"
#import "EmployeeRecord.h"

@interface EmployeeOptionsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *oToggleButton;
@property (weak, nonatomic) IBOutlet UIImageView *oTopImage;
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *oCheckMap;
@property (weak, nonatomic) IBOutlet UIImageView *oCheckList;
@property (weak, nonatomic) IBOutlet UIImageView *oCheckSwipe;

@property (nonatomic) int   checkValue;
@end

@implementation EmployeeOptionsViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupEmployee];

    [self setupView];
}

-(void) setupEmployee {
    [super setupEmployee];
    if ([self.currentEmployee.name isEqualToString:@"jobseeker"]) {
        [self downloadUserInfo:testUserID2];
    }
}

-(void) setupHeader {
    self.oTopImage.image = [UIImage imageNamed:self.currentEmployee.imageName];
    self.oNameLabel.text = self.currentEmployee.name;
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.oTopImage.image = avatarImage;
    }
}

-(void) setupView {
    [self setupHeader];
    self.oBackImage.image = [UIImage imageNamed:@"gradient_red_back_sq"];
    [self.oCheckMap setHidden:true];
    [self.oCheckList setHidden:true];
    [self.oCheckSwipe setHidden:true];
    
    [self actionMap:nil];                   // change when real data
}

#pragma mark - actions
- (IBAction)actionToggle:(id)sender {
    [self.parent parentReplaceFirst:self.checkValue];
}

- (IBAction)actionMap:(id)sender {
    self.checkValue = 0;
    [self updateChecks];
}

- (IBAction)actionList:(id)sender {
    self.checkValue = 1;
    [self updateChecks];
}

- (IBAction)actionSwipe:(id)sender {
    self.checkValue = 2;
    [self updateChecks];
}

-(void)updateChecks {
    switch (self.checkValue) {
        case -1:
            [self.oCheckMap setHidden:true];
            [self.oCheckList setHidden:true];
            [self.oCheckSwipe setHidden:true];
            break;
        case 0:
            [self.oCheckMap setHidden:false];
            [self.oCheckList setHidden:true];
            [self.oCheckSwipe setHidden:true];
            break;
        case 1:
            [self.oCheckMap setHidden:true];
            [self.oCheckList setHidden:false];
            [self.oCheckSwipe setHidden:true];
            break;
        case 2:
            [self.oCheckMap setHidden:true];
            [self.oCheckList setHidden:true];
            [self.oCheckSwipe setHidden:false];
            break;
        default:
            break;
    }
}

#pragma mark - UserInfo callback
-(void) setupFromUserInfo:(UserRecord *)currUser {
    if (currUser.FirstName) {                      // my interpretation
        self.currentEmployee.name = currUser.FirstName;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).currUserNick = currUser.FirstName;
        self.oNameLabel.text = self.currentEmployee.name;
    }
    
    [self.view setNeedsDisplay];
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
