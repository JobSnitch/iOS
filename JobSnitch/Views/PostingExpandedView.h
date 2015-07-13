//
//  PostingExpandedView.h
//  JobSnitch
//
//  Created by Andrei Sava on 11/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployerFirstParent.h"

@interface PostingExpandedView : UIView
@property (strong, nonatomic)  UIImageView *oBackImage;
@property (strong, nonatomic)  UITextField *oJTitleText;
@property (strong, nonatomic)  UITextView *oDescriptionText;
@property (strong, nonatomic)  UILabel *oJTypeLabel;
@property (strong, nonatomic) UILabel *oIndustryLabel;
@property (strong, nonatomic) UILabel *oEveningLabel;
@property (strong, nonatomic) UILabel *oAfternoonLabel;
@property (strong, nonatomic) UILabel *oMorningLabel;
@property (strong, nonatomic) UILabel *oNightLabel;
@property (strong, nonatomic) UIButton *oPlusButton;
@property (strong, nonatomic) UIButton *oBinButton;
@property (strong, nonatomic) UIButton *oJTypeButton;
@property (strong, nonatomic) UIButton *oIndustryButton;
@property (strong, nonatomic) UISwitch *oMorningSwitch;
@property (strong, nonatomic) UISwitch *oAfternoonSwitch;
@property (strong, nonatomic) UISwitch *oEveningSwitch;
@property (strong, nonatomic) UISwitch *oNightSwitch;

@property (assign) id<EmployerFirstParent> parent;         // the parent controller implements this

-(void) layoutFields: (CGSize) realSize offsetY:(CGFloat) yoffset;

@end
