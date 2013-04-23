
//
//  MapView.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-30.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "MapView.h"

@implementation MapView

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)locationArray {
    self = [super initWithFrame:frame];
    
    if (self) {
        _locationArray = [[NSMutableArray alloc] initWithArray:locationArray];
        _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
        [self addSubview:_mapView];
        _mapView.delegate = self;
        [self setupMap];
    }
    return self;
}


#pragma mark - Public Method

- (void)addLocation:(CLLocation *)location {
    if (_locationArray == nil) {
        _locationArray = [[NSMutableArray alloc] init];
    }
    
    [_locationArray addObject:location];
    [self setupMap];
}

#pragma mark - Setup Method

- (void)setupMap {
    [_mapView setRegion:[self getMapRegion]];
    [_mapView setUserInteractionEnabled:YES];
    [self setupMapPath];
}

- (void)setupMapPath {
    int numPoints = [_locationArray count];
    CLLocationCoordinate2D* coords = malloc(numPoints * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < numPoints; i++) {
        CLLocation* current = [_locationArray objectAtIndex:i];
        coords[i] = current.coordinate;
    }
    
    _line = [MKPolyline polylineWithCoordinates:coords count:[_locationArray count]];
    
    free(coords);
    
    [_mapView addOverlay:_line];
    [_mapView setNeedsDisplay];
}

#pragma mark - MKMapViewDelegate Methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineView* lineView = [[MKPolylineView alloc] initWithPolyline:_line];
    lineView.fillColor = [UIColor redColor];
    lineView.strokeColor = [UIColor redColor];
    lineView.lineWidth = 4;
    return lineView;
}


#pragma mark - Helper Methods

- (MKCoordinateRegion)getMapRegion {
    MKCoordinateRegion region;
    if ([_locationArray count] == 0) {
        CLLocationCoordinate2D coord =CLLocationCoordinate2DMake(37.785834,-122.406417);
        MKCoordinateSpan span = MKCoordinateSpanMake(0.001,0.001);
        region.center = coord;
        region.span = span;
    } else {
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        
        for(int idx = 0; idx < _locationArray.count; idx++) {
            CLLocation* currentLocation = [_locationArray objectAtIndex:idx];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        
        region.center.latitude = (maxLat + minLat) / 2;
        region.center.longitude = (maxLon + minLon) / 2;
        region.span.latitudeDelta = maxLat - minLat + .0001;
        region.span.longitudeDelta = maxLon - minLon + .0001;
        
    }
    
    return region;
}



@end
