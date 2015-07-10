//
//  PostingRestrictedView.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostingRestrictedView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *oBackgroundImg;
@property (weak, nonatomic) IBOutlet UIImageView *oWavesImage;
@property (weak, nonatomic) IBOutlet UILabel *oTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oShortLabel;
@property (weak, nonatomic) IBOutlet UILabel *oApplicLabel;
@property (weak, nonatomic) IBOutlet UILabel *oDescrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oFolderImage;
@property (weak, nonatomic) IBOutlet UIImageView *oCurvedImage;
@property (weak, nonatomic) IBOutlet UIButton *oExpandButton;
//@property (weak, nonatomic) IBOutlet UIImageView *oExpandImage;

-(void) layoutFields: (CGSize) realSize;
-(void) postData;
@end
