//
//  InActivityViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-23.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "InActivityViewController.h"
#import "Colors.h"
#import "StoryBoardController.h"
#import "HeartRateListener.h"
#import "HeartRateMonitor.h"
#import "HeartRateClassifier.h"
#import "MetricView.h"
#import "ViewUtil.h"
#import <AudioToolbox/AudioServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "JGMediaPickerController.h"
#import "ActivityLog.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LoginManager.h"
#import "IntensityManager.h"
#import "RequestManager.h"
#import "ActivityCompletionViewController.h"

@interface InActivityViewController ()

@end

@implementation InActivityViewController

@synthesize buttonStartStop,buttonPausePlay,labelCurrentHeartRate,labelArtist,labelSongName,mediaPickerController,viewAlbum;

BOOL comingFromConnectionView = false;
BOOL playlistEmpty = false;

UIAlertView* waitAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSLog(@"Init with nib");
      
        
    }
    return self;
}

NSString* soundStart = @"activity-started";
NSString* soundStop = @"activity-stopped";

//SystemSoundID soundStop;
//SystemSoundID soundStart;

SystemSoundID getSound(NSString* p) {
    SystemSoundID soundID;
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],p]];
    AudioServicesCreateSystemSoundID((CFURLRef)objc_unretainedPointer(url), &soundID);
    return soundID;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        waitAlert = [[UIAlertView alloc] initWithTitle:@"\n\nSaving activity\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        
        //[[NSNotificationCenter defaultCenter] addObserverForName:nil object:nil queue:nil usingBlock:^(NSNotification *n) { NSLog(@"notification: %@", n); }];
        [self resetWarnings];
        NSLog(@"Listening to music changes");
        [[MPMusicPlayerController iPodMusicPlayer] beginGeneratingPlaybackNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setSongMetaData:)
                                                     name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object:[MPMusicPlayerController iPodMusicPlayer]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onResumeSetIsPlayingMusic:)
                                                     name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object:nil];
        
        [self didUpdateHeartRate:0];
    }
    return self;
}

-(void) resetWarnings {
    isWarning = false;
    didDismiss = false;
    isPlayingMusic = false;
    [self setIsPlayingMusic:isPlayingMusic silently:YES];
}

int max = 100;

-(void) viewWillAppear:(BOOL)animated {
    
    NSLog(@"view Will Appear");
    
    /*BOOL isMusicAlreadyPlaying = [[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying;
    [self setIsPlayingMusic:isMusicAlreadyPlaying silently:YES];*/
    
    [self onResumeSetIsPlayingMusic:nil];
    [self setSongMetaData];
    
    if (progressViewController == nil) {
        progressViewController = (ProgressPointerViewController*) [self.childViewControllers objectAtIndex:0];
        [progressViewController setProgressive:NO];
        [progressViewController setShowPercentage:NO];
        [progressViewController setRangeWithMin:50 Max:120];
        [progressViewController setRangeVisible:YES];
        [progressViewController setProgressClassifier:[[HeartRateClassifier alloc] initWithNormalRageMin:50 Max:max]];
        [progressViewController setSubtext:@""];
        
        timeMetric = [MetricView getViewForMetric:MetricTime];
        distanceMetric = [MetricView getViewForMetric:MetricDistance];
        caloriesMetric = [MetricView getViewForMetric:MetricCalories];
        
        [self.metricView addSubview:timeMetric];
        [self.metricView addSubview:distanceMetric];
        [self.metricView addSubview:caloriesMetric];

        double width = self.view.frame.size.width;//320;//self.metricView.frame.size.width;
        
        NSLog(@"%f",width);
        NSLog(@"%f\n",timeMetric.frame.size.width);
        [ViewUtil center:timeMetric OnXPosition:width*0.2];
        [ViewUtil center:distanceMetric OnXPosition:width*0.5];
        [ViewUtil center:caloriesMetric OnXPosition:width*0.8];

    }
    [HeartRateMonitor registerHRListener:self];
}

-(void) viewDidDisappear:(BOOL)animated {
    [HeartRateMonitor unregisterHRListener:self];
    [self resetWarnings];
}

-(void) viewDidAppear:(BOOL)animated {

    if (![HeartRateMonitor isConnected] && !comingFromConnectionView) {

        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Connect HR Monitor"
                                                          message:@"Would you like to connect a Bluetooth HR Monitor?"
                                                         delegate:self
                                                cancelButtonTitle:@"Yes"
                                                otherButtonTitles:@"No",nil];
        [message show];

    }
    comingFromConnectionView = false;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    // Connect dialog
    if([[alertView title] isEqualToString:@"Connect HR Monitor"]) {
        
     if([title isEqualToString:@"Yes"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierConnectHRView]] animated:YES completion:nil];
        comingFromConnectionView = true;
    }
       
        
    } else if([[alertView title] isEqualToString:@"Warning"]) {
        if ([title isEqualToString:@"Dismiss"]) {
            didDismiss = true;
            [self dismissWarning];
        }
        // Stop dialog
    } else if([[alertView title] isEqualToString:@"Stop Activity"]) {
        if ([title isEqualToString:@"Yes"]) {
            
            [self updateUIFromActivityLog:nil];
            [updateTimer invalidate];
            updateTimer = nil;
            
            [activityLog stopActivity];
            [[IntensityManager sharedInstance] stopIntensityUpdates];
            message = [[UIAlertView alloc] initWithTitle:@"Save"
                                                 message:@"Would you like to save results?"
                                                delegate:self
                                       cancelButtonTitle:@"No"
                                       otherButtonTitles:@"Yes",nil];
            [message show];
        }
    } else if([[alertView title] isEqualToString:@"Save"]) {
        if ([title isEqualToString:@"Yes"]) {
            [self attemptActivitySync];
        } else {
            [self goToCompletionView];
        }
    }  else if([[alertView title] isEqualToString:@"Uh oh"]) {
        if ([title isEqualToString:@"Yes"]) {
            [self attemptActivitySync];
        } else {
            [self goToCompletionView];
        }
    }
}

-(void) attemptActivitySync {
    NSLog(@"Attempting to upload activity log");
    [[RequestManager sharedInstance] pushActivityLog:activityLog withDelegate:self];    
    [waitAlert show];
}

- (void)activityLogSyncSuccessful:(ActivityLog *)log {
    NSLog(@"Upload successful");
    
    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self goToCompletionView];
}

- (void)goToCompletionView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityCompletionViewController *acVc = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierCompletionView]];
    [acVc setActivityLog:activityLog];
    [self.navigationController presentViewController:acVc animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];

}

-(void) goToSummaryView {
    NSLog(@"Going to summary view");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierSummaryView]] animated:YES];
}

- (void)activityLogSyncFailedWithError:(NSError *)error {
    NSLog(@"Upload failed");

    [waitAlert dismissWithClickedButtonIndex:0 animated:YES];
    message = [[UIAlertView alloc] initWithTitle:@"Uh oh"
                                         message:@"There was a problem saving activity. Try again?"
                                        delegate:self
                               cancelButtonTitle:@"No"
                               otherButtonTitles:@"Yes",nil];
    [message show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view.
        [buttonStartStop setTintColor:[UIColor darkGrayColor]];
        [buttonStartStop setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pausePlayButtonPressed:(id)sender {
    NSLog(@"Previous song...");
    [self setIsPlayingMusic:!isPlayingMusic];
    [self setSongMetaData];
}

- (IBAction)nextButtonPressed:(id)sender {
    NSLog(@"Next song...");
    [[MPMusicPlayerController iPodMusicPlayer] skipToNextItem];
    [self setSongMetaData];
}

- (IBAction)previousButtonPressed:(id)sender {
    [[MPMusicPlayerController iPodMusicPlayer] skipToPreviousItem];
    [self setSongMetaData];
}

- (IBAction)pickMusic:(id)sender {

    __weak InActivityViewController *weakSelf = self;
    [JGMediaPickerController jgMediaPickerControllerAsync:^(JGMediaPickerController *jgMediaPickerController) {
        weakSelf.mediaPickerController = jgMediaPickerController;
        weakSelf.mediaPickerController.delegate = self;
        [weakSelf presentModalViewController:self.mediaPickerController.viewController animated:YES];
        comingFromConnectionView = true;
    }];

}

- (void)jgMediaPicker:(JGMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection selectedItem:(MPMediaItem *)selectedItem {
    NSLog(@"Picked some songs");
    playlistEmpty = NO;
    [[MPMusicPlayerController iPodMusicPlayer] setQueueWithItemCollection:mediaItemCollection];
    [[MPMusicPlayerController iPodMusicPlayer] setNowPlayingItem:selectedItem];
    [[MPMusicPlayerController iPodMusicPlayer] play];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)jgMediaPickerDidCancel:(JGMediaPickerController *)mediaPicker {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) setSongMetaData:(id) sender {
    [self setSongMetaData];
}

-(void) setSongMetaData {
    [labelArtist setText:[[[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem] valueForKey:@"artist"]];
    [labelSongName setText:[[[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem] valueForKey:@"title"]];
    MPMediaItemArtwork *itemArtwork = [[[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem] valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *albumCover = [itemArtwork imageWithSize:CGSizeMake(128.0f, 128.0f)];
    [viewAlbum setImage:albumCover];
    
    if (playlistEmpty) {
        NSLog(@"Playlist is empty!");
        [labelArtist setText:@"Empty playlist"];
        [labelSongName setText:@"Press the musical note to set"];
    }
    
}

-(void) onResumeSetIsPlayingMusic:(id)sender {
    
    //NSLog(@"next up is %@",[[[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem] valueForKey:@"title"]);
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStateStopped && [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem] == nil) {
        NSLog(@"Playlist empty");
        playlistEmpty = YES;
    }
    
    BOOL isMusicAlreadyPlaying = [[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying;
    [self setIsPlayingMusic:isMusicAlreadyPlaying silently:YES];

}

-(void) setIsPlayingMusic:(BOOL)b {
    [self setIsPlayingMusic:b silently:NO];
}

-(void) setIsPlayingMusic:(BOOL)b silently:(BOOL)s {
       
    if (b) {
        if (playlistEmpty) {
            [self pickMusic:nil];
            return;
        }
        
        if (!s) {
            [[MPMusicPlayerController iPodMusicPlayer] play];
        }
        
        // show pause
        [buttonPausePlay setImage:[UIImage imageNamed:@"icon-pause-6.png"] forState:UIControlStateNormal];

    } else {
        if (!s) {
            [[MPMusicPlayerController iPodMusicPlayer] pause];
        }
        
        // show play
        [buttonPausePlay setImage:[UIImage imageNamed:@"icon-play-6.png"] forState:UIControlStateNormal];
    }
    
    [self setSongMetaData];
    isPlayingMusic = b;
}

-(void) startTrackingLocation {
    locationMgr = [[CLLocationManager alloc] init];
    locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
    locationMgr.delegate = self;
    
    [locationMgr startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
	// Handle location updates
    if ([activityLog isActive]) {
        if (newLocation.horizontalAccuracy < 15) {
            [activityLog addLocationEvent:timeStamp(newLocation)];
        } else {
            NSLog(@"Accuracy is %f, not adequate enough",newLocation.horizontalAccuracy);
        }
    }
}

TimeStampedEvent* timeStamp(NSObject* o) {
    return [[TimeStampedEvent alloc] initWithTime:[[NSDate alloc] init] Payload:o];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Handle error
}

- (IBAction)startStopButtonPressed:(id)sender {
    
    if ([buttonStartStop.title isEqualToString:@"Start"]) {
        
        [self startTrackingLocation];
        [[IntensityManager sharedInstance] startIntensityUpdates];
        
        self.metricView.alpha = 0;
        
        [UIView beginAnimations:@"fade in" context:nil];
        [UIView setAnimationDuration:0.5];
        self.metricView.alpha = 1;
        [UIView commitAnimations];
        
        activityLog = [[ActivityLog alloc] initWithActivity:activity];
        [activityLog startActivity];
        
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateUIFromActivityLog:)
                                       userInfo:nil
                                        repeats:YES];
        //playSound(soundStart);
        
        [self.navigationItem setHidesBackButton:YES animated:YES];
        buttonStartStop.title = @"Stop";
        [buttonStartStop setTintColor:[Colors getDeepRedColor]];
    } else {
        //playSound(soundStop);
        
        message = [[UIAlertView alloc] initWithTitle:@"Stop Activity"
                                             message:@"Are you really finished?"
                                            delegate:self
                                   cancelButtonTitle:@"No"
                                   otherButtonTitles:@"Yes",nil];
        [message show];
        
    }
}

void playSound(NSString* audioPath) {

    NSLog(audioPath);
    
    /*[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient withOptions: AVAudioSessionCategoryOptionDuckOthers error: nil];
    
    //AudioServicesPlaySystemSound(s);
    */
    
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:audioPath ofType:@"mp3"];
    
    NSLog(audioFile);
    
    NSURL* audioURL = [NSURL fileURLWithPath:audioFile];
    AVAudioPlayer* audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [audioPlayer play];
    
    
    NSURL *clickURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/activity-started.mp3", [[NSBundle mainBundle] resourcePath]]];
    AVAudioPlayer *sp = [[AVAudioPlayer alloc]initWithContentsOfURL:clickURL error:nil];
    [sp play];
    
    /*
    [[AVAudioSession sharedInstance] setActive:NO withOptions:0 error:nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient withOptions: 0 error: nil];
    //[[AVAudioSession sharedInstance] setActive:YES withOptions: 0 error:nil];
    */
}


- (NSString *)calorieValue {
    double intensity = [[IntensityManager sharedInstance] getTotalIntensity];
    double weight = [[[[LoginManager sharedInstance] user] weight] doubleValue];
    double calories = intensity*weight;
    if ([activityLog isActive]) {
        [activityLog addCalorieEvent:timeStamp([NSNumber numberWithFloat:calories])];
    }
    return [NSString stringWithFormat:@"%.1f",calories];
}


- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void) updateUIFromActivityLog:(id)sender {
    [timeMetric setMetricValue:[self timeFormatted:[activityLog duration]]];
    [distanceMetric setMetricValue:[NSString stringWithFormat:@"%.1fm",[activityLog getTotalDistance]]];
    [caloriesMetric setMetricValue:[self calorieValue]];
}

- (void) setActivity:(Activity*)a {
    self.title = [a name];
    activity = a;
}

- (void)didUpdateHeartRate:(int)heartRate {
    currentHeartRate = heartRate;
    //NSLog(@"Heart Rate updated to %i",heartRate);
        [progressViewController setProgress:heartRate];
        [labelCurrentHeartRate setText:[NSString stringWithFormat:@"%i",heartRate]];
        [self checkWarning:heartRate];
    
    if ([activityLog isActive]) {
        [activityLog addHeartRateEvent:timeStamp([NSNumber numberWithInteger:heartRate])];
    }
}

-(void)checkWarning:(double)p {

    bool doWarn = false;
    
    if (p > max) {
        doWarn = true;
    }

    if (!doWarn && didDismiss) {
        didDismiss = false;
    }
    
    if (!isWarning && doWarn && !didDismiss) {
        [self initiateWarning];
    } else if (isWarning && !doWarn) {
        [self dismissWarning];
    }

}

-(void) initiateWarning {
    isWarning = true;
    didDismiss = false;
    maxVibrator = [NSTimer scheduledTimerWithTimeInterval:1.1
                                                   target:self
                                                 selector:@selector(vibrate:)
                                                 userInfo:nil
                                                  repeats:YES];
    message = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                      message:@"Your heart rate is high."
                                                     delegate:self
                                            cancelButtonTitle:@"Dismiss"
                                            otherButtonTitles:nil];
    [message show];
}


-(void) dismissWarning {
    NSLog(@"Dismissing warning");
    isWarning = false;
    [maxVibrator invalidate];
    maxVibrator = nil;
    [message dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) vibrate:(id) sender {
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [NSThread sleepForTimeInterval:.2];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}


@end
