//
//  NewInfoPopupView.m
//  JobSnitch
//
//  Created by Andrei Sava on 09/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "NewInfoPopupView.h"

@implementation NewInfoPopupView

- (IBAction)actionCancel:(id)sender {
    [self.parent delegateHasCanceled];
}

- (IBAction)actionSave:(id)sender {
    [self.parent delegateHasSaved];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}
@end
