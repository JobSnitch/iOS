//
//  CreateTopView.h
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *oPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *oUsernameField;
@property (weak, nonatomic) IBOutlet UITextField *oPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *oEmailField;
@property (weak, nonatomic) IBOutlet UITextField *oPhoneField;

-(void) setupFields:(id) sender;
@end