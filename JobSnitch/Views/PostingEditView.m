//
//  PostingEditView.m
//  JobSnitch
//
//  Created by Andrei Sava on 11/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingEditView.h"

@implementation PostingEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGSize siz = CGSizeMake(frame.size.width, frame.size.height);
        [self layoutFields:siz];
    }
    
    return self;
}


-(void) layoutFields: (CGSize) realSize{
    CGFloat originX = 14.0;
    CGFloat realWidth = realSize.width - originX;
    
    self.oBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, realWidth, realSize.height)];
    self.oBackImage.image = [UIImage imageNamed:@"posting_edit_back.png"];
    [self addSubview:self.oBackImage];
    
    [super layoutFields:realSize offsetY:59.0];
}

-(void) fillFields {
    [self.oBinButton setImage:[UIImage imageNamed:@"full_bin"] forState:UIControlStateNormal];
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:14],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *text2Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    if (self.currPosting.title && ![self.currPosting.title isEqual:[NSNull null]]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.currPosting.title attributes:text1Attribute];
        [self.oJTitleText setAttributedText:attributedText];
    } else {
        NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Job Title" attributes:text1Attribute];
        [self.oJTitleText setAttributedPlaceholder:attributedPlaceholder];
    }
    
    if (self.currPosting.descrption && ![self.currPosting.descrption isEqual:[NSNull null]]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.currPosting.descrption attributes:text2Attribute];
        [self.oDescriptionText setAttributedText:attributedText];
    }
    if (self.currPosting.JobCategoryName && ![self.currPosting.JobCategoryName isEqual:[NSNull null]]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.currPosting.JobCategoryName attributes:text1Attribute];
        [self.oJTypeLabel setAttributedText:attributedText];
    }
    if (self.currPosting.industry && ![self.currPosting.industry isEqual:[NSNull null]]) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.currPosting.industry attributes:text1Attribute];
        [self.oIndustryLabel setAttributedText:attributedText];
    }
    self.oMorningSwitch.on = self.currPosting.morningShift;
    self.oAfternoonSwitch.on = self.currPosting.afternoonShift;
    self.oEveningSwitch.on = self.currPosting.eveningShift;
    self.oNightSwitch.on = self.currPosting.nightShift;
}

@end
