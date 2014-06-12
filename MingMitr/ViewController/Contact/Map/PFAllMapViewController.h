//
//  PFAllMapViewController.h
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMapView.h"
#import "CMMapLauncher.h"

#import "PFMingMitrSDK.h"

@protocol PFAllmapViewControllerDelegate <NSObject>

- (void) PFAllmapViewControllerBack;

@end

@interface PFAllMapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet PFMapView *allmapView;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) id <PFAllmapViewControllerDelegate> delegate;

@property (strong, nonatomic) PFMingMitrSDK *mingmitrSDK;
@property (retain, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@end
