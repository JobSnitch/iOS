//
//  EmployerFirstView.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployerFirstView.h"

@implementation EmployerFirstView

-(void) layoutFields: (CGSize) realSize {
    CGPoint centerImage = CGPointMake(self.center.x, self.oTopImage.center.y);
    self.oTopImage.center = centerImage;
    CGPoint centerName = CGPointMake(self.center.x, self.oNameLabel.center.y);
    self.oNameLabel.center = centerName;
    CGRect scrollFrame = CGRectMake(0.0, 110.0,
                                    self.bounds.size.width, self.bounds.size.height - 110.0 -49.0);
    [self.oScrollView setFrame:scrollFrame];

}

@end
