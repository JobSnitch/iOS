//
//  ApplicationCollectViewCell.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ApplicationCellDelegate <NSObject>
-(void) delegateLeft;
-(void) delegateRight;
-(void) delegateText:(id)sender;
-(void) delegateAudio;
-(void) delegateVideo;
-(void) delegateDelete;
-(void) delegateFolder;
-(void) delegateCheck;

@end


@interface ApplicationCollectViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *oBackgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *oCurrentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *oNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *oTextButton;
@property (weak, nonatomic) IBOutlet UIButton *oCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *oAudioButton;
@property (weak, nonatomic) IBOutlet UIButton *oFolderButton;
@property (weak, nonatomic) IBOutlet UIButton *oDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *oCheckButton;

@property (assign) id<ApplicationCellDelegate> delegate;     // the parent controller implements this

@end
