//
//  GraphView.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-16.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "GraphView.h"
#include <stdlib.h>

@implementation GraphView


- (id)initWithFrame:(CGRect)frame array:(NSArray *)array shouldAverage:(BOOL)shouldAverage numDataPoints:(int)showLength {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _shouldAverage = shouldAverage;
        _dataArray = [[NSMutableArray alloc] initWithArray:array];
        [self initPlot];
        _minValue = -1;
        _maxValue = -1;
        _length = (showLength > 0)  ? showLength : 0;
        
        if (_shouldAverage) {
            [self calculateAveragesArray];
        }
        [self checkAndReplaceMinMax];
        
        CPTGraph *graph = self.hostView.hostedGraph;
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
        plotSpace.yRange  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(_minValue - 5) length:CPTDecimalFromFloat(_maxValue-_minValue+10)];
        plotSpace.xRange  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1*_length) length:CPTDecimalFromFloat(_length)];

        [self.hostView.hostedGraph reloadData];
    }
    return self;    
}

#pragma mark - Public Methods

- (void)addDataPoint:(CGFloat)dataPoint {
    [_dataArray addObject:[NSNumber numberWithFloat:dataPoint]];
    if (_shouldAverage) {
        [self calculateAveragesArray];
    }
    [self checkAndReplaceMinMax];
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.yRange  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(_minValue - 5) length:CPTDecimalFromFloat(_maxValue-_minValue+10)];
    plotSpace.xRange  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1*_length) length:CPTDecimalFromFloat(_length)];
    [self.hostView.hostedGraph reloadData];
}

#pragma mark - Helper Methods

- (void)checkAndReplaceMinMax {
    
    NSMutableArray *currentArray;
    if (_shouldAverage) {
        currentArray = _averageDataArray;
    } else {
        currentArray = _dataArray;
    }
    
    _minValue = CGFLOAT_MAX;
    _maxValue = -1;
    
    int length = MIN(_length, [currentArray count]);
    
    if (length == 0) {
        _minValue = 0;
        _maxValue = 0;
    }
    
    for (int i = 0; i < length ; i++) {
        CGFloat currentData = [[currentArray objectAtIndex:[currentArray count] - 1 - i] floatValue];
        
        if (_minValue > currentData) {
            _minValue = currentData;
        }
        if (_maxValue < currentData) {
            _maxValue = currentData;
        }
    }
    
 }


- (void)calculateAveragesArray {
    int numberPerCalculation = (int) [_dataArray count]/_length;
    if (numberPerCalculation <= 1) {
        _averageDataArray = [_dataArray mutableCopy];
    } else {
        _averageDataArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < _length; i++) {
            CGFloat tempTotal = 0;
            for (int j = 0; j < numberPerCalculation; j++) {
                tempTotal += [[_dataArray objectAtIndex:i*numberPerCalculation + j] floatValue];
            }
            int currentCalcLength = numberPerCalculation;
            if (i == _length - 1) {
                int remainder = [_dataArray count]%(_length*numberPerCalculation);
                currentCalcLength += remainder;
                for (int k = 0; k < remainder; k++) {
                    tempTotal += [[_dataArray objectAtIndex:[_dataArray count] - 1 - k] floatValue];
                }
            }
            [_averageDataArray addObject:[NSNumber numberWithFloat:(float)tempTotal/currentCalcLength]];
        }
    }
}


#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    NSMutableArray *currentArray;
    if (_shouldAverage) {
        currentArray = _averageDataArray;
    } else {
        currentArray = _dataArray;
    }
    
    
    
    if ([(NSString *)plot.identifier isEqualToString:@"first"]) {
        return MIN(_length, [currentArray count]); //> 0 ? [_dataArray count] - 1 : 0;
    } else {
        return ([currentArray count] > 1) ? 2 : 0;
    }
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    NSMutableArray *currentArray;
    if (_shouldAverage) {
        currentArray = _averageDataArray;
    } else {
        currentArray = _dataArray;
    }
    
    if ([(NSString *)plot.identifier isEqualToString:@"first"]) {
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:
                
                if (index == 0 && [currentArray count] > 1) {
                    return [NSNumber numberWithFloat:-0.1];
                }
                
                if (index < [currentArray count] ) {
                    return [NSNumber numberWithInt:-1*index];
                }
                break;
            case CPTScatterPlotFieldY:
                
                
                if (index == 0 && [currentArray count] > 1) {
                    CGFloat secondVal = [[currentArray objectAtIndex:[currentArray count] - 2] floatValue];
                    CGFloat firstVal = [[currentArray objectAtIndex:[currentArray count] - 1] floatValue];
                    
                    CGFloat tenthWay = secondVal + 9*(firstVal - secondVal)/10;
                    
                    return [NSNumber numberWithFloat:tenthWay];
                }
                
                return [NSNumber numberWithUnsignedInt: [[currentArray objectAtIndex:[currentArray count] - 1 - index] intValue]];
                
        }
        return [NSDecimalNumber zero];
    } else {
        switch (fieldEnum) {
            case CPTScatterPlotFieldX:
                if (index == 0) {
                    return [NSNumber numberWithInt:0];
                } else {
                    return [NSNumber numberWithFloat:-0.1];
                }
                break;
            case CPTScatterPlotFieldY:
                if (index == 0) {
                   return [NSNumber numberWithInt:[[currentArray objectAtIndex:[currentArray count] - 1] intValue]];
                } else {
                    CGFloat secondVal = [[currentArray objectAtIndex:[currentArray count] - 2] floatValue];
                    CGFloat firstVal = [[currentArray objectAtIndex:[currentArray count] - 1] floatValue];
                    
                    CGFloat tenthWay = secondVal + 9*(firstVal - secondVal)/10;
                    
                    return [NSNumber numberWithFloat:tenthWay];
                    //            return [NSNumber numberWithUnsignedInt:_someIndex];
                }
        }
        return [NSDecimalNumber zero];
    }
}



#pragma mark - Chart behavior

- (void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.bounds];
    [self addSubview:self.hostView];
    //    self.hostView.allowPinchScaling = YES;

    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.bounds;
    
    l.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
    l.startPoint = CGPointMake(0.0f, 1.0f);
    l.endPoint = CGPointMake(0.3f, 1.0f);
    self.hostView.layer.mask = l;
}

-(void)configureGraph {
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;

    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:5.0f];
    [graph.plotAreaFrame setPaddingBottom:5.0f];
    [graph.plotAreaFrame setPaddingTop:5.0f];
    [graph.plotAreaFrame setPaddingRight:35.0f];

    graph.plotAreaFrame.borderLineStyle = nil;
//
//    
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
//    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    // 2 - Create the three plots
    CPTScatterPlot *aaplPlot = [[CPTScatterPlot alloc] init];
    aaplPlot.dataSource = self;
    aaplPlot.identifier = @"first";
    CPTColor *aaplColor = [CPTColor blackColor];
    [graph addPlot:aaplPlot toPlotSpace:plotSpace];


    //    plotSpace.yRange  = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(5) length:CPTDecimalFromFloat(15)];

    CPTMutableLineStyle *aaplLineStyle = [aaplPlot.dataLineStyle mutableCopy];
    aaplLineStyle.lineWidth = 9;
    aaplLineStyle.lineColor = aaplColor;
    aaplLineStyle.lineJoin = kCGLineJoinRound;
    aaplPlot.dataLineStyle = aaplLineStyle;
    
    CPTScatterPlot *greenPlot = [[CPTScatterPlot alloc] init];
    greenPlot.dataSource = self;
    greenPlot.identifier = @"second";
    CPTColor *greenColor = [CPTColor greenColor];
    [graph addPlot:greenPlot toPlotSpace:plotSpace];
    
    CPTMutableLineStyle *greenLineStyle = [greenPlot.dataLineStyle mutableCopy];
    greenLineStyle.lineWidth = 9;
    greenLineStyle.lineColor = greenColor;
    greenLineStyle.lineJoin = kCGLineJoinRound;
    greenPlot.dataLineStyle = greenLineStyle;
    
    [graph.defaultPlotSpace scaleToFitPlots:[NSArray arrayWithObjects:aaplPlot,greenPlot, nil]];

}

-(void)configureAxes {
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor clearColor];
    
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor lightGrayColor];
    gridLineStyle.lineWidth = 3.0f;
     // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    CPTAxis *x = axisSet.xAxis;
    x.hidden = YES;
    
    NSNumberFormatter *yAxisFormat = [[NSNumberFormatter alloc] init] ;
    [yAxisFormat setNumberStyle:NSNumberFormatterNoStyle];

    CPTAxis *y = axisSet.yAxis;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyFixedInterval;
    y.majorTickLineStyle = axisLineStyle;
    y.majorIntervalLength = CPTDecimalFromInteger(10);
    y.labelFormatter = yAxisFormat;
    y.minorTicksPerInterval = 0;
    y.tickDirection = CPTSignPositive;
}

@end
