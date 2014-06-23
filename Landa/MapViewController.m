//
//  MapViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 6/20/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

#define TAUBX 32.777658
#define TAUBY 35.021373
#define RABINX 32.778789
#define RABINY  35.022141
#define ARCHX 32.777806
#define ARCHY 35.022337
#define ULMANX 32.777039
#define ULMANY 35.023238
#define FISHBACHX 32.776369
#define FISHBACHY 35.024051
#define MAYERX 32.775589
#define MAYERY 35.024882
#define CHEMX 32.778155
#define CHEMY 35.027575

#define ULMAN אולמן

@interface MapViewController ()

@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied))
    {
        [[[UIAlertView alloc] initWithTitle:@"שגיאה" message:@"נא להפעיל שירות מיקום לקבך מידע עדכני" delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles: nil] show];
        // show the map
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;

    if (!([self.place rangeOfString:@"אולמן"].location==NSNotFound))
    {
        zoomLocation.latitude = ULMANX;
        zoomLocation.longitude= ULMANY;
    }
    if (!([self.place rangeOfString:@"טאוב"].location==NSNotFound))
    {
        zoomLocation.latitude = TAUBX;
        zoomLocation.longitude= TAUBY;
    }
    if (!([self.place rangeOfString:@"כימיה"].location==NSNotFound))
    {
        zoomLocation.latitude = CHEMX;
        zoomLocation.longitude= CHEMY;
    }
    
    //CLLocationCoordinate2D locationToZoom = zoomLocation;

    // 1
    MKPlacemark *mPlacemark = [[MKPlacemark alloc] initWithCoordinate:zoomLocation addressDictionary:nil];

    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_mapView addAnnotation:mPlacemark];
    [_mapView setRegion:viewRegion animated:YES];
}


@end
