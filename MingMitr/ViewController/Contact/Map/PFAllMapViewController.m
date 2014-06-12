//
//  PFAllMapViewController.m
//  MingMitr
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import "PFAllMapViewController.h"

@interface PFAllMapViewController ()

@end

@implementation PFAllMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Get Direction" style:UIBarButtonItemStyleDone target:self action:@selector(getDistance)];
    [anotherButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont fontWithName:@"Helvetica" size:17.0],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = anotherButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.mingmitrSDK = [[PFMingMitrSDK alloc] init];
    self.mingmitrSDK.delegate = self;
    self.lng = [[NSString alloc] init];
    self.lat = [[NSString alloc] init];
    self.arrObj = [[NSMutableArray alloc] init];
    
    [self.mingmitrSDK getContact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)PFMingMitrSDK:(id)sender getContactResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    
    for (int i=0; i < [[response objectForKey:@"locations"] count]; i++) {
        
        NSString *getlat = [NSString stringWithFormat:@"%@", [[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lat"]];
        
        NSString *getlng = [NSString stringWithFormat:@"%@", [[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"lng"]];
        
        NSString *getname = [NSString stringWithFormat:@"%@", [[[response objectForKey:@"locations"] objectAtIndex:i] objectForKey:@"name"]];
        
        //
        CLLocationCoordinate2D location;
        location.latitude = [getlat doubleValue];
        location.longitude = [getlng doubleValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = location;
        point.title = getname;
        
        
        [self.allmapView addAnnotation:point];
        //[self.allmapView selectAnnotation:point animated:NO];
        
        [self.allmapView setCenterCoordinate:location zoomLevel:13 animated:NO];
        //
        
    }
    
}
- (void)PFMingMitrSDK:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

//get Distane

- (void)getDistance {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentLocation = newLocation;
    CLLocationCoordinate2D location;
	location.latitude = [self.lat doubleValue];
	location.longitude = [self.lng doubleValue];
    [self.locationManager stopUpdatingLocation];
    [CMMapLauncher launchMapApp:CMMapAppAppleMaps
              forDirectionsFrom:[CMMapPoint mapPointWithName:@"Origin"
                                                  coordinate:newLocation.coordinate]
                             to:[CMMapPoint mapPointWithName:@"Destination"
                                                  coordinate:location]];
    return;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFAllmapViewControllerBack)]){
            [self.delegate PFAllmapViewControllerBack];
        }
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"Tapped on: %@", view.annotation.title);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MKPointAnnotation *selectedAnnotation = view.annotation;
    self.lat = [[NSString alloc] initWithFormat:@"%f",selectedAnnotation.coordinate.latitude];
    self.lng = [[NSString alloc] initWithFormat:@"%f",selectedAnnotation.coordinate.longitude];
    
    //NSLog(@"%@",NSStringFromCGRect());
}

@end
