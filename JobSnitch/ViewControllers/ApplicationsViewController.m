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

@interface ApplicationsViewController () <ApplicationCellDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *oSmallImage;
@property (weak, nonatomic) IBOutlet UILabel *oEmployerName;
@property (weak, nonatomic) IBOutlet UIView *oBusinessView;
@property (weak, nonatomic) IBOutlet UILabel *oJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *oJobDescript;
@property (nonatomic, weak) IBOutlet UICollectionView *oCollectionView;

@property (nonatomic, strong)   NSMutableArray *applications;
@property (nonatomic)   int     currentIndex;
@end

@implementation ApplicationsViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
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
-(void) delegateText {
    
}

-(void) delegateAudio {
    
}

-(void) delegateVideo {
    
}
-(void) delegateDelete{
    
}

-(void) delegateFolder {
    
}

-(void) delegateCheck {
    
}


#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
