//
//  EmployeePostingViewController.m
//  JobSnitch
//
//  Created by Andrei Sava on 15/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "EmployeePostingViewController.h"
#import "BusinessRestrictedView.h"
#import "PostingCollectViewCell.h"
#import "PostingRecord.h"
//#import "BusinessRecord.h"
#import "CompanyRecord.h"
#import "TextApplPopupView.h"
#import "ContactPopupView.h"
#import "JSSessionManager.h"

#import "DLSFTPConnection.h"
#import "DLSFTPRequest.h"
#import "DLSFTPUploadRequest.h"

@import MobileCoreServices;
@import AVFoundation;

@interface EmployeePostingViewController () <PostingCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;                          // the audio recorder
}
@property (weak, nonatomic) IBOutlet UIImageView *oSmallImage;
@property (weak, nonatomic) IBOutlet UILabel *oEmployeeName;
@property (nonatomic, weak) IBOutlet UICollectionView *oCollectionView;

@property (nonatomic, strong)   NSMutableArray *postings;
@property (nonatomic)   int     currentIndex;
@property (nonatomic, strong)   NSMutableArray *businesses;
@property (nonatomic, strong)   NSSet *companyIDs;

@property (strong, nonatomic)   NSString *movPath;
@property (strong, nonatomic)   NSString *mp4Path;
@property (strong, nonatomic)   AVAssetExportSession *exportSession;
@property (strong, nonatomic)   DLSFTPConnection *connection;
@property (nonatomic, strong)   DLSFTPRequest *request;
@end

@implementation EmployeePostingViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    [self prepareData];
    [self setupFields];

//    self.popupTextView = nil;
}

-(void) viewWillDisappear:(BOOL)animated {
    if (recorder.recording) {
        [recorder stop];
        [recorder deleteRecording];
    }
    [super viewWillDisappear:animated];
}
#pragma mark - data
-(void) prepareData {
    [self setupEmployee];
    [self getPostingsByUser:testUserID2];
//    self.postings = [[NSMutableArray alloc] init];
//    [self setupBusinessesFake];
}

//-(void) setupBusinessesFake {
//    self.businesses = [[NSMutableArray alloc] init];
//    
//    BusinessRecord *currBusiness = nil;
//    currBusiness = [[BusinessRecord alloc] init];
//    currBusiness.name = @"McDonald's 1";
//    currBusiness.address = @"1692 Rue Mont Royal, Montreal QC H2J 1Z5";
//    currBusiness.imageName = @"mcdonalds.png";
//    [self setupPostingsFor:currBusiness];
//    [self.businesses addObject:currBusiness];
//    
//    currBusiness = nil;
//    currBusiness = [[BusinessRecord alloc] init];
//    currBusiness.name = @"McDonald's 2";
//    currBusiness.address = @"2530 Rue Masson, Montreal QC H1Y 1V8";
//    currBusiness.imageName = @"mcdonalds.png";
//    [self setupPostingsFor:currBusiness];
//    [self.businesses addObject:currBusiness];
//    
//}
//
//-(void) setupPostingsFor:(BusinessRecord *)currBusiness {
//    if ([currBusiness.name isEqualToString:@"McDonald's 1"]) {
//        NSMutableArray *postings = [[NSMutableArray alloc] init];
//        
//        PostingRecord *currPosting = nil;
//        currPosting = [[PostingRecord alloc] init];
//        currPosting.title = @"CS Rep";
//        currPosting.descrption = @"Take orders, .....";
//        currPosting.noApplications = 23;
//        currPosting.noShortlisted = 5;
//        currPosting.morningShift = TRUE;
//        currPosting.nightShift = TRUE;
//        currPosting.wantsText = TRUE;
//        currPosting.wantsAudio = FALSE;
//        currPosting.wantsVideo = FALSE;
//        currPosting.ownerBusiness = currBusiness;
//        [postings addObject:currPosting];
//        [self.postings addObject:currPosting];
//        
//        currPosting = nil;
//        currPosting = [[PostingRecord alloc] init];
//        currPosting.title = @"Manager";
//        currPosting.descrption = @"Payroll, Training .....";
//        currPosting.noApplications = 0;
//        currPosting.noShortlisted = 0;
//        currPosting.eveningShift = TRUE;
//        currPosting.nightShift = TRUE;
//        currPosting.wantsText = FALSE;
//        currPosting.wantsAudio = TRUE;
//        currPosting.wantsVideo = FALSE;
//        currPosting.ownerBusiness = currBusiness;
//        [postings addObject:currPosting];
//        [self.postings addObject:currPosting];
//        currBusiness.postings = postings;
//    }
//    if ([currBusiness.name isEqualToString:@"McDonald's 2"]) {
//        NSMutableArray *postings = [[NSMutableArray alloc] init];
//        
//        PostingRecord *currPosting = nil;
//        currPosting = [[PostingRecord alloc] init];
//        currPosting.title = @"Asst. Manager";
//        currPosting.descrption = @"Scheduling, .....";
//        currPosting.noApplications = 4;
//        currPosting.noShortlisted = 0;
//        currPosting.afternoonShift = TRUE;
//        currPosting.wantsText = FALSE;
//        currPosting.wantsAudio = FALSE;
//        currPosting.wantsVideo = TRUE;
//        currPosting.ownerBusiness = currBusiness;
//        [postings addObject:currPosting];
//        [self.postings addObject:currPosting];
//        currBusiness.postings = postings;
//    }
//}

#pragma mark - interface

-(void) setupFields {
    [self setupHeader];
    [self setupCollection];
}

-(void) setupHeader {
    self.oEmployeeName.text = self.currentEmployee.name;
    UIImage *avatarImage = [self getAvatarPhoto];
    if (avatarImage) {
        self.oSmallImage.image = avatarImage;
    }
}

-(void) setupCollection {
    self.oCollectionView.delegate = self;
    self.oCollectionView.dataSource = self;
    [self.oCollectionView registerClass:[PostingCollectViewCell class] forCellWithReuseIdentifier:@"cellPIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(self.view.bounds.size.width * 353.0/414.0 , self.view.bounds.size.height-105.0)];

    [self.oCollectionView setCollectionViewLayout:flowLayout];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.postings ) {
        return self.postings.count;
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
    PostingCollectViewCell *cell = (PostingCollectViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellPIdentifier" forIndexPath:indexPath];
    if (indexPath.row < self.postings.count) {
        cell.delegate = self;
        PostingRecord *currPost = self.postings[indexPath.row];
        cell.oNameLabel.text = currPost.title;
        cell.oDescriptionLabel.text = currPost.descrption;
        cell.oCurrentLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)indexPath.row+1, (unsigned long)self.postings.count];
        // FOR TEST
//        cell.oTextButton.enabled = currPost.wantsText;
//        cell.oAudioButton.enabled = currPost.wantsAudio;
//        cell.oCameraButton.enabled = currPost.wantsVideo;
        cell.oTextButton.enabled = random()%2;
        cell.oAudioButton.enabled = random()%2;
        cell.oCameraButton.enabled = random()%2;
//        BusinessRecord *currBusiness = (BusinessRecord *)currPost.ownerBusiness;
        CompanyRecord *currBusiness = [self getBusiness:currPost.CompanyId];
        cell.oBusinessLabel.text = [NSString stringWithFormat:@"%@ %@ %@", currBusiness.NameEnglish, currBusiness.City, currBusiness.Province];
        cell.oAddressLabel.text = currPost.JobLocation;
        cell.oPhotoImage.image = [UIImage imageNamed:currBusiness.imageName];
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
//    [self.delegate hasFinishedApplications];
}

-(void) delegateLeft {
    if (self.currentIndex > 0) {
        self.currentIndex--;
        [self goToIndex];
    }
}

-(void) delegateRight {
    if (self.currentIndex < self.postings.count-1) {
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
}

#pragma mark - video
static bool isRecording = false;
-(void) delegateAudio {
    if (isRecording) {
        isRecording = !isRecording;
        if (recorder.recording) {
            [self finishedRecording];
        }
    } else {
        isRecording = !isRecording;
        if (!recorder.recording) {
            [self startRecording];
        }
    }
}

-(void) startRecording {
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"JSAudio.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    [session setActive:YES error:nil];
    // Start recording
    [recorder record];
}

- (void)finishedRecording {
    [recorder stop];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}


#pragma mark - video
-(void) delegateVideo {
    [self startVideoControllerFromViewController: self usingDelegate: self];
}

- (BOOL) startVideoControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if ((delegate == nil) || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum] == YES) {
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        cameraUI = nil;
        return NO;
    }
    cameraUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        NSURL *imagePickerURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSData *videoData = [NSData dataWithContentsOfURL:imagePickerURL];
        
        NSString *videoName = @"JSMovie.MOV";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        self.movPath = [documentsDir stringByAppendingPathComponent:videoName];
        
        [videoData writeToFile:self.movPath atomically:YES];
        
        [self exportToMp4];
    }
}

#pragma mark - export and upload
-(void) exportToMp4 {
    self.exportSession = nil;
    NSURL * mediaURL = [NSURL fileURLWithPath:self.movPath];
    AVAsset *videoAsset = [AVAsset assetWithURL:mediaURL];
    self.exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetPassthrough];
    
    NSString *videoName = @"JSMovie.mp4";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    self.mp4Path = [documentsDir stringByAppendingPathComponent:videoName];
    [self deleteFileAtPath:self.mp4Path];

    self.exportSession.outputFileType = AVFileTypeMPEG4;
    self.exportSession.outputURL = [NSURL fileURLWithPath:self.mp4Path];
    self.exportSession.shouldOptimizeForNetworkUse = YES;
    
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAssetExportSessionStatus status = self.exportSession.status;
            if (status == AVAssetExportSessionStatusCompleted) {
                [self uploadVideo];
            } else {
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                       message:@"Export to mp4 failed!"
                                                                      delegate:nil cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
        });
    }];

}

-(void) uploadVideo {
    [self connectToServer];
    [self deleteFileAtPath:self.movPath];
    self.exportSession = nil;
}

-(void) connectToServer {
    __weak EmployeePostingViewController *weakSelf = self;
    
    // make a connection object and attempt to connect
    self.connection = [[DLSFTPConnection alloc] initWithHostname:sftpHost
                                                            port:[sftpPort integerValue]
                                                        username:sftpUsername
                                                        password:sftpPass];
//    self.connection = connection;
    DLSFTPClientSuccessBlock successBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // login successful
            NSLog(@"success connect");
            [self uploadAndDisconnect];
        });
    };
    
    DLSFTPClientFailureBlock failureBlock = ^(NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.connection = nil;
            // login failure
            NSString *title = [NSString stringWithFormat:@"%@ Error: %ld", error.domain, (long)error.code];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        });
    };
    
    [self.connection connectWithSuccessBlock:successBlock
                           failureBlock:failureBlock];
}

-(void) uploadAndDisconnect {
    self.request = nil;
    __weak EmployeePostingViewController *weakSelf = self;
    __block UIBackgroundTaskIdentifier taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf.request cancel];
    }];
    
    DLSFTPClientFileTransferSuccessBlock successBlock = ^(DLSFTPFile *file, NSDate *startTime, NSDate *finishTime) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
            NSLog(@"success upload");
            [self.connection disconnect];
        });
    };
    
    DLSFTPClientFailureBlock failureBlock = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorString = [NSString stringWithFormat:@"Error %ld", (long)error.code];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorString
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [[UIApplication sharedApplication] endBackgroundTask:taskIdentifier];
            [self.connection disconnect];
        });
    };
    
    NSString *localFilename = [self.mp4Path lastPathComponent];
    NSString *remotePath = [sftpRemoteBase stringByAppendingPathComponent:localFilename];
    self.request = [[DLSFTPUploadRequest alloc] initWithRemotePath:remotePath
                                                         localPath:self.mp4Path
                                                      successBlock:successBlock
                                                      failureBlock:failureBlock
                                                     progressBlock:nil];
    [self.connection submitRequest:self.request];
}

#pragma mark - GetAllJobPosting
- (void) getPostingsByUser:(NSString *) userId {
    if (!userId || [userId isEqualToString:@""]) {
        return;
    }
    
    [[JSSessionManager sharedManager] getPostingsForUser:userId withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                self.postings = [[JSSessionManager sharedManager] processAllPostingsResults:results];
                if (self.postings && self.postings.count) {
                    [self getCompaniesInfo];
                }
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"GetAllJobPosting"];
        }
    }];
}

#pragma mark - get companies info
-(void) getCompaniesInfo {
    self.businesses = nil;
    self.businesses = [[NSMutableArray alloc] init];
    self.companyIDs = [NSSet setWithArray:[self.postings valueForKey:@"CompanyId"]];
    for (NSNumber * cid in self.companyIDs) {
        [self getCompanyProfile:[cid stringValue]];
    }
}

- (void) getCompanyProfile:(NSString *) compId {
    if (!compId || [compId isEqualToString:@""]) {
        return;
    }
    
    [[JSSessionManager sharedManager] getCompanyForId: compId withCompletion:^(NSDictionary *results, NSError *error) {
        if (results) {
            if ([[JSSessionManager sharedManager] checkResult:results]) {
                CompanyRecord *currentCompany = [[JSSessionManager sharedManager] processCompanyIdResults:results];
                [self.businesses addObject:currentCompany];
                currentCompany.imageName = @"mcdonalds.png";
                [self.oCollectionView reloadData];
            }
        } else {
            [[JSSessionManager sharedManager] firstLevelError:error forService:@"GetCompanyProfile"];
        }
    }];
}

-(CompanyRecord *) getBusiness: (NSString *) compId {
    NSInteger companyid = [compId integerValue];
    for (CompanyRecord *currentCompany in self.businesses) {
        NSInteger cid = currentCompany.CompanyId;
        if (cid == companyid) {
            return currentCompany;
        }
    }
    return nil;
}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
