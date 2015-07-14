//
//  ApplicationRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    prefText,
    prefAudio,
    prefVideo
} ApplicationPreferences;

@interface ApplicationRecord : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * textResource;
@property (nonatomic, strong) NSString * audioResource;
@property (nonatomic, strong) NSString * videoResource;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, strong) NSString * email;
@property (nonatomic) ApplicationPreferences   applPreference;

@end
