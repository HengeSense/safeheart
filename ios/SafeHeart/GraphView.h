//
//  GraphView.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-16.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot/CorePlotHeaders/CorePlot-CocoaTouch.h"


@interface GraphView : UIView <CPTPlotDataSource> {
    NSMutableArray *_dataArray;
    CGFloat _maxValue;
    CGFloat _minValue;
    BOOL _shouldAverage;
    int _length;

    NSMutableArray *_averageDataArray;
    
}
@property (nonatomic, strong) CPTGraphHostingView *hostView;


/*
 Leave array = nil if no array is available at initialaization
 numDataPoints is the number of data points on x axis to show
 
*/

- (id)initWithFrame:(CGRect)frame array:(NSArray *)array shouldAverage:(BOOL)shouldAverage numDataPoints:(int)showLength;



//Add data is new data becomes available
- (void)addDataPoint:(CGFloat)dataPoint;

@end
