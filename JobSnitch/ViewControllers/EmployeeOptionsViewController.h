//
//  EmployeeOptionsViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
#import "EmployeeTabBarDelegate.h"

@interface EmployeeOptionsViewController : BaseJSViewController

@property (assign) id<EmployeeTabBarDelegate> parent;

@end
