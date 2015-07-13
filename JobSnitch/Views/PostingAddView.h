//
//  PostingAddView.h
//  JobSnitch
//
//  Created by Andrei Sava on 13/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "PostingExpandedView.h"
#import "BusinessRecord.h"

@interface PostingAddView : PostingExpandedView
@property (weak, nonatomic) BusinessRecord *currBusiness;
@end
