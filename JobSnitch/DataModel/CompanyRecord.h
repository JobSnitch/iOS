//
//  CompanyRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 24/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyRecord : NSObject
@property (nonatomic) NSInteger CompanyId;
@property (nonatomic, strong) NSString * NameEnglish;
@property (nonatomic, strong) NSString * City;
@property (nonatomic, strong) NSString * Province;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSArray * postings;

@end
