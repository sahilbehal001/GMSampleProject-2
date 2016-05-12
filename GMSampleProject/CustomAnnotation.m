//
//  CustomAnnotation.m
//  GMSampleProject
//
//  Created by Sahil Behal on 5/11/16.
//  Copyright © 2016 Sahil Behal. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize title, coordinate, address, distance, annotationImage;

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location{
    self = [super init];
    if (self) {
        title = newTitle;
        coordinate = location;
        
    }
    return self;
}


-(MKAnnotationView *)annotationView{
    MKAnnotationView* annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MapCustomAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"map_icon.png"];
    annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
    return annotationView;
}

@end
