//
//  HomeUpperView.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDelegate.h"

@interface HomeUpperView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oAccountTopConstraint;
@property (weak, nonatomic) IBOutlet UITextField *oEmailText;
@property (weak, nonatomic) IBOutlet UITextField *oPasswordText;
@property (weak, nonatomic) IBOutlet UIButton *oForgotButton;
@property (weak, nonatomic) IBOutlet UIButton *oConnectButton;

@property (assign) id<HomeDelegate> parent;         // the parent controller implements this

-(void) setupFields:(id) sender;
@end
