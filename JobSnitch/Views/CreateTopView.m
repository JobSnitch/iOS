//
//  CreateTopView.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "CreateTopView.h"

@implementation CreateTopView

-(void) setupFields:(id) sender {
    self.oUsernameField.returnKeyType = UIReturnKeyNext;
    self.oUsernameField.delegate = sender;
    self.oUsernameField.tag = 1000;
    
    self.oPasswordField.returnKeyType = UIReturnKeyNext;
    self.oPasswordField.delegate = sender;
    self.oPasswordField.tag = 1001;

    self.oEmailField.returnKeyType = UIReturnKeyNext;
    self.oEmailField.delegate = sender;
    self.oEmailField.tag = 1002;

    self.oPhoneField.returnKeyType = UIReturnKeyDone;
    self.oPhoneField.delegate = sender;
    self.oPhoneField.tag = 1003;
}

- (IBAction)actionPhoto:(id)sender {
    NSLog(@"photo");
}

@end
