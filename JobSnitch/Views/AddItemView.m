//
//  AddItemView.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "AddItemView.h"

@implementation AddItemView

-(void) setupFields:(id) sender {
    self.oTextField.returnKeyType = UIReturnKeyDone;
    self.oTextField.delegate = sender;
    self.oTextField.tag = 700;
}

- (IBAction)oActionArrow:(id)sender {
    [self.parent delegateHasAdded];
}

@end
