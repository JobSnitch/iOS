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
@property (nonatomic, strong) NSString * type;                       // ?
@property (nonatomic, strong) NSString * industry;                   // ?
@property (nonatomic) BOOL   morningShift;
@property (nonatomic) BOOL   afternoonShift;
@property (nonatomic) BOOL   eveningShift;
@property (nonatomic) BOOL   nightShift;
@property (nonatomic) int   noApplications;
@property (nonatomic) int   noShortlisted;              // ?

@end
