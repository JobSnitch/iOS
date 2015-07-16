//
//  PostingRestrictedView.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSEditPostingButton.h"
#import "EmployerFirstParent.h"
#import "PostingRecord.h"

@interface PostingRestrictedView : UIView
@property (strong, nonatomic)   UIImageView *oBackgroundImg;
@property (strong, nonatomic)   JSEditPostingButton *oWavesButton;
@property (strong, nonatomic)   UILabel *oTitleLabel;
@property (strong, nonatomic)   UILabel *oShortLabel;
@property (strong, nonatomic)   UILabel *oApplicLabel;
@property (strong, nonatomic)   UILabel *oDescrLabel;
@property (strong, nonatomic)   UIImageView *oFolderImage;
@property (strong, nonatomic)   JSEditPostingButton *oExpandButton;
@property (strong, nonatomic)   JSEditPostingButton *oCurvedButton;

@property (assign) id<EmployerFirstParent> parent;         // the parent controller implements this

-(void) postData: (PostingRecord *)currPosting;
@end
