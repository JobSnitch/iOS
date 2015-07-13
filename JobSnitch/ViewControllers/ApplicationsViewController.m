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

@interface ApplicationsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *oSmallImage;
@property (weak, nonatomic) IBOutlet UILabel *oEmployerName;
@property (weak, nonatomic) IBOutlet UIView *oBusinessView;
@property (weak, nonatomic) IBOutlet UILabel *oJobTitle;
@property (weak, nonatomic) IBOutlet UILabel *oJobDescript;
@property (nonatomic, weak) IBOutlet UICollectionView *oCollectionView;

@end

@implementation ApplicationsViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

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
    return self.currPosting.noApplications;
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
    
    return cell;
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    float pageWidth = self.view.bounds.size.width * 353.0/414.0;
//    
//    float currentOffset = scrollView.contentOffset.x;
//    float targetOffset = targetContentOffset->x;
//    float newTargetOffset = 0;
//    
//    if (targetOffset > currentOffset)
//        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
//    else
//        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
//    
//    if (newTargetOffset < 0)
//        newTargetOffset = 0;
//    else if (newTargetOffset > scrollView.contentSize.width)
//        newTargetOffset = scrollView.contentSize.width;
//    
//    targetContentOffset->x = currentOffset;
//    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
//}

#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (IBAction)actionBack:(id)sender {
    [self.delegate hasFinishedApplications];
}

@end
