//
//  MapViewController.m
//  Landa
//
//  Created by muhammad abed el razek on 6/20/14.
//  Copyright (c) 2014 muhammad abed el razek. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

static const double TAUBX =  32.777658 ;
static const double TAUBY  = 35.021373;
static const double RABINX =  32.778789;
static const double  RABINY = 35.022141;
static const double  ARCHX = 32.777806;
static const double  ARCHY =  35.022337;
static const double ULMANX =  32.777039;
static const double ULMANY  = 35.023238;
static const double FISHBACHX  = 32.776369;
static const double FISHBACHY =  35.024051;
static const double MAYERX  = 32.775589;
static const double MAYERY =  35.024882;
static const double CHEMX = 32.778155;
static const double CHEMY =  35.027575;

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
    zoomLocation.latitude = 0;
    zoomLocation.longitude = 0;

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
    if (!([self.place rangeOfString:@"רבין"].location==NSNotFound))
    {
        zoomLocation.latitude = RABINX;
        zoomLocation.longitude= RABINY;
    }
    if (!([self.place rangeOfString:@"סגו"].location==NSNotFound))
    {
        zoomLocation.latitude = ARCHX;
        zoomLocation.longitude= ARCHY;
    }
    if (!([self.place rangeOfString:@"פישבך"].location==NSNotFound))
    {
        zoomLocation.latitude = FISHBACHX;
        zoomLocation.longitude= FISHBACHY;
    }
    if (!([self.place rangeOfString:@"מאיר"].location==NSNotFound))
    {
        zoomLocation.latitude = MAYERX;
        zoomLocation.longitude= MAYERY;
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
