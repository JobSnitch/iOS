//
//  JSCustomSegue.m
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "JSCustomSegue.h"

@implementation JSCustomSegue

-(void) perform {
    [[self sourceViewController] presentViewController:[self destinationViewController]
                                              animated:YES
                                            completion:nil];
    
}

@end
