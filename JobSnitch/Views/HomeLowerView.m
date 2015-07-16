//
//  HomeLowerView.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "HomeLowerView.h"

@implementation HomeLowerView

-(void) setupFields:(id) sender {
    self.oEmailText.returnKeyType = UIReturnKeyNext;
    self.oEmailText.delegate = sender;
    self.oEmailText.tag = 800;
    
    self.oPasswordText.returnKeyType = UIReturnKeyDone;
    self.oPasswordText.delegate = sender;
    self.oPasswordText.tag = 801;
}

- (IBAction)actionForgot:(id)sender {
    [self.parent delegateForgotPassword];
}

- (IBAction)actionLoginFacebook:(id)sender {
}

- (IBAction)actionCreateAccount:(id)sender {
    [self.parent delegateCreateEmployer];
}

- (IBAction)actionConnect:(id)sender {
    [self.parent delegateConnectEmployer];
}


@end
