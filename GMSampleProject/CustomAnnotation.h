//
//  CustomAnnotation.h
//  GMSampleProject
//
//  Created by Sahil Behal on 5/11/16.
//  Copyright © 2016 Sahil Behal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>

@property(nonatomic,copy) NSString* title;
@property(nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) UIImage* annotationImage;
@property(nonatomic,copy) NSString* address;
@property(nonatomic,copy) NSString* distance;


-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;
@end
