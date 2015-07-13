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

-(void) layoutFields: (CGSize) realSize{
//    CGFloat fraction = realSize.height/78.0;
//    CGFloat realWidth = 401.0 * fraction;
    CGFloat originX = 14.0;
    CGFloat realWidth = realSize.width - originX;
    [self.oBackgroundImg setFrame:CGRectMake(originX, 0, realWidth, realSize.height)];
    CGFloat centerY = realSize.height*0.5;
    [self.oWavesImage setFrame:CGRectMake(realWidth*0.04 + originX, centerY - self.oWavesImage.frame.size.height*0.5 - 2.0,
                                          self.oWavesImage.frame.size.width, self.oWavesImage.frame.size.height)];
    [self.oTitleLabel setFrame:CGRectMake(realWidth*0.2 + originX, centerY - self.oTitleLabel.frame.size.height*0.5 - 10.0,
                                          realWidth*0.3, self.oTitleLabel.frame.size.height)];
    [self.oDescrLabel setFrame:CGRectMake(realWidth*0.2 + originX, centerY - self.oDescrLabel.frame.size.height*0.5 + 10.0,
                                          realWidth*0.3, self.oDescrLabel.frame.size.height)];
    [self.oShortLabel setFrame:CGRectMake(realWidth*0.52 + originX, centerY - self.oShortLabel.frame.size.height*0.5,
                                          self.oShortLabel.frame.size.width, self.oShortLabel.frame.size.height)];
    [self.oFolderImage setFrame:CGRectMake(realWidth*0.58 + originX, centerY - self.oFolderImage.frame.size.height*0.5,
                                          self.oFolderImage.frame.size.width, self.oFolderImage.frame.size.height)];
    [self.oApplicLabel setFrame:CGRectMake(realWidth*0.68 + originX, centerY - self.oApplicLabel.frame.size.height*0.5,
                                          self.oApplicLabel.frame.size.width, self.oApplicLabel.frame.size.height)];
//    [self.oCurvedImage setFrame:CGRectMake(realWidth*0.74 + originX, centerY - self.oCurvedImage.frame.size.height*0.5,
//                                           self.oCurvedImage.frame.size.width, self.oCurvedImage.frame.size.height)];
    [self.oCurvedButton setFrame:CGRectMake(realWidth*0.74 + originX, centerY - self.oCurvedButton.frame.size.height*0.5,
                                           self.oCurvedButton.frame.size.width, self.oCurvedButton.frame.size.height)];
    [self.oExpandButton setFrame:CGRectMake(realWidth*0.84 + originX, centerY - self.oExpandButton.frame.size.height*0.5,
                                            self.oExpandButton.frame.size.width, self.oExpandButton.frame.size.height)];
}

- (IBAction)actionExpand:(id)sender {
    [self.parent delegateExpandPosting:sender];
}

- (IBAction)actionApplications:(id)sender {
    [self.parent delegateApplications:sender];
}

-(void) postData {
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
