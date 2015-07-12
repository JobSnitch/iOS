//
//  PostingExpandedView.h
//  JobSnitch
//
//  Created by Andrei Sava on 11/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostingExpandedView : UIView
@property (strong, nonatomic)  UIImageView *oBackImage;
//@property (weak, nonatomic) IBOutlet UILabel *oJTitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oJTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oIndustryLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oEveningLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oAfternoonLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oMorningLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oNightLabel;
//@property (weak, nonatomic) IBOutlet UILabel *oDescriptionLabel;
//@property (weak, nonatomic) IBOutlet UIButton *oPlusButton;
//@property (weak, nonatomic) IBOutlet UIButton *oBinButton;
//@property (weak, nonatomic) IBOutlet UIButton *oJTypeButton;
//@property (weak, nonatomic) IBOutlet UIButton *oIndustryButton;
//@property (weak, nonatomic) IBOutlet UISwitch *oMorningSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *oAfternoonSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *oEveningSwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *oNightSwitch;

-(void) layoutFields: (CGSize) realSize;

@end
