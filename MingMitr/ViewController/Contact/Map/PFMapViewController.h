//
//  PFMapViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

@protocol PFMapViewControllerDelegate <NSObject>

- (void) PFMapViewControllerBack;

@end

@interface PFMapViewController : UIViewController <CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet PFMapView *mapView;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) id<PFMapViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *locationname;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@end
