//
//  BusinessRestrictedView.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BusinessRestrictedView.h"

@implementation BusinessRestrictedView

-(void) layoutFields: (CGSize) realSize {
    [self.oBusinessImage setFrame:CGRectMake(8, 8, self.oBusinessImage.bounds.size.width, self.oBusinessImage.bounds.size.height)];
    [self.oNameLabel setFrame:CGRectMake(50, 4, realSize.width-50.0, self.oNameLabel.bounds.size.height)];
    [self.oAddressLabel setFrame:CGRectMake(50, 24, realSize.width-50.0, self.oAddressLabel.bounds.size.height)];
}

@end
