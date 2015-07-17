//
//  HomeViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
#import "HomeDelegate.h"

@interface HomeViewController : BaseJSViewController <HomeDelegate, UITextFieldDelegate>

-(void) doWhenInternetIsPresent;
@end
