//
//  BaseJSViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseJSViewController : UIViewController
@property (nonatomic, strong) UIImageView *backgroundGradient;

-(void) initBackground;
@end
