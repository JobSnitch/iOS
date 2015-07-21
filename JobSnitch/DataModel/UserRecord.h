//
//  UserRecord.h
//  JobSnitch
//
//  Created by Andrei Sava on 21/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    bool MondayAM;
    bool MondayEvening;
    bool MondayPM;
    bool TuesdayAM;
    bool TuesdayEvening;
    bool TuesdayPM;
    bool WednesdayAM;
    bool WednesdayEvening;
    bool WednesdayPM;
    bool ThursdayAM;
    bool ThursdayEvening;
    bool ThursdayPM;
    bool FridayAM;
    bool FridayEvening;
    bool FridayPM;
    bool SaturdayAM;
    bool SaturdayEvening;
    bool SaturdayPM;
    bool SundayAM;
    bool SundayEvening;
    bool SundayPM;
} AvailabilitySchedule;


@interface UserRecord : NSObject {
@public
    AvailabilitySchedule availability;
}
@property (nonatomic, strong) NSString * UserId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * FirstName;
@property (nonatomic, strong) NSString * LastName;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * Email;
@property (nonatomic, strong) NSString * Interests;
@property (nonatomic, strong) NSString * PostalCode;
@end
