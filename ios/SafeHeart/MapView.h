//
//  MapView.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-30.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapView : UIView <MKMapViewDelegate> {
    NSMutableArray *_locationArray;
    MKMapView *_mapView;
    MKPolyline* _line;
}

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)locationArray;
- (void)addLocation:(CLLocation *)location;

@end
