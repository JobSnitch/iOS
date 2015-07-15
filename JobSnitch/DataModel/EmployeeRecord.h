//
//  EmployeeRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmployeeRecord : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSArray * postings;

@end
