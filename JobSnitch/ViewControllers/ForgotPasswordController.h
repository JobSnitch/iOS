//
//  ForgotPasswordController.h
//  JobSnitch
//
//  Created by Andrei Sava on 09/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"

@interface ForgotPasswordController : BaseJSViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oEmailField;

@end
