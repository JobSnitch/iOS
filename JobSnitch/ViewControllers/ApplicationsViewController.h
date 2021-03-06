//
//  ApplicationsViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
#import "EmployerRecord.h"
#import "CompanyRecord.h"
#import "PostingRecord.h"

@protocol EmployerContainerDelegate <NSObject>
-(void) hasFinishedApplications;

@end

@interface ApplicationsViewController : BaseJSViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak)   EmployerRecord *currEmployer;
@property (nonatomic, weak)   CompanyRecord *currBusiness;
@property (nonatomic, weak)   PostingRecord *currPosting;

@property (assign) id<EmployerContainerDelegate> delegate;     // the parent controller implements this

-(void) setupFields;
-(void) prepareData;
@end
