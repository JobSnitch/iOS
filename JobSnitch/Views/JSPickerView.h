//
//  JSPickerView.h
//  JobSnitch
//
//  Created by Andrei Sava on 09/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JSPickerToolbarHeight 44

@interface JSPickerView : UIView

@property (nonatomic, assign, readonly) UIPickerView *picker;

- (void) addTargetForDoneButton: (id) target action: (SEL) action;
- (void) addTargetForCancelButton: (id) target action: (SEL) action;

@end
