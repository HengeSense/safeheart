//
//  LoginController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "LoginController.h"
#import "Notifications.h"

@implementation LoginController

static BOOL loggedIn;
static NSString* username;
static NSString* password;

+(BOOL) logInWithUsername:(NSString*)u password:(NSString*) p {
    BOOL credentialsValid;
    
    //TODO: actually log in
    credentialsValid = TRUE;
    
    if (credentialsValid) {
        username = u;
        password = p;
        [LoginController setLoggedIn:YES];
    } else {
        username = nil;
        password = nil;
        [LoginController setLoggedIn:NO];
    }
    
    return credentialsValid;
}

-(void) logOut {
    [LoginController setLoggedIn:NO];
}

+(void) setLoggedIn:(BOOL) b {
    loggedIn = b;
    [[NSNotificationCenter defaultCenter] postNotificationName:[Notifications notificationLogInChanged] object:self];
}

+(BOOL) isLoggedIn {
    return loggedIn;
}

+(NSString*) username {
    return username;
}

@end
