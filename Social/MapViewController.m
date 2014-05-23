//
//  MapViewController.m
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet UITextField *mapTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When the view is about to appear, set up the mapView.
- (void) viewWillAppear:(BOOL)animated
{
    [self setUpMap];
    
}


/**
 * This function uses the 'GoogleMaps' api to convert the passed 'address' parameter into latitude and longitude co-ordinates.
 * This function is called from the setUpMap function.
 * @param address : The address stored in the context for the 'Contact' object.
 * 
*/
- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}


/**
 * This function takes care of setting the mapView's region based on the latitude and longitude co-ordinates received from the geoCodeUsingAddress function define above.
 */
- (void) setUpMap
{
    // If the 'Contact' object does not have an address, set the default addressTextField text to be "Griffith University, Nathan."
    if([self.passedContact.address isEqualToString:@""])
    {
        self.mapTextField.text = @"Griffith University, Nathan";
    }
    else{
        self.mapTextField.text = self.passedContact.address;
    }
    CLLocationCoordinate2D myCoordinate = [self geoCodeUsingAddress:self.mapTextField.text];
    
    MKCoordinateRegion myRegion;
    myRegion.center.latitude = myCoordinate.latitude;
    myRegion.center.longitude = myCoordinate.longitude;
    self.mapView.region = myRegion;
}

- (void) viewWillDisappear:(BOOL)animated
{

}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // When the user changes the address in the mapTextField UITextField outlet, the address for the current 'Contact' object is updated and saved.
    // Then the setUpMap function is called to 'refresh' the mapView according to the newAddress.
    
    self.passedContact.address = self.mapTextField.text;
    NSError *error;
    
    [self.context save:&error];
    [self setUpMap];
    return YES;
}


// 

@end
