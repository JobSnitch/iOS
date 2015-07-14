//
//  ContactPopupView.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "ContactPopupView.h"

@implementation ContactPopupView

- (IBAction)actionPhone:(id)sender {
    [self.delegate delegatePhone:sender];
}

- (IBAction)actionMessages:(id)sender {
    [self.delegate delegateMessages:sender];
}

- (IBAction)actionEmail:(id)sender {
    [self.delegate delegateEmail:sender];
}

@end
