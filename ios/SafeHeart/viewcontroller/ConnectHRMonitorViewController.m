//
//  ConnectHRMonitorViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-03-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ConnectHRMonitorViewController.h"
#import "HeartRateMonitor.h"
#import "ViewUtil.h"

#import "MetricView.h"

//#import "BTDeviceInfoVC.h"
//#import "ANTDeviceInfoVC.h"
//#import "DeviceDiscoveryVC.h"

@interface ConnectHRMonitorViewController ()

@end

@implementation ConnectHRMonitorViewController

@synthesize sensorConnection;
@synthesize deviceIdLabel;
@synthesize signalEfficiencyLabel;
@synthesize connectButton;
@synthesize computedHeartrateLabel;
@synthesize beatCountLabel;
@synthesize beatTimeLabel;
@synthesize previousBeatLabel;
@synthesize battLevelLabel;
@synthesize viewMetric;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"=== Connection view did load ===");
    
    hardwareConnector = [WFHardwareConnector sharedConnector];
    
    sensorType = WF_SENSORTYPE_HEARTRATE;
    applicableNetworks = WF_NETWORKTYPE_ANTPLUS | WF_NETWORKTYPE_BTLE;
    
    sensorConnection = nil;
    
    // default applicable networks to ANT+.
    applicableNetworks = WF_NETWORKTYPE_ANTPLUS;
    
    // initialize the display based on HW connector and sensor state.
    if ( hardwareConnector.isCommunicationHWReady )
    {
        // check for an existing connection to this sensor type.
        NSArray* connections = [hardwareConnector getSensorConnections:sensorType];
        WFSensorConnection* sensor = ([connections count]>0) ? (WFSensorConnection*)[connections objectAtIndex:0] : nil;
        
        // if a connection exists, cache it and set the delegate to this
        // instance (this will allow receiving connection state changes).
        self.sensorConnection = sensor;
        if ( sensor )
        {
            self.sensorConnection.delegate = self;
        }
        
        // update the display.
        [self checkState];
        [self updateData];
    }
    else
    {
        [self resetDisplay];
    }
    
    // register for HW connector notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fisicaConnected) name:WF_NOTIFICATION_HW_CONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fisicaDisconnected) name:WF_NOTIFICATION_HW_DISCONNECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:WF_NOTIFICATION_SENSOR_HAS_DATA object:nil];
    
    // create view controllers for device info.
    btDeviceInfo = [[BTDeviceInfoVC alloc] initWithNibName:@"BTDeviceInfoVC" bundle:nil];
    antDeviceInfo = [[ANTDeviceInfoVC alloc] initWithNibName:@"ANTDeviceInfoVC" bundle:nil];
    
    heartMetric = [MetricView getViewForMetric:MetricHeart];
    [viewMetric addSubview:heartMetric];
    
    batteryMetric = [MetricView getViewForMetric:MetricBattery];
    [viewMetric addSubview:batteryMetric];
    
    [ViewUtil positionChild:batteryMetric rightOf:heartMetric withPadding:5];
    
    [viewMetric setHidden:![HeartRateMonitor isConnected]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectHeartRateMonitor:(id)sender {

    NSLog(@"connectHeartRateMonitor");
    
        // get the current connection status.
        WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
        if ( sensorConnection != nil )
        {
            connState = sensorConnection.connectionStatus;
        }
        
        // set the button state based on the connection state.
        switch (connState)
        {
            case WF_SENSOR_CONNECTION_STATUS_IDLE:
            {
                // create the connection params.
                WFConnectionParams* params = [hardwareConnector.settings connectionParamsForSensorType:sensorType];
                
                if ( params != nil)
                {
                    // set the search timeout.
                    params.searchTimeout = hardwareConnector.settings.searchTimeout;
                    self.sensorConnection = [hardwareConnector requestSensorConnection:params];

                    // set delegate to receive connection status changes.
                    self.sensorConnection.delegate = self;
                }
                break;
            }
            
            case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
            case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
                // disconnect the sensor.
                [self.sensorConnection disconnect];
                break;
                
            case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
            case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
                // do nothing.
                break;
        }
        
        [self checkState];
}

- (void)checkState
{
    
    NSLog(@"checkState");
    
	// get the current connection status.
	WFSensorConnectionStatus_t connState = WF_SENSOR_CONNECTION_STATUS_IDLE;
	if ( sensorConnection != nil )
	{
		connState = sensorConnection.connectionStatus;
	}
	
	// set the button state based on the connection state.
	switch (connState)
	{
		case WF_SENSOR_CONNECTION_STATUS_IDLE:
			[connectButton setTitle:@"Connect" forState:UIControlStateNormal];
			break;
		case WF_SENSOR_CONNECTION_STATUS_CONNECTING:
			[connectButton setTitle:@"Cancel" forState:UIControlStateNormal];
			break;
		case WF_SENSOR_CONNECTION_STATUS_CONNECTED:
			[connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
			break;
		case WF_SENSOR_CONNECTION_STATUS_DISCONNECTING:
			[connectButton setTitle:@"Disconnecting..." forState:UIControlStateNormal];
			break;
        case WF_SENSOR_CONNECTION_STATUS_INTERRUPTED:
            break;
	}
}

#pragma mark WFSensorConnectionDelegate Implementation

//--------------------------------------------------------------------------------
- (void)connectionDidTimeout:(WFSensorConnection*)connectionInfo
{
    NSLog(@"connectionDidTimeout");
    
    
    // update the button state.
    [self checkState];
    
    // alert the user that the search timed out.
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Search Timeout"
                                                    message:@"A connection was not established before the maximum search time expired."
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    alert = nil;
}

//--------------------------------------------------------------------------------
- (void)connection:(WFSensorConnection*)connectionInfo stateChanged:(WFSensorConnectionStatus_t)connState
{
    NSLog(@"connection");
    
    NSLog(@"SENSOR CONNECTION STATE CHANGED:  connState = %d (IDLE=%d)",connState,WF_SENSOR_CONNECTION_STATUS_IDLE);
    
    [HeartRateMonitor setConnected:connectionInfo.isConnected];
    
    [viewMetric setHidden:!connectionInfo.isConnected];
    
    // check for a valid connection.
    if ( connectionInfo.isValid && connectionInfo.isConnected )
    {
        // process post-connection setup.
        [self onSensorConnected:connectionInfo];
        
        // update the display.
        [self updateData];
    }
    
    // check for disconnected sensor.
    else if ( connState == WF_SENSOR_CONNECTION_STATUS_IDLE )
    {
        // reset the display.
        [self resetDisplay];
        
        // check for a connection error.
        if ( connectionInfo.hasError )
        {
            NSString* msg = nil;
            switch ( connectionInfo.error )
            {
                case WF_SENSOR_CONN_ERROR_PAIRED_DEVICE_NOT_AVAILABLE:
                    msg = @"Paired device error.\n\nA device specified in the connection parameters was not found in the Bluetooth Cache.  Please use the paring manager to remove the device, and then re-pair.";
                    break;
                    
                case WF_SENSOR_CONN_ERROR_PROXIMITY_SEARCH_WHILE_CONNECTED:
                    msg = @"Proximity search is not allowed while a device of the specified type is connected to the iPhone.";
                    break;
            }
            
            if ( msg )
            {
                // display the error message.
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
        }
    }
	
	[self checkState];
}


#pragma mark -
#pragma mark DeviceDiscoveryDelegate Implementation

//--------------------------------------------------------------------------------
- (void)requestConnectionToDevice:(WFDeviceParams*)devParams
{
    NSLog(@"requestConnectionToDevice");
    
    
    // configure the connection params.
    WFConnectionParams* params = [[WFConnectionParams alloc] init];
    params.sensorType = sensorType;
    params.device1 = devParams;
    
    // request the sensor connection.
    self.sensorConnection = [hardwareConnector requestSensorConnection:params];
    
    // set delegate to receive connection status changes.
    self.sensorConnection.delegate = self;
    
    // update the button state.
    [self checkState];
}


#pragma mark -
#pragma mark WFSensorCommonViewController Implementation

#pragma mark Private Methdods

//--------------------------------------------------------------------------------
- (void)checkProximity
{
    NSLog(@"checkProximity");
    
    
    // proximity is allowed only on wildcard search.
    if ( !wildcardSwitch.on )
    {
        proximitySwitch.on = FALSE;
    }
}

//--------------------------------------------------------------------------------
- (void)fisicaConnected
{
    NSLog(@"fisicaConnected");
    
}

//--------------------------------------------------------------------------------
- (void)fisicaDisconnected
{
    NSLog(@"fisicaDisconnected");
    
	[self resetDisplay];
}

//--------------------------------------------------------------------------------
- (void)updateDeviceInfo
{
    NSLog(@"updateDeviceInfo");
    
    WFSensorData* data = [sensorConnection getData];
    if ( data )
    {
        // check the radio type of the sensor connection.
        if ( sensorConnection.isBTLEConnection )
        {
            // check that the BTLE common data is present.
            if ( ![data respondsToSelector:@selector(btleCommonData)] )
            {
                // check for BTLE common data in raw data instance.
                data = [sensorConnection getRawData];
            }
            
            // check that the BTLE common data is present.
            if ( [data respondsToSelector:@selector(btleCommonData)] )
            {
                // get the BTLE common data and display the detail view.
                btDeviceInfo.commonData = (WFBTLECommonData*)[data performSelector:@selector(btleCommonData)];
                [btDeviceInfo updateDisplay];
            }
        }
        
        else if ( sensorConnection.isANTConnection )
        {
            // check that the ANT+ common data is present.
            if ( ![data respondsToSelector:@selector(commonData)] )
            {
                // check for ANT+ common data in raw data instance.
                data = [sensorConnection getRawData];
            }
            
            // check that the ANT+ common data is present.
            if ( [data respondsToSelector:@selector(commonData)] )
            {
                // get the ANT+ common data and display the detail view.
                antDeviceInfo.commonData = (WFCommonData*)[data performSelector:@selector(commonData)];
                [antDeviceInfo updateDisplay];
            }
        }
    }
}


#pragma mark Public Methods

//--------------------------------------------------------------------------------
- (void)onSensorConnected:(WFSensorConnection*)connectionInfo
{
    NSLog(@"onSensorConnected");
    
    
    // update the stored connection settings.
    [hardwareConnector.settings saveConnectionInfo:connectionInfo];
}

//--------------------------------------------------------------------------------
- (void)resetDisplay
{
    NSLog(@"resetDisplay");
    
    deviceIdLabel.text = @"n/a";
    signalEfficiencyLabel.text = @"n/a";
}

//--------------------------------------------------------------------------------

- (void)updateData
{

    WFHeartrateConnection* heartrateConnection = (WFHeartrateConnection*) self.sensorConnection;
    
	WFHeartrateData* hrData = [heartrateConnection getHeartrateData];
	WFHeartrateRawData* hrRawData = [heartrateConnection getHeartrateRawData];
	if ( hrData != nil )
	{
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:hrData.computedHeartrate];
        
        // unformatted value.
		// computedHeartrateLabel.text = [NSString stringWithFormat:@"%d", hrData.computedHeartrate];
        
        // update basic data.
        
        int hr = (int)([hrData computedHeartrate]);
        [HeartRateMonitor updateHR:hr];
        
        [heartMetric setMetricValue:[hrData formattedHeartrate:TRUE]];
        computedHeartrateLabel.text = [hrData formattedHeartrate:TRUE];
		beatTimeLabel.text = [NSString stringWithFormat:@"%d", hrData.beatTime];
		
        // update raw data.
		beatCountLabel.text = [NSString stringWithFormat:@"%d", hrRawData.beatCount];
		previousBeatLabel.text = [NSString stringWithFormat:@"%d", hrRawData.previousBeatTime];
        
        // BTLE HR monitors optionally transmit R-R intervals.  this demo does not
        // display R-R values.  however, the following code is included to demonstrate
        // how to read and parse R-R intervals.
        if ( [hrData isKindOfClass:[WFBTLEHeartrateData class]] )
        {
            NSArray* rrIntervals = [(WFBTLEHeartrateData*)hrData rrIntervals];
            for ( NSNumber* rr in rrIntervals )
            {
                //NSLog(@"R-R Interval: %1.3f s.", [rr doubleValue]);
            }
        }
        
        // the common data for BTLE sensors is still in beta state.  this data
        // will eventually be merged with the existing common data.  for current demo
        // purposes, the battery level is updated directly from this HR view controller.
        if ( hrRawData.btleCommonData )
        {
            battLevelLabel.text = [NSString stringWithFormat:@"%u %%", hrRawData.btleCommonData.batteryLevel];
            
            [batteryMetric setMetricValue:[NSString stringWithFormat:@"%u %%", hrRawData.btleCommonData.batteryLevel]];
        }
	}
	else
	{
		[self resetDisplay];
	}
}



#pragma mark Properties

//--------------------------------------------------------------------------------
- (void)setSensorConnection:(WFSensorConnection *)conn
{
    NSLog(@"setSensorConnection");
    
    sensorConnection.delegate = nil;

    sensorConnection = conn;
    sensorConnection.delegate = self;
}

#pragma mark Event Handlers

//--------------------------------------------------------------------------------
- (IBAction)deviceInfoClicked:(id)sender
{
    NSLog(@"deviceInfoClicked");
    
    if ( sensorConnection )
    {
        // check the radio type of the sensor connection.
        if ( sensorConnection.isBTLEConnection )
        {
            // update device info and display VC.
            [self updateDeviceInfo];
            btDeviceInfo.sensorConnection = sensorConnection;
            [self.navigationController pushViewController:btDeviceInfo animated:TRUE];
        }
        
        else if ( sensorConnection.isANTConnection )
        {
            // update device info and display VC.
            [self updateDeviceInfo];
            [self.navigationController pushViewController:antDeviceInfo animated:TRUE];
        }
    }
}

//--------------------------------------------------------------------------------
- (IBAction)manageClicked:(id)sender
{
    NSLog(@"manageClicked");
    
    /*
    // configure and display the sensor manager view.
	SensorManagerViewController* vc = [[SensorManagerViewController alloc] initWithNibName:@"SensorManagerViewController" bundle:nil];
	[vc configForSensorType:sensorType onNetworks:applicableNetworks];
    vc.delegate = self;
	[self.navigationController pushViewController:vc animated:TRUE];
    */
}

//--------------------------------------------------------------------------------
- (IBAction)proximityToggled:(id)sender
{
    NSLog(@"proximityToggled");
    
    [self checkProximity];
}

//--------------------------------------------------------------------------------
- (IBAction)textFieldDoneEditing:(id)sender
{
    NSLog(@"textFieldDoneEditing");
    
	[sender resignFirstResponder];
}

//--------------------------------------------------------------------------------
- (IBAction)wildcardToggled:(id)sender
{
    NSLog(@"wildcardToggled");
    
    [self checkProximity];
}


#pragma mark -
#pragma mark WFSensorCommonViewController Class Method Implementation

//--------------------------------------------------------------------------------
+ (NSString*)formatUUIDString:(NSString*)uuid
{
    NSLog(@"formatUUIDString");
    
    // strip the leading zeros from the UUID.
    NSString* retVal = [uuid stringByReplacingOccurrencesOfString:@"0000000000000000" withString:@""];
    retVal = [retVal stringByReplacingOccurrencesOfString:@"00000000-0000-0000-" withString:@""];
    
    return retVal;
}

//--------------------------------------------------------------------------------
+ (NSString*)signalStrengthFromConnection:(WFSensorConnection*)conn
{
    NSLog(@"signalStrengthFromConnection");
    
    NSString* retVal = @"n/a";
    
    if ( conn )
    {
        // format the signal efficiency value.
		float signal = [conn signalEfficiency];
        //
        // signal efficency is % for ANT connections, dBm for BTLE.
        if ( conn.isANTConnection && signal != -1 )
        {
            retVal = [NSString stringWithFormat:@"%1.0f%%", (signal*100)];
        }
        else if ( conn.isBTLEConnection )
        {
            retVal = [NSString stringWithFormat:@"%1.0f dBm", signal];
        }
    }
    
    return retVal;
}

//--------------------------------------------------------------------------------
+ (NSString*)stringFromSensorType:(WFSensorType_t)sensorType
{
    NSLog(@"stringFromSensorType");
    
    NSString* retVal;
    
	switch (sensorType)
	{
		case WF_SENSORTYPE_HEARTRATE:
            retVal = @"Heart Rate Monitor";
            break;
		case WF_SENSORTYPE_FOOTPOD:
            retVal = @"Footpod";
            break;
		case WF_SENSORTYPE_BIKE_SPEED:
            retVal = @"Bike Speed";
            break;
		case WF_SENSORTYPE_BIKE_CADENCE:
            retVal = @"Bike Cadence";
            break;
		case WF_SENSORTYPE_BIKE_SPEED_CADENCE:
            retVal = @"Bike Speed & Cadence";
            break;
		case WF_SENSORTYPE_BIKE_POWER:
            retVal = @"Bike Power";
            break;
		case WF_SENSORTYPE_WEIGHT_SCALE:
            retVal = @"Weight Scale";
            break;
        case WF_SENSORTYPE_ANT_FS:
            retVal = @"ANT FS";
            break;
		case WF_SENSORTYPE_CALORIMETER:
            retVal = @"Calorimeter";
            break;
		case WF_SENSORTYPE_GEO_CACHE:
            retVal = @"GeoCache";
            break;
		case WF_SENSORTYPE_FITNESS_EQUIPMENT:
            retVal = @"Fitness Equipment";
            break;
		case WF_SENSORTYPE_MULTISPORT_SPEED_DISTANCE:
            retVal = @"Multisport Speed & Distance";
            break;
		case WF_SENSORTYPE_PROXIMITY:
            retVal = @"Proximity";
            break;
		case WF_SENSORTYPE_HEALTH_THERMOMETER:
            retVal = @"Thermometer";
            break;
		case WF_SENSORTYPE_BLOOD_PRESSURE:
            retVal = @"Blood Pressure";
            break;
		case WF_SENSORTYPE_BTLE_GLUCOSE:
            retVal = @"Glucose (BTLE)";
            break;
		case WF_SENSORTYPE_GLUCOSE:
            retVal = @"Glucose (ANT+)";
            break;
            
		default:
			retVal = @"None";
            break;
	}
    
    return retVal;
}

- (IBAction)dismissView:(id)sender {
    NSLog(@"dismissView");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
