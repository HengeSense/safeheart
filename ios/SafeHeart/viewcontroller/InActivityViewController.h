//
//  InActivityViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-23.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressPointerViewController.h"
#import "Activity.h"
#import "HeartRateListener.h"
#import "MetricView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CoreLocation/CoreLocation.h>

#import "JGMediaPickerController.h"
#import "ActivityLog.h"
#import "RequestManager.h"

@interface InActivityViewController : UIViewController <HeartRateListener,CLLocationManagerDelegate,RMActivityLogSyncDelegate> {
    ProgressPointerViewController* progressViewController;
    MetricView* timeMetric;
    MetricView* distanceMetric;
    MetricView* caloriesMetric;
    NSTimer* maxVibrator;
    bool isWarning;
    bool didDismiss;
    UIAlertView *message;
    BOOL isPlayingMusic;
    ActivityLog* activityLog;
    Activity* activity;
    NSTimer* updateTimer;
    int currentHeartRate;
    CLLocationManager *locationMgr;
}

@property (strong, nonatomic) IBOutlet UIImageView *viewAlbum;
@property (strong, nonatomic) IBOutlet UILabel *labelArtist;
@property (strong, nonatomic) IBOutlet UILabel *labelSongName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonStartStop;
@property (strong, nonatomic) IBOutlet UILabel *labelCurrentHeartRate;
@property (strong, nonatomic) IBOutlet UIView *metricView;
@property (strong, nonatomic) IBOutlet UIButton *buttonPausePlay;
@property (strong, nonatomic) JGMediaPickerController* mediaPickerController;


- (IBAction)pausePlayButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)previousButtonPressed:(id)sender;
- (IBAction)pickMusic:(id)sender;

- (IBAction)startStopButtonPressed:(id)sender;
- (void) setActivity:(Activity*)a;

@end
