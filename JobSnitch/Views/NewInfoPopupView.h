//
//  NewInfoPopupView.h
//  JobSnitch
//
//  Created by Andrei Sava on 09/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewInfoPopupParent.h"

@interface NewInfoPopupView : UIView  <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *oTextView;
@property (weak, nonatomic) IBOutlet UILabel *oTitleLabel;

@property (assign) id<NewInfoPopupParent> parent;         // the parent controller implements this

@end
