//
//  HomeCenterView.m
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "HomeCenterView.h"

@implementation HomeCenterView

- (IBAction)actionAbout:(id)sender {
    [self.delegate delegateShowAbout];
}

- (IBAction)actionContact:(id)sender {
    [self.delegate delegateShowContact];
}

- (IBAction)actionBug:(id)sender {
    [self.delegate delegateShowBugRep];
}

@end
