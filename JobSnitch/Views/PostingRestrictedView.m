//
//  PostingRestrictedView.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingRestrictedView.h"
@interface PostingRestrictedView ()
@property (nonatomic, strong)   UITapGestureRecognizer *expandTapRecognizer;

@end

@implementation PostingRestrictedView

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
    CGFloat centerY = realSize.height*0.5;
    
    self.oBackgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 0, realWidth, realSize.height)];
    self.oBackgroundImg.image = [UIImage imageNamed:@"posting_compr_back_active"];
    [self addSubview:self.oBackgroundImg];
    
//    self.oWavesImage = [[UIImageView alloc] initWithFrame:CGRectMake(realWidth*0.04 + originX, centerY - 45.0*0.5 - 2.0, 45.0, 45.0)];
//    self.oWavesImage.image = [UIImage imageNamed:@"radio_waves_strong"];
//    [self addSubview:self.oWavesImage];

    self.oWavesButton = [JSEditPostingButton buttonWithType: UIButtonTypeCustom];
    [self.oWavesButton setFrame:CGRectMake(realWidth*0.04 + originX, centerY - 45.0*0.5 - 2.0, 45.0, 45.0)];
    [self.oWavesButton addTarget:self action:@selector(actionBroadcast:) forControlEvents:UIControlEventTouchUpInside];
    [self.oWavesButton setImage:[UIImage imageNamed:@"radio_waves_strong"] forState:UIControlStateNormal];
    [self addSubview: self.oWavesButton];

    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Black" size:15],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *text2Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *text3Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:15],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};

    self.oTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(realWidth*0.2 + originX, centerY - 26.0*0.5 - 10.0, realWidth*0.3, 26.0)];
    [self.oTitleLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"Name" attributes:text1Attribute]];
    [self addSubview:self.oTitleLabel];

    self.oDescrLabel = [[UILabel alloc] initWithFrame:CGRectMake(realWidth*0.2 + originX, centerY - 25.0*0.5 + 10.0, realWidth*0.3, 25.0)];
    [self.oDescrLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"Descr" attributes:text2Attribute]];
    [self addSubview:self.oDescrLabel];

    self.oShortLabel = [[UILabel alloc] initWithFrame:CGRectMake(realWidth*0.52 + originX, centerY - 26.0*0.5,  27.0, 26.0)];
    [self.oShortLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"0" attributes:text3Attribute]];
    [self addSubview:self.oShortLabel];
    
    self.oApplicLabel = [[UILabel alloc] initWithFrame:CGRectMake(realWidth*0.68 + originX, centerY - 26.0*0.5,  27.0, 26.0)];
    [self.oApplicLabel setAttributedText:[[NSAttributedString alloc] initWithString:@"0" attributes:text3Attribute]];
    [self addSubview:self.oApplicLabel];
    
    self.oFolderImage = [[UIImageView alloc] initWithFrame:CGRectMake(realWidth*0.58 + originX, centerY - 21.0*0.5, 27.0, 21.0)];
    self.oFolderImage.image = [UIImage imageNamed:@"folder_active"];
    [self addSubview:self.oFolderImage];
    
    self.oCurvedButton = [JSEditPostingButton buttonWithType: UIButtonTypeCustom];
    [self.oCurvedButton setFrame:CGRectMake(realWidth*0.74 + originX, centerY - 32.0*0.5, 32.0, 32.0)];
    [self.oCurvedButton addTarget:self action:@selector(actionApplications:) forControlEvents:UIControlEventTouchUpInside];
    [self.oCurvedButton setImage:[UIImage imageNamed:@"curved_arrow"] forState:UIControlStateNormal];
    [self addSubview: self.oCurvedButton];
    
    self.oExpandButton = [JSEditPostingButton buttonWithType: UIButtonTypeCustom];
    [self.oExpandButton setFrame:CGRectMake(realWidth*0.84 + originX, centerY - 40.0*0.5, 40.0, 40.0)];
    [self.oExpandButton addTarget:self action:@selector(actionExpand:) forControlEvents:UIControlEventTouchUpInside];
    [self.oExpandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
    [self addSubview: self.oExpandButton];
    
}

- (void)actionExpand:(id)sender {
    [self.parent delegateExpandPosting:sender];
}

- (void)actionApplications:(id)sender {
    [self.parent delegateApplications:sender];
}

- (void)actionBroadcast:(id)sender {
    [self.parent delegateBroadcast:sender];
}

-(void) postData: (PostingRecord *)currPosting {
    NSDictionary *text1Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Black" size:15],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *text2Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:12],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *text3Attribute = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Bold" size:15],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.oTitleLabel setAttributedText:[[NSAttributedString alloc] initWithString:currPosting.title attributes:text1Attribute]];
    [self.oDescrLabel setAttributedText:[[NSAttributedString alloc] initWithString:currPosting.descrption attributes:text2Attribute]];
    [self.oShortLabel setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", currPosting.noShortlisted]
                                                                        attributes:text3Attribute]];
    [self.oApplicLabel setAttributedText:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", currPosting.noApplications]
                                                                        attributes:text3Attribute]];
    self.oExpandButton.currPosting = currPosting;
    self.oCurvedButton.currPosting = currPosting;
    [self.oExpandButton setImage:[UIImage imageNamed:@"expand_arrow"] forState:UIControlStateNormal];
    
    if ([self.oApplicLabel.text isEqualToString:@"0"]) {
        self.oShortLabel.hidden = TRUE;
        self.oFolderImage.hidden = TRUE;
        self.alpha = 0.6;
    } else {
        self.oShortLabel.hidden = FALSE;
        self.oFolderImage.hidden = FALSE;
        self.alpha = 1.0;
        if ([self.oShortLabel.text isEqualToString:@"0"]) {
            self.oShortLabel.alpha = 0.6;
            self.oFolderImage.alpha = 0.6;
        } else {
            self.oShortLabel.alpha = 1;
            self.oFolderImage.alpha = 1;
        }
    }
    
}



@end
