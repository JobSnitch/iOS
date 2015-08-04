//
//  ApplicationsViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "ApplicationsViewController.h"
#import "BusinessRestrictedView.h"
#import "ApplicationCollectViewCell.h"
#import "ApplicationRecord.h"
#import "TextApplPopupView.h"
#import "ContactPopupView.h"
@import MessageUI;
@import MediaPlayer;
@import AVFoundation;

@interface ApplicationsViewController () <ApplicationCellDelegate, ContactPopupDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,
                                                AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
}
@property (weak, nonatomic) IBOutlet UIImageView *oSmallImage;
@property (weak, nonatomic) IBOutlet UILabel *oEmployerName;
@property (weak, nonatomic) IBOutlet UIView *oBusinessView;
@property (weak, nonatomic) IBOutlet UILabel *oJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *oJobDescript;
@property (nonatomic, weak) IBOutlet UICollectionView *oCollectionView;

@property (nonatomic, strong)   NSMutableArray *applications;
@property (nonatomic)   int     currentIndex;

@property (nonatomic, strong)   TextApplPopupView *popupTextView;
@property (nonatomic, strong)   ContactPopupView *popupContactView;

@end

@implementation ApplicationsViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    self.popupTextView = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    if (player.playing) {
        [player stop];
    }
}
#pragma mark - data
-(void) prepareData {
    self.applications = [[NSMutableArray alloc] init];
    for (int i=0; i< self.currPosting.noApplications; i++) {
        ApplicationRecord *newAppl = [[ApplicationRecord alloc] init];
        newAppl.name = [NSString stringWithFormat:@"Name %d", i+1];
        newAppl.phoneNumber = [NSString stringWithFormat:@"%d%d%d", i+1, i+1, i+1];
        newAppl.email = [NSString stringWithFormat:@"yourmail%d@mail.com", i+1];
        newAppl.applPreference = (ApplicationPreferences) (random() %3);
        [self.applications addObject:newAppl];
    }
}

#pragma mark - interface

-(void) setupFields {
    [self setupHeader];
    [self setupBusinessViewFor:self.currBusiness];
    [self setupJob];
    [self setupCollection];
}

-(void) setupHeader {
    self.oEmployerName.text = self.currentEmployer.name;
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.oSmallImage.image = avatarImage;
    }
}

-(void) setupBusinessViewFor:(BusinessRecord *)currBusiness {
    CGRect topFrame = CGRectMake(0, 0,
                                 self.oBusinessView.bounds.size.width, self.oBusinessView.bounds.size.height);
    BusinessRestrictedView *currView = nil;
    currView = [[[NSBundle mainBundle] loadNibNamed:@"BusinessRestrictedView" owner:self options:nil] objectAtIndex:0];
    [currView setFrame:topFrame];
    currView.oNameLabel.text = currBusiness.name;
    currView.oAddressLabel.text = currBusiness.address;
    currView.oBusinessImage.image = [UIImage imageNamed:currBusiness.imageName];
    [self.oBusinessView addSubview:currView];
}

-(void) setupJob {
    self.oJobTitle.text = self.currPosting.title;
    self.oJobDescript.text = self.currPosting.descrption;
}

-(void) setupCollection {
    self.oCollectionView.delegate = self;
    self.oCollectionView.dataSource = self;
    [self.oCollectionView registerClass:[ApplicationCollectViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(self.view.bounds.size.width * 353.0/414.0 , self.view.bounds.size.height - 164.0)];

//    [self.oCollectionView setPagingEnabled:YES];
    [self.oCollectionView setCollectionViewLayout:flowLayout];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.applications ) {
        return self.applications.count;
    } else {
        return 0;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat inset = self.view.bounds.size.width * (1.0 - 353.0/414.0)*0.5;
    return UIEdgeInsetsMake(0, inset, 0, inset);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = self.view.bounds.size.width * (1.0 - 353.0/414.0)*0.5;

    return spacing;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ApplicationCollectViewCell *cell = (ApplicationCollectViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    if (indexPath.row < self.applications.count) {
        cell.delegate = self;
        ApplicationRecord *currAppl = self.applications[indexPath.row];
        cell.oNameLabel.text = currAppl.name;
        cell.oCurrentLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)indexPath.row+1, (unsigned long)self.applications.count];
        switch (currAppl.applPreference) {
            case prefText:
                cell.oTextButton.enabled = TRUE;
                cell.oAudioButton.enabled = FALSE;
                cell.oCameraButton.enabled = FALSE;
                break;
            case prefAudio:
                cell.oTextButton.enabled = FALSE;
                cell.oAudioButton.enabled = TRUE;
                cell.oCameraButton.enabled = FALSE;
                break;
            case prefVideo:
                cell.oTextButton.enabled = FALSE;
                cell.oAudioButton.enabled = FALSE;
                cell.oCameraButton.enabled = TRUE;
                break;
            default:
                break;
        }
    }
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int sum = 0;
    for (UICollectionViewCell *cell in [self.oCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.oCollectionView indexPathForCell:cell];
        sum+= indexPath.row;
    }
    double currIndex = (double)sum/(double)[self.oCollectionView visibleCells].count;
    self.currentIndex = round(currIndex);
    
    [self goToIndex];
}

#pragma mark - actions
- (IBAction)actionBack:(id)sender {
    [self.delegate hasFinishedApplications];
}

-(void) delegateLeft {
    if (self.currentIndex > 0) {
        self.currentIndex--;
        [self goToIndex];
    }
}

-(void) delegateRight {
    if (self.currentIndex < self.applications.count-1) {
        self.currentIndex++;
        [self goToIndex];
    }
}

-(void) goToIndex {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    [self.oCollectionView scrollToItemAtIndexPath:indexPath
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:YES];
}

#pragma mark - ApplicationCellDelegate
-(void) delegateText:(id)sender {
    if (self.popupTextView) {
        [self.popupTextView removeFromSuperview];
        self.popupTextView = nil;
    } else {
        CGFloat startY = ((UIView *)sender).frame.size.height *0.5;
        startY += ((UIView *)sender).superview.frame.origin.y;
        startY -= 240.0;
        CGRect topFrame = CGRectMake(0, startY,
                                     self.view.bounds.size.width, 240.0);
        self.popupTextView = [[[NSBundle mainBundle] loadNibNamed:@"TextApplPopupView" owner:self options:nil] objectAtIndex:0];
        [self.popupTextView setFrame:topFrame];
        [self.view addSubview:self.popupTextView];
        [self.popupTextView setupContent];
    }
}

-(void) delegateAudio {
    if (player) {
        if (player.playing) {
            [player stop];
        } else {        // paused
            [player play];
        }
    } else {
        [self playAudio:@"JSAudio.m4a"];
    }
}

-(void) delegateVideo {
//    [self playVideo:@"JSMovie.MOV"];
    [self playVideo:@"JSMovie.mp4"];
}

-(void) delegateDelete{
    NSUInteger i = self.currentIndex;
    
    [self.oCollectionView performBatchUpdates:^{
        [self.applications removeObjectAtIndex:i];
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:i inSection:0];
        [self.oCollectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } completion:^(BOOL finished) {
    }];
}

-(void) delegateFolder {
    
}

-(void) delegateCheck {
    if (self.popupContactView) {
        [self.popupContactView removeFromSuperview];
        self.popupContactView = nil;
    } else {
        CGFloat startY = self.oCollectionView.frame.size.height *0.8;
        startY += self.oCollectionView.frame.origin.y;
        startY -= 174.0;
        CGRect topFrame = CGRectMake(0, startY, self.view.bounds.size.width, 174.0);
        self.popupContactView = [[[NSBundle mainBundle] loadNibNamed:@"ContactPopupView" owner:self options:nil] objectAtIndex:0];
        [self.popupContactView setFrame:topFrame];
        self.popupContactView.delegate = self;
        [self.view addSubview:self.popupContactView];
    }
}
#pragma mark - ContactPopupDelegate
-(void) delegatePhone:(id)sender {
    NSString *telNo;
//    if (self.currSeeker && self.currSeeker.phone) {
//        telNo = self.currSeeker.phone;
//    } else
    {
        telNo = @"0701-010101";
    }
    NSString *phoneNumber = [@"tel://" stringByAppendingString:telNo];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void) delegateMessages:(id)sender {
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                               message:@"Your device doesn't support SMS!"
                                                              delegate:nil cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *toRecipients;
//    if (self.currSeeker && self.currSeeker.sms) {
//        toRecipients = [NSArray arrayWithObject:self.currSeeker.sms];
//    } else
    {
        toRecipients = [NSArray arrayWithObject:@"0701-010101"];
    }
    //    NSString *message = [NSString stringWithFormat:@"message"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:toRecipients];
    //    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void) delegateEmail:(id)sender {
    // Email Subject
    NSString *emailDate = [[NSString stringWithFormat:@"%@", [NSDate date]] substringWithRange:NSMakeRange(0, 10) ];
    NSString *emailTitle = [NSString stringWithFormat:@"%@ %@", @"contact request JobSnitch at %@", emailDate];
    // Email Content
    //    NSString *messageBody = @"emailtext";
    // To address
    NSArray *toRecipients;
//    if (self.currSeeker && self.currSeeker.email) {
//        toRecipients = [NSArray arrayWithObject:self.currSeeker.email];
//    } else
    {
        toRecipients = [NSArray arrayWithObject:@"youremail@mail.com"];
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    //    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipients];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
        {
            NSLog(@"Failed to send SMS!");
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    // Close the SMS Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - videoplay
-(void) playVideo:(NSString *)filename {
    NSString *videoName = filename;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *videoPath = [documentsDir stringByAppendingPathComponent:videoName];
    
    NSURL * videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController* theMovie = [[MPMoviePlayerViewController alloc] initWithContentURL: videoURL];
    [self presentMoviePlayerViewControllerAnimated:theMovie];
    
    // Register for the playback finished notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myVideoFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:theMovie.moviePlayer];
}

// playback finished handler for MPMoviePlayerPlaybackDidFinishNotification
-(void) myVideoFinishedCallback: (NSNotification*) aNotification
{
    MPMoviePlayerController* theMovie = [aNotification object];
        [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: MPMoviePlayerPlaybackDidFinishNotification
                                                  object: theMovie];
}

#pragma mark - audio play
-(void) playAudio:(NSString *)filename {
    NSString *audioName = filename;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *audioPath = [documentsDir stringByAppendingPathComponent:audioName];
    
    NSURL *inputFileURL = [NSURL fileURLWithPath:audioPath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:inputFileURL error:nil];
    if (player) {
        [player setDelegate:self];
    }
    [player play];
}

#pragma mark - AVAudioPlayerDelegate
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
}


#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
