//
//  PostingCollectViewCell.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PostingCellDelegate <NSObject>
-(void) delegateLeft;
-(void) delegateRight;
-(void) delegateText:(id)sender;
-(void) delegateAudio;
-(void) delegateVideo;

@end


@interface PostingCollectViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *oBackgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *oCurrentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *oTextButton;
@property (weak, nonatomic) IBOutlet UIButton *oCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *oAudioButton;
@property (weak, nonatomic) IBOutlet UILabel *oBusinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *oAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *oDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oImgVertConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oBusinessVertConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oNameVertConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oLowerVwVertConstraint;
@property (weak, nonatomic) IBOutlet UIView *oIntermView;
@property (weak, nonatomic) IBOutlet UIButton *oLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *oRightButton;

@property (assign) id<PostingCellDelegate> delegate;     // the parent controller implements this

@end
