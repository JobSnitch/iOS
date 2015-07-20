//
//  JSDatePicker.m
//  JobSnitch
//
//  Created by Andrei Sava on 20/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "JSDatePicker.h"

@interface JSDatePicker()

@property (nonatomic, assign, readwrite) UIDatePicker *picker;

@property (nonatomic, assign) id doneTarget;
@property (nonatomic, assign) id cancelTarget;
@property (nonatomic, assign) SEL doneSelector;
@property (nonatomic, assign) SEL cancelSelector;

@end


@implementation JSDatePicker

@synthesize picker = _picker;

@synthesize doneTarget = _doneTarget;
@synthesize cancelTarget = _cancelTarget;
@synthesize doneSelector = _doneSelector;
@synthesize cancelSelector = _cancelSelector;

- (id) initWithFrame: (CGRect) frame {
    if ((self = [super initWithFrame: frame])) {
        self.backgroundColor = [UIColor clearColor];
        
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, MyJSDatePickerToolbarHeight, frame.size.width,
                                                                               frame.size.height - MyJSDatePickerToolbarHeight)];
        picker.backgroundColor = [UIColor whiteColor];
        [self addSubview: picker];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, MyJSDatePickerToolbarHeight)];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.translucent = YES;
        toolbar.barTintColor = [UIColor redColor];
        
        NSDictionary* barButtonItemAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Lato-Bold" size:17.0f],
                                                  NSForegroundColorAttributeName:[UIColor whiteColor]
                                                  };
        UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixed.width = 15.0;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self
                                                                      action: @selector(doneDatePressed)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle: @"Cancel" style: UIBarButtonItemStyleBordered target: self
                                                                        action: @selector(cancelDatePressed)];
        [[UIBarButtonItem appearance] setTitleTextAttributes: barButtonItemAttributes forState:UIControlStateNormal];
        
        toolbar.items = [NSArray arrayWithObjects:fixed, cancelButton, flexibleSpace, doneButton, fixed, nil];
        
        [self addSubview: toolbar];
        
        self.picker = picker;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void) setMode: (UIDatePickerMode) mode {
    self.picker.datePickerMode = mode;
}

- (void) doneDatePressed {
    if (self.doneTarget) {
        [self.doneTarget performSelector:self.doneSelector withObject:nil afterDelay:0];
    }
}

- (void) cancelDatePressed {
    if (self.cancelTarget) {
        [self.cancelTarget performSelector:self.cancelSelector withObject:nil afterDelay:0];
    }
}

- (void) addTargetForDoneButton: (id) target action: (SEL) action {
    self.doneTarget = target;
    self.doneSelector = action;
}

- (void) addTargetForCancelButton: (id) target action: (SEL) action {
    self.cancelTarget=target;
    self.cancelSelector=action;
}

@end
