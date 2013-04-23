//
//  PieChartView.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-30.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "PieChartView.h"
#import "LoginManager.h"

#define LOW_INTENSITY 0.001
#define MED_INTENSITY 0.003

@implementation PieChartView

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        _lowCount = 0;
        _medCount = 0;
        _highCount = 0;
        _caloriesArray = [[NSMutableArray alloc] initWithArray:array];
        [self analyseArray];
        [self initPlot];
    }
    return self;
}

#pragma mark - Init Methods

-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}


#pragma mark - Setup Methods

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.bounds];
    self.hostView.allowPinchScaling = NO;
    [self addSubview:self.hostView];
}

-(void)configureGraph {
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;
    // 2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    textStyle.fontName = @"Helvetica-Bold";
    textStyle.fontSize = 16.0f;
    // 3 - Configure title
    NSString *title = @"Intensity Levels";
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    // 4 - Set theme
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.plotAreaFrame.borderLineStyle = nil;

}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph *graph = self.hostView.hostedGraph;
    // 2 - Create chart
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.40) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = 0;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    // 3 - Create gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    // 4 - Add chart to graph    
    [graph addPlot:pieChart];
}

-(void)configureLegend {

}


#pragma mark - Helper Methods

- (void)analyseArray {
    double weight = [[[[LoginManager sharedInstance] user] weight] doubleValue];
    for (int i = 0; i < [_caloriesArray count]; i++) {
        NSNumber *calValue = [_caloriesArray objectAtIndex:i];
        double intensity = [calValue floatValue];
        if (i != 0) {
            intensity = intensity - [(NSNumber *)[_caloriesArray objectAtIndex:i-1] floatValue];
        }
        intensity = intensity/weight;
        if (intensity < LOW_INTENSITY) {
            _lowCount++;
        } else if (intensity < MED_INTENSITY) {
            _medCount++;
        } else {
            _highCount++;
        }
    }
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 3;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (CPTPieChartFieldSliceWidth == fieldEnum) {
        if (index == 0) {
            return [NSNumber numberWithInt:_highCount];
        } else if (index == 1) {
            return [NSNumber numberWithInt:_medCount];
        } else {
            return [NSNumber numberWithInt:_lowCount];
        }
    }
    return [NSDecimalNumber zero];;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    // 1 - Define label text style
    static CPTMutableTextStyle *labelText = nil;
    if (!labelText) {
        labelText= [[CPTMutableTextStyle alloc] init];
        labelText.color = [CPTColor grayColor];
    }
    
    NSString *percentageString;
    float totalCount = (float)(_lowCount + _medCount + _highCount);
    if (index == 0) {
        if (_highCount > 0) {
            percentageString = [NSString stringWithFormat:@"%.02f%% High",100.0f*(float)(_highCount/totalCount)];
        }
    } else if (index == 1) {
        if (_medCount > 0) {
            percentageString = [NSString stringWithFormat:@"%.02f%% Med",100.0f*(float)(_medCount/totalCount)];
        }
    } else {
        if (_lowCount > 0) {
            percentageString = [NSString stringWithFormat:@"%.02f%% Low",100.0f*(float)(_lowCount/totalCount)];
        }
    }
    
    return [[CPTTextLayer alloc] initWithText:percentageString style:labelText];
}


-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    return nil;
}


@end
