//
//  JSCustomUnwindSegue.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "JSCustomUnwindSegue.h"

@implementation JSCustomUnwindSegue

-(void) perform {
    UIViewController *sourceViewController = self.sourceViewController;
    //    UIViewController *destinationViewController = self.destinationViewController;
    
    [sourceViewController dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
    
}

@end
