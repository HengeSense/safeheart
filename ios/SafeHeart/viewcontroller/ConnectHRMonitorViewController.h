//
//  ConnectHRMonitorViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-03-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFConnector/WFConnector.h>
#import "ANTDeviceInfoVC.h"
#import "BTDeviceInfoVC.h"
#import "MetricView.h"

@interface ConnectHRMonitorViewController : UIViewController <WFSensorConnectionDelegate>
{
	WFHardwareConnector* hardwareConnector;
	WFSensorConnection* sensorConnection;
	WFSensorType_t sensorType;
	UILabel* deviceIdLabel;
	UILabel* signalEfficiencyLabel;
	
	UIButton* connectButton;
	UISwitch* wildcardSwitch;
    UISwitch* proximitySwitch;
    
    ANTDeviceInfoVC* antDeviceInfo;
    BTDeviceInfoVC* btDeviceInfo;
    
    USHORT applicableNetworks;
    
    MetricView* heartMetric;
    MetricView* batteryMetric;
}

- (IBAction)connectHeartRateMonitor:(id)sender;
- (IBAction)dismissView:(id)sender;


@property (retain, nonatomic) WFSensorConnection* sensorConnection;
@property (retain, nonatomic) IBOutlet UILabel* signalEfficiencyLabel;
@property (retain, nonatomic) IBOutlet UILabel* deviceIdLabel;
@property (retain, nonatomic) IBOutlet UIButton* connectButton;

@property (retain, nonatomic) IBOutlet UILabel* computedHeartrateLabel;
@property (retain, nonatomic) IBOutlet UILabel* beatTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel* beatCountLabel;
@property (retain, nonatomic) IBOutlet UILabel* previousBeatLabel;
@property (retain, nonatomic) IBOutlet UILabel* battLevelLabel;
@property (strong, nonatomic) IBOutlet UIView *viewMetric;

@end
