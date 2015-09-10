//
//  ApplicationRecord.m
//  JobSnitch
//
//  Created by Andrei Sava on 14/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import "ApplicationRecord.h"

@implementation ApplicationRecord

-(void) deepCopy:(ApplicationRecord *) source {
    self.ApplicationStatus = source.ApplicationStatus;
    self.JobPostingId = source.JobPostingId;
    self.UserId = source.UserId;
    self.FirstName = source.FirstName;
    self.LastName = source.LastName;
    self.name = [NSString stringWithFormat:@"%@ %@", self.FirstName, self.LastName];
    self.textResource = source.textResource;
    self.audioResource = source.audioResource;
    self.videoResource = source.videoResource;
    self.phoneNumber = source.phoneNumber;
    self.email = source.email;
    self.morningShift = source.morningShift;
    self.afternoonShift = source.afternoonShift;
    self.eveningShift = source.eveningShift;
    self.nightShift = source.nightShift;
    self.VideoIncluded = source.VideoIncluded;

}

@end
