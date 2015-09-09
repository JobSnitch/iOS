//
//  EmployerRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRecord.h"

@interface EmployerRecord : UserRecord
@property (nonatomic, strong) NSMutableArray * businesses;

@end
