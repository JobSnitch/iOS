//
//  ForgotPasswordController.m
//  JobSnitch
//
//  Created by Andrei Sava on 09/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "ForgotPasswordController.h"

@interface ForgotPasswordController ()

@end

@implementation ForgotPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super initBackground];
    
    self.oEmailField.returnKeyType = UIReturnKeyDone;
    self.oEmailField.delegate = self;
}

- (IBAction)actionSend:(id)sender {
    [self performSegueWithIdentifier: @"passwordRequestExit" sender: self];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
