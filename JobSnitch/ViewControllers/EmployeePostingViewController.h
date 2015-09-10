//
//  EmployeePostingViewController.h
//  JobSnitch
//
//  Created by Andrei Sava on 15/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "BaseJSViewController.h"
#import "EmployeeRecord.h"
#import "PostingRecord.h"

@protocol EmployeeContainerDelegate <NSObject>
-(void) hasFinishedApplications;

@end

@interface EmployeePostingViewController : BaseJSViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak)   PostingRecord *currPosting;

@property (assign) id<EmployeeContainerDelegate> delegate;    

-(void) setupFields;
-(void) prepareData;
@end
