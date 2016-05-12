//
//  ViewController.m
//  GMSampleProject
//
//  Created by Sahil Behal on 5/11/16.
//  Copyright © 2016 Sahil Behal. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"


@interface ViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@end

@implementation ViewController{
    NSArray* yourKeys;
    NSDictionary* json;
    CustomAnnotation* mapAnnotationJoblist;
    CLLocationManager* locationManager;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    yourKeys = [NSArray new];
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
  
    
    _customMapView.delegate = self;
    _customMapView.showsUserLocation = YES;
    
  
    [self getJSON];
    [self createAnnotations];
}

-(void)getJSON{
    NSURL *url=[NSURL URLWithString:@"https://coinatmradar.com/api/locations/2016-04-20"];
    NSData* data = [NSData dataWithContentsOfURL: url];
    NSError * error;
    json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    yourKeys = [json allKeys];
}


- (NSMutableArray *)createAnnotations{
    NSMutableArray * annotations = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [yourKeys count]; i++) {
        NSString* title =[NSString stringWithFormat:@"%@, %@", json[yourKeys[i]][@"lat"], json[yourKeys[i]][@"long"]];
      
   
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:title completionHandler:^(NSArray *placemarks, NSError *error){
            if(!error){
                
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                MKCoordinateRegion region = _customMapView.region;
                region.center = [(CLCircularRegion *)placemark.region center];
                
                [_customMapView setRegion:region animated:YES];
 
                
                CLLocationCoordinate2D Coordinates = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                
                
                
                mapAnnotationJoblist = [[CustomAnnotation alloc]initWithTitle:[NSString stringWithFormat:@"%@,%@",placemark.name, placemark.locality] Location:Coordinates];
                NSArray* distanceArray = yourKeys;
                
                mapAnnotationJoblist.address = distanceArray[i];
                [_customMapView addAnnotation:mapAnnotationJoblist];
            }
            else{
                NSLog(@"There was a forward geocoding error\n%@",[error localizedDescription]);
            }
        }];
    }
    return annotations;
    
}

#pragma mark - MapView Delegate.

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation  *myLocation = (CustomAnnotation *)annotation;
        MKAnnotationView* annotationView = [_customMapView dequeueReusableAnnotationViewWithIdentifier:@"MapCustomAnnotation"];
        
        annotationView.canShowCallout = YES;
        
        
        CLLocation *pinLocation = [[CLLocation alloc]
                                   initWithLatitude:annotation.coordinate.latitude
                                   longitude:annotation.coordinate.longitude];
        
        CLLocation *userLocation = [[CLLocation alloc]
                                    initWithLatitude:mapView.userLocation.coordinate.latitude
                                    longitude:mapView.userLocation.coordinate.longitude];
        
        CLLocationDistance distance = [pinLocation distanceFromLocation:userLocation]/1600;
        
        float temp = distance/1600;
        
        if (annotationView == nil) {
            annotationView = myLocation.annotationView;
           
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 75, 45)];
            [btn setTitle:[NSString stringWithFormat:@"%.2f mi",temp] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            [btn setBackgroundColor:[UIColor blueColor]];

            annotationView.leftCalloutAccessoryView =btn;
            
        }
        else{
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}




@end
