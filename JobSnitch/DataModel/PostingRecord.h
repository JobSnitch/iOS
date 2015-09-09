//
//  PostingRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostingRecord : NSObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * descrption;
@property (nonatomic, strong) NSString * JobCategoryName;             // ?
@property (nonatomic)       NSInteger   JobCategoryId;
@property (nonatomic, strong) NSString * industry;                   // ?
@property (nonatomic) BOOL   morningShift;
@property (nonatomic) BOOL   afternoonShift;
@property (nonatomic) BOOL   eveningShift;
@property (nonatomic) BOOL   nightShift;
@property (nonatomic) int   noApplications;
@property (nonatomic) int   noShortlisted;              // ?

@property (nonatomic) BOOL   wantsText;
@property (nonatomic) BOOL   wantsAudio;
@property (nonatomic) BOOL   wantsVideo;

@property (nonatomic) BOOL   isActive;
@property (nonatomic) NSInteger   JobPostingId;
@property (nonatomic, strong) NSString *  CompanyId;
@property (nonatomic, strong) NSString * JobLocation;
@property (nonatomic, strong) NSArray *applications;

@property (nonatomic, weak) id ownerBusiness;

@end
