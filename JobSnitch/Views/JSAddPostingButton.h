//
//  JSAddPostingButton.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessRecord.h"

@interface JSAddPostingButton : UIButton
@property (weak, nonatomic) BusinessRecord *currBusiness;

@end
