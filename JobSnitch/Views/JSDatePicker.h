//
//  JSDatePicker.h
//  JobSnitch
//
//  Created by Andrei Sava on 20/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MyJSDatePickerToolbarHeight 44

@interface JSDatePicker : UIView {
}

@property (nonatomic, assign, readonly) UIDatePicker *picker;
@property (nonatomic) CGFloat viewHeight;

- (void) setMode: (UIDatePickerMode) mode;
- (void) addTargetForDoneButton: (id) target action: (SEL) action;
- (void) addTargetForCancelButton: (id) target action: (SEL) action;

@end

