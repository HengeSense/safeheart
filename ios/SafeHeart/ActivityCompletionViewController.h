//
//  ActivityCompletionViewController.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-26.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLog.h"
#import "MetricView.h"
#import "ViewUtil.h"
#import "GraphView.h"
#import "MapView.h"
#import "PieChartView.h"

@interface ActivityCompletionViewController : UIViewController <MKMapViewDelegate>{
    
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UIView *_graphsContainer;
    IBOutlet UIButton *_facebookButton;
    IBOutlet UIButton *_twitterButton;
    IBOutlet UIView *_metricView;
    UISegmentedControl *_segmentControl;

    MetricView* timeMetric;
    MetricView* distanceMetric;
    MetricView* caloriesMetric;
    
    GraphView *_heartRateGraph;
    MapView *_mapView;
    PieChartView *_pieChart;
}

@property (nonatomic, strong) ActivityLog *activityLog;

- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;

- (IBAction)doneBarButtonPressed:(id)sender;

@end
