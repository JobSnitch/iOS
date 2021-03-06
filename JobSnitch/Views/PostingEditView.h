//
//  PostingEditView.h
//  JobSnitch
//
//  Created by Andrei Sava on 11/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingExpandedView.h"
#import "PostingRecord.h"

@interface PostingEditView : PostingExpandedView
@property (weak, nonatomic) PostingRecord *currPosting;

-(void) fillFields;
@end
