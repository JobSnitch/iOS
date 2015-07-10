//
//  BusinessRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 10/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessRecord : NSObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSArray * postings;

@end
