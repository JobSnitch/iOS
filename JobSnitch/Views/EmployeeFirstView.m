//
//  EmployeeFirstView.m
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeeFirstView.h"

@implementation EmployeeFirstView

-(void) layoutFields: (CGSize) realSize {
    CGPoint centerImage = CGPointMake(realSize.width*0.5, 48.0);
    self.oTopImage.center = centerImage;
    CGPoint centerName = CGPointMake(realSize.width*0.5, 92.0);
    self.oNameLabel.center = centerName;

}

@end
