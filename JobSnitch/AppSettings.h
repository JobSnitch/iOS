//
//  AppSettings.h
//  JobSnitch
//
//  Created by Andrei Sava on 07/07/15.
//  Copyright (c) 2015 JobSnitch. All rights reserved.
//

#ifndef JobSnitch_AppSettings_h
#define JobSnitch_AppSettings_h

typedef void (^AnimationBlock)(void);
typedef void (^CompletionBlock)(BOOL finished);

typedef enum : NSUInteger {
    creationContext,
    settingContext
} PersonContext;

#define baseJobSnitchURL    @"http://jsdevcloud2.cloudapp.net/Service/"

#define testUserID          @"00f81794-1422-4510-8a52-ba0a92d2c4e5"

// configure to real SFTP server
#define sftpHost        @"10.0.1.15"
#define sftpPort        @"22"
#define sftpUsername    @"andreidev"
#define sftpPass        @"D3v3lopMac"
#define sftpRemoteBase  @"/Users/andreidev/Desktop"

#endif
