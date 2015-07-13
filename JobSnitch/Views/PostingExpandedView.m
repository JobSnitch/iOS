//
//  PostingExpandedView.m
//  JobSnitch
//
//  Created by Andrei Sava on 11/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingExpandedView.h"

@implementation PostingExpandedView


-(void) layoutFields: (CGSize) realSize{
    CGFloat originX = 14.0;

    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *text2Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.oJTitleText = [[UITextField alloc] initWithFrame:CGRectMake(originX + 20.0, 25.0, 72.0, 22.0)];
    self.oJTitleText.tag = 300;
    self.oJTitleText.returnKeyType = UIReturnKeyNext;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Job Title" attributes:text1Attribute];
    [self.oJTitleText setAttributedPlaceholder:attributedPlaceholder];
    [self.oJTitleText setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [self.oJTitleText setTextColor:[UIColor whiteColor]];
    [self addSubview:self.oJTitleText];
    
    self.oDescriptionText = [[UITextView alloc] initWithFrame:CGRectMake(originX + 20.0, 75.0, 100.0, 104.0)];
    self.oDescriptionText.tag = 301;
    self.oDescriptionText.returnKeyType = UIReturnKeyDone;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"Job description / details in 250 characters or less" attributes:text2Attribute];
    [self.oDescriptionText setAttributedText:attributedText];
    [self.oDescriptionText setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.oDescriptionText];
    
    self.oJTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(realSize.width -122.0, 25.0, 75.0, 22.0)];
    attributedText = [[NSAttributedString alloc] initWithString:@"Job Type" attributes:text1Attribute];
    [self.oJTypeLabel setAttributedText:attributedText];
    [self addSubview:self.oJTypeLabel];
    
    self.oIndustryLabel = [[UILabel alloc] initWithFrame:CGRectMake(realSize.width -122.0, 85.0, 75.0, 22.0)];
    attributedText = [[NSAttributedString alloc] initWithString:@"Industry" attributes:text1Attribute];
    [self.oIndustryLabel setAttributedText:attributedText];
    [self addSubview:self.oIndustryLabel];
    
    self.oMorningLabel = [[UILabel alloc] initWithFrame:CGRectMake(realSize.width -175.0, 140.0, 75.0, 22.0)];
    attributedText = [[NSAttributedString alloc] initWithString:@"Morning" attributes:text1Attribute];
    [self.oMorningLabel setAttributedText:attributedText];
    [self addSubview:self.oMorningLabel];
    
    self.oAfternoonLabel = [[UILabel alloc] initWithFrame:CGRectMake(realSize.width -175.0, 198.0, 75.0, 22.0)];
    attributedText = [[NSAttributedString alloc] initWithString:@"Afternoon" attributes:text1Attribute];
    [self.oAfternoonLabel setAttributedText:attributedText];
    [self addSubview:self.oAfternoonLabel];
    
    self.oEveningLabel = [[UILabel alloc] initWithFrame:CGRectMake(realSize.width -175.0, 256.0, 75.0, 22.0)];
    attributedText = [[NSAttributedString alloc] initWithString:@"Evening" attributes:text1Attribute];
    [self.oEveningLabel setAttributedText:attributedText];
    [self addSubview:self.oEveningLabel];
    
    self.oNightLabel = [[UILabel alloc] initWithFrame:CGRectMake(realSize.width -175.0, 314.0, 75.0, 22.0)];
    attributedText = [[NSAttributedString alloc] initWithString:@"Night" attributes:text1Attribute];
    [self.oNightLabel setAttributedText:attributedText];
    [self addSubview:self.oNightLabel];
    
    self.oMorningSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(realSize.width -66.0, 138.0, 0.0, 0.0)];
    [self.oMorningSwitch addTarget:self action:@selector(actionMorningSw:) forControlEvents:UIControlEventValueChanged];
    self.oMorningSwitch.onTintColor = [UIColor whiteColor];
    self.oMorningSwitch.thumbTintColor = [UIColor redColor];
    [self addSubview: self.oMorningSwitch];
    
    self.oAfternoonSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(realSize.width -66.0, 196.0, 0.0, 0.0)];
    [self.oAfternoonSwitch addTarget:self action:@selector(actionAfternoonSw:) forControlEvents:UIControlEventValueChanged];
    self.oAfternoonSwitch.onTintColor = [UIColor whiteColor];
    self.oAfternoonSwitch.thumbTintColor = [UIColor redColor];
    [self addSubview: self.oAfternoonSwitch];
    
    self.oEveningSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(realSize.width -66.0, 254.0, 0.0, 0.0)];
    [self.oEveningSwitch addTarget:self action:@selector(actionEveningSw:) forControlEvents:UIControlEventValueChanged];
    self.oEveningSwitch.onTintColor = [UIColor whiteColor];
    self.oEveningSwitch.thumbTintColor = [UIColor redColor];
    [self addSubview: self.oEveningSwitch];
    
    self.oNightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(realSize.width -66.0, 312.0, 0.0, 0.0)];
    [self.oNightSwitch addTarget:self action:@selector(actionNightSw:) forControlEvents:UIControlEventValueChanged];
    self.oNightSwitch.onTintColor = [UIColor whiteColor];
    self.oNightSwitch.thumbTintColor = [UIColor redColor];
    [self addSubview: self.oNightSwitch];
 
    self.oJTypeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.oJTypeButton setFrame: CGRectMake(realSize.width-43.0, 18.0, 36.0, 36.0f)];
    [self.oJTypeButton addTarget:self action:@selector(actionJType:) forControlEvents:UIControlEventTouchUpInside];
    [self.oJTypeButton setImage:[UIImage imageNamed:@"detail_arrow_white.png"] forState:UIControlStateNormal];
    [self addSubview: self.oJTypeButton];
    
    self.oIndustryButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.oIndustryButton setFrame: CGRectMake(realSize.width-43.0, 78.0, 36.0, 36.0f)];
    [self.oIndustryButton addTarget:self action:@selector(actionIndustry:) forControlEvents:UIControlEventTouchUpInside];
    [self.oIndustryButton setImage:[UIImage imageNamed:@"detail_arrow_white.png"] forState:UIControlStateNormal];
    [self addSubview: self.oIndustryButton];
    
    self.oPlusButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.oPlusButton setFrame: CGRectMake(originX + 24.0, 352.0, 36.0, 36.0f)];
    [self.oPlusButton addTarget:self action:@selector(actionPlus:) forControlEvents:UIControlEventTouchUpInside];
    [self.oPlusButton setImage:[UIImage imageNamed:@"plus_white.png"] forState:UIControlStateNormal];
    [self addSubview: self.oPlusButton];
    
    self.oBinButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.oBinButton setFrame: CGRectMake(originX + 96.0, 352.0, 36.0, 36.0f)];
    [self.oBinButton addTarget:self action:@selector(actionBin:) forControlEvents:UIControlEventTouchUpInside];
    [self.oBinButton setImage:[UIImage imageNamed:@"empty_bin"] forState:UIControlStateNormal];
    [self addSubview: self.oBinButton];
}

- (void)actionPlus:(id)sender {
    [self.parent delegateHasSaved];
}

- (void)actionBin:(id)sender {
    [self.parent delegateHasCanceled];
}

- (void)actionJType:(id)sender {
    [self.parent delegateAddJobType:sender];
}

- (void)actionIndustry:(id)sender {
    [self.parent delegateAddIndustry:sender];
}

- (void)actionMorningSw:(id)sender {
//    NSLog(@"active %d", self.oMorningSwitch.on);
}

- (void)actionAfternoonSw:(id)sender {
}

- (void)actionEveningSw:(id)sender {
}

- (void)actionNightSw:(id)sender {
}

@end
