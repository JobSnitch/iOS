//
//  HomeUpperView.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "HomeUpperView.h"

@implementation HomeUpperView

-(void) setupFields:(id) sender {
    self.oEmailText.returnKeyType = UIReturnKeyNext;
    self.oEmailText.delegate = sender;
    self.oEmailText.tag = 900;
    
    self.oPasswordText.returnKeyType = UIReturnKeyDone;
    self.oPasswordText.delegate = sender;
    self.oPasswordText.tag = 901;
}

- (IBAction)actionForgot:(id)sender {
    [self.parent delegateForgotPassword];
}

- (IBAction)actionLoginFacebook:(id)sender {
}

- (IBAction)actionCreateAccount:(id)sender {
    [self.parent delegateCreateJSeeker];
}

- (IBAction)actionConnect:(id)sender {
}

@end
