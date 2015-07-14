//
//  TextApplPopupView.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "TextApplPopupView.h"

@implementation TextApplPopupView

-(void) setupContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"resume.pages" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self loadFromURL:url];
}

-(void) loadFromURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.oWebView loadRequest:request];
    self.oWebView.scalesPageToFit=YES;
}
@end
