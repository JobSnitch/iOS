//
//  HomeCenterView.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDelegate.h"

@interface HomeCenterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *oAboutButton;
@property (weak, nonatomic) IBOutlet UIButton *oContactButton;
@property (weak, nonatomic) IBOutlet UIButton *oBugButton;

@property (assign) id<HomeDelegate> delegate;         // the parent controller implements this

@end
