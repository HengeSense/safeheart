//
//  Constants.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//



//


//SafeHeart User Constants
#define kSafeHeartId @"id"
#define kSafeHeartUsername @"username"
#define kSafeHeartFirstName @"firstName"
#define kSafeHeartLastName @"lastName"
#define kSafeHeartGender @"gander"
#define kSafeHeartBirthday @"birthday"
#define kSafeHeartWeight @"weight"
#define kSafeHeartMonitorLocation @"monitorLocation"

#define kSafeHeartFullName @"real_name"
#define kSafeHeartSessionKey @"sessionKey"
#define kSafeHeartURL @"url"
#define kSafeHeartUserType @"userType"
#define kSafeHeartUserType @"userType"
#define kSafeHeartViberate @"viberate"
#define kSafeHeartImage @"image"


//SafeHeart API Constants
#define BASE_API_PATH @"base_API"
#define LOGIN_API_PATH @"https://www.genomesavant.com/t/safeheart/db/request.php"
#define COMMAND_API_PATH @"http://genomesavant.com/t/safeheart/db/request.php"

//SafeHeart Archive Constants

#define USER_ARCHIVE @"user_archive"
#define QUEUE_ARCHIVE @"queue.archive"


//SafeHeart Archive Activity

#define ACTIVITY_ALL_ARCHIVE @"activity_all_archive"
#define ACTIVITY_RECENT_ARCHIVE @"activity_recent_archive"
#define ACTIVITY_RECOMMENDED_ARCHIVE @"activity_recommended_archive"

#define kActivityUpdateTime @"update_time"
#define kActivityArray @"activity_array"

typedef enum {
    ActivityTypeAll = 0,
    ActivityTypeRecommended,
    ActivityTypeRecent,
} ActivityType;


typedef enum {
    MonitorLocationWaist = 0,
    MonitorLocationArm,
    MonitorLocationJacket,
} MonitorLocation;
