//
//  ActivityCompletionViewController.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-26.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ActivityCompletionViewController.h"
#import "TimeStampedEvent.h"
#import "Colors.h"
#import <Social/Social.h>

@interface ActivityCompletionViewController ()

@end

@implementation ActivityCompletionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentController];
    [_twitterButton setEnabled:[SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]];
    [_facebookButton setEnabled:[SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupGraphs];
    [self setupMetrics];
    [self setupMap];
    [self setupPieChart];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupMap {
    _mapView = [[MapView alloc] initWithFrame:_graphsContainer.bounds andArray:[self getLocationArray]];
}


- (void)setupPieChart {
    _pieChart = [[PieChartView alloc] initWithFrame:_graphsContainer.bounds array:[self getCaloriesArray]];
}



- (void)setupMetrics {
    timeMetric = [MetricView getViewForMetric:MetricTime];
    distanceMetric = [MetricView getViewForMetric:MetricDistance];
    caloriesMetric = [MetricView getViewForMetric:MetricCalories];
    
    _metricView.alpha = 1.0f;
    [_metricView addSubview:timeMetric];
    [_metricView addSubview:distanceMetric];
    [_metricView addSubview:caloriesMetric];
    
    NSLog(@"Frame %@",NSStringFromCGRect(_metricView.frame));
    double width = self.view.frame.size.width;//320;//self.metricView.frame.size.width;
    
    NSLog(@"%f",width);
    NSLog(@"%f\n",timeMetric.frame.size.width);
    [ViewUtil center:timeMetric OnXPosition:width*0.2];
    [ViewUtil center:distanceMetric OnXPosition:width*0.5];
    [ViewUtil center:caloriesMetric OnXPosition:width*0.8];
    
    [timeMetric setMetricValue:[self timeFormatted:[_activityLog duration]]];
    [distanceMetric setMetricValue:[NSString stringWithFormat:@"%.1fm",[_activityLog getTotalDistance]]];
    [caloriesMetric setMetricValue:[self calorieValue]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Methods

- (void)setupSegmentController {
    NSArray *itemArray = [NSArray arrayWithObjects: @"Heart Rate", @"Calories", @"Map", nil];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [_segmentControl setFrame:CGRectMake(10.0f, 54.0f, 300.0f, 35.0f)];
    _segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self
                         action:@selector(segmentChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    UIColor *newTintColor = [UIColor colorWithRed: 150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _segmentControl.tintColor = newTintColor;
    
    [self.view addSubview:_segmentControl];

}

- (void)setupGraphs {
//    NSArray *tempArray = @[@94.0f,@96.0f,@74.0f,@88.0f,@84.0f,@86.0f,@124.0f,@34.0f,@95.0f,@54.0f,@64.0f,@130.0f,@120.0f,@123.0f];
    NSArray *heatRateArray = [self getHeartRateArray];
    _heartRateGraph = [[GraphView alloc] initWithFrame:_graphsContainer.bounds array:heatRateArray shouldAverage:YES numDataPoints:10];
    _heartRateGraph.frame = _graphsContainer.bounds;
    [_graphsContainer addSubview:_heartRateGraph];
}


#pragma mark - Segment Controller

- (void)segmentChanged:(id)sender {
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [self showHeartRate];
    } else if ([segmentedControl selectedSegmentIndex] == 1) {
        [self showPieChart];
    } else {
        [self showMap];
    }
}

#pragma mark - Social Button Methods

- (IBAction)twitterButtonPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[self shareString]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (IBAction)facebookButtonPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        
        SLComposeViewController *fb=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];

        [fb setInitialText:[self shareString]];
        [self presentViewController:fb animated:YES completion:nil];
    }
}

- (IBAction)doneBarButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Segement Control Helper Methods

- (void)showHeartRate {
    [_mapView removeFromSuperview];
    [_pieChart removeFromSuperview];
    [_graphsContainer addSubview:_heartRateGraph];
}

- (void)showMap {
    [_heartRateGraph removeFromSuperview];
    [_pieChart removeFromSuperview];
    [_graphsContainer addSubview:_mapView];
}

- (void)showPieChart {
    [_heartRateGraph removeFromSuperview];
    [_mapView removeFromSuperview];
    [_graphsContainer addSubview:_pieChart];
}


#pragma mark - Helper methods

- (NSArray *)getLocationArray {
    NSMutableArray *locationArray = [[NSMutableArray alloc] init];
    for (TimeStampedEvent *event in _activityLog.locationEvents) {
        [locationArray addObject:(CLLocation *)(event.payload)];
    }
    return locationArray;
}

- (NSArray *)getCaloriesArray {
    NSMutableArray *caloriesArray = [[NSMutableArray alloc] init];
    for (TimeStampedEvent *event in _activityLog.calorieEvents) {
        [caloriesArray addObject:(NSNumber *)(event.payload)];
    }
    return caloriesArray;
}

- (NSArray *)getHeartRateArray {
    NSMutableArray *heartRateArray = [[NSMutableArray alloc] init];
    for (TimeStampedEvent *event in _activityLog.heartRateEvents) {
        [heartRateArray addObject:(NSNumber *)(event.payload)];
    }
    return heartRateArray;
}

- (NSString *)calorieValue {
    return [NSString stringWithFormat:@"%.1f",[_activityLog calories]];
}

- (NSString *)shareString {
    return  [NSString stringWithFormat:@"Completed my workout using SafeHeart iOS app"];
}

- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end
