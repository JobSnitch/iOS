//
//  EmployeeRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRecord.h"

@interface EmployeeRecord : UserRecord
@property (nonatomic, strong) NSArray * postings;

@end
