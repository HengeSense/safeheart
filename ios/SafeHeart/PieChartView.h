//
//  PieChartView.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-30.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot/CorePlotHeaders/CorePlot-CocoaTouch.h"


@interface PieChartView : UIView <CPTPieChartDataSource> {
    NSMutableArray *_caloriesArray;
    int _lowCount;
    int _medCount;
    int _highCount;
}

@property (nonatomic, strong) CPTGraphHostingView *hostView;


- (id)initWithFrame:(CGRect)frame array:(NSArray *)array;

@end
