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
#import "BusinessRecord.h"
#import "TextApplPopupView.h"
#import "ContactPopupView.h"

@interface EmployeePostingViewController () <PostingCellDelegate> 
@property (weak, nonatomic) IBOutlet UIImageView *oSmallImage;
@property (weak, nonatomic) IBOutlet UILabel *oEmployeeName;
@property (nonatomic, weak) IBOutlet UICollectionView *oCollectionView;

@property (nonatomic, strong)   NSMutableArray *postings;
@property (nonatomic)   int     currentIndex;
@property (nonatomic, strong)   NSMutableArray *businesses;

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


#pragma mark - data
-(void) prepareData {
    [self setupEmployee];

    self.postings = [[NSMutableArray alloc] init];
    [self setupBusinesses];
}

-(void) setupBusinesses {
    self.businesses = [[NSMutableArray alloc] init];
    
    BusinessRecord *currBusiness = nil;
    currBusiness = [[BusinessRecord alloc] init];
    currBusiness.name = @"McDonald's 1";
    currBusiness.address = @"1692 Rue Mont Royal, Montreal QC H2J 1Z5";
    currBusiness.imageName = @"mcdonalds.png";
    [self setupPostingsFor:currBusiness];
    [self.businesses addObject:currBusiness];
    
    currBusiness = nil;
    currBusiness = [[BusinessRecord alloc] init];
    currBusiness.name = @"McDonald's 2";
    currBusiness.address = @"2530 Rue Masson, Montreal QC H1Y 1V8";
    currBusiness.imageName = @"mcdonalds.png";
    [self setupPostingsFor:currBusiness];
    [self.businesses addObject:currBusiness];
    
}

-(void) setupPostingsFor:(BusinessRecord *)currBusiness {
    if ([currBusiness.name isEqualToString:@"McDonald's 1"]) {
        NSMutableArray *postings = [[NSMutableArray alloc] init];
        
        PostingRecord *currPosting = nil;
        currPosting = [[PostingRecord alloc] init];
        currPosting.title = @"CS Rep";
        currPosting.descrption = @"Take orders, .....";
        currPosting.noApplications = 23;
        currPosting.noShortlisted = 5;
        currPosting.morningShift = TRUE;
        currPosting.nightShift = TRUE;
        currPosting.wantsText = TRUE;
        currPosting.wantsAudio = FALSE;
        currPosting.wantsVideo = FALSE;
        currPosting.ownerBusiness = currBusiness;
        [postings addObject:currPosting];
        [self.postings addObject:currPosting];
        
        currPosting = nil;
        currPosting = [[PostingRecord alloc] init];
        currPosting.title = @"Manager";
        currPosting.descrption = @"Payroll, Training .....";
        currPosting.noApplications = 0;
        currPosting.noShortlisted = 0;
        currPosting.eveningShift = TRUE;
        currPosting.nightShift = TRUE;
        currPosting.wantsText = FALSE;
        currPosting.wantsAudio = TRUE;
        currPosting.wantsVideo = FALSE;
        currPosting.ownerBusiness = currBusiness;
        [postings addObject:currPosting];
        [self.postings addObject:currPosting];
        currBusiness.postings = postings;
    }
    if ([currBusiness.name isEqualToString:@"McDonald's 2"]) {
        NSMutableArray *postings = [[NSMutableArray alloc] init];
        
        PostingRecord *currPosting = nil;
        currPosting = [[PostingRecord alloc] init];
        currPosting.title = @"Asst. Manager";
        currPosting.descrption = @"Scheduling, .....";
        currPosting.noApplications = 4;
        currPosting.noShortlisted = 0;
        currPosting.afternoonShift = TRUE;
        currPosting.wantsText = FALSE;
        currPosting.wantsAudio = FALSE;
        currPosting.wantsVideo = TRUE;
        currPosting.ownerBusiness = currBusiness;
        [postings addObject:currPosting];
        [self.postings addObject:currPosting];
        currBusiness.postings = postings;
    }
}

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
        cell.oTextButton.enabled = currPost.wantsText;
        cell.oAudioButton.enabled = currPost.wantsAudio;
        cell.oCameraButton.enabled = currPost.wantsVideo;
        BusinessRecord *currBusiness = (BusinessRecord *)currPost.ownerBusiness;
        cell.oBusinessLabel.text = currBusiness.name;
        cell.oAddressLabel.text = currBusiness.address;
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
//    if (self.popupTextView) {
//        [self.popupTextView removeFromSuperview];
//        self.popupTextView = nil;
//    } else {
//        CGFloat startY = ((UIView *)sender).frame.size.height *0.5;
//        startY += ((UIView *)sender).superview.frame.origin.y;
//        startY -= 240.0;
//        CGRect topFrame = CGRectMake(0, startY,
//                                     self.view.bounds.size.width, 240.0);
//        self.popupTextView = [[[NSBundle mainBundle] loadNibNamed:@"TextApplPopupView" owner:self options:nil] objectAtIndex:0];
//        [self.popupTextView setFrame:topFrame];
//        [self.view addSubview:self.popupTextView];
//        [self.popupTextView setupContent];
//    }
}

-(void) delegateAudio {
    
}

-(void) delegateVideo {
}


#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
