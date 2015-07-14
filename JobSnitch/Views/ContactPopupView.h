//
//  ContactPopupView.h
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContactPopupDelegate <NSObject>
-(void) delegatePhone:(id)sender;
-(void) delegateMessages:(id)sender;
-(void) delegateEmail:(id)sender;

@end

@interface ContactPopupView : UIView
@property (weak, nonatomic) IBOutlet UIButton *oPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *oMessagesButton;
@property (weak, nonatomic) IBOutlet UIButton *oEmailButton;

@property (assign) id<ContactPopupDelegate> delegate;     // the parent controller implements this

@end
