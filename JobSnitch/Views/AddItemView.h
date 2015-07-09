//
//  AddItemView.h
//  JobSnitch
//
//  Created by Andrei Sava on 08/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddItemParent <NSObject>
-(void) delegateHasAdded;

@end

@interface AddItemView : UIView

@property (weak, nonatomic) IBOutlet UITextField *oTextField;
@property (weak, nonatomic) IBOutlet UIButton *oArrowButton;

@property (assign) id<AddItemParent> parent;         // the parent controller implements this

-(void) setupFields:(id) sender;
@end
