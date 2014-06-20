//
//  MapViewController.h
//  Landa
//
//  Created by muhammad abed el razek on 6/20/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong , nonatomic) NSString* place;

@end
