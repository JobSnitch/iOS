//
//  HomeLowerView.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 Andrei Sava. All rights reserved.
//

#import "HomeLowerView.h"

@implementation HomeLowerView

- (IBAction)actionForgot:(id)sender {
}

- (IBAction)actionLoginFacebook:(id)sender {
}

- (IBAction)actionCreateAccount:(id)sender {
    [self.delegate delegateCreateEmployer];
}


@end
