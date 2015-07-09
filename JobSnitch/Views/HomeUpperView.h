//
//  HomeUpperView.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 Andrei Sava. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDelegate.h"

@interface HomeUpperView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oAccountTopConstraint;

@property (assign) id<HomeDelegate> delegate;         // the parent controller implements this

@end
