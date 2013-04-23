//
//  AppDelegate.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WFHardwareConnectorDelegate>
{
    WFHardwareConnector* hardwareConnector;
}


@property (strong, nonatomic) UIWindow *window;

@end
