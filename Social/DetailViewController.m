//
//  DetailViewController.m
//  Social
//
//  Created by Nishant Shrestha on 18/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "DetailViewController.h"
#import "SocialMediaAccountViewController.h"
#import "WebsiteViewController.h"
#import "FeedTableViewController.h"
#import "FlickrTableViewController.h"
#import "MapViewController.h"

#import "Contact.h"

@interface DetailViewController ()

// Outlets for the UI elements.

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *imageURLField;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addSocialButtonPressed;

@property NSData *tempImageData;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Function to set up the various UI elements of the view.
- (void) configureView
{
    Contact *contact = self.detailItem;
    
    self.firstNameField.text = contact.firstName;
    self.lastNameField.text = contact.lastName;
    
    if(contact.address)
    {
        self.addressLabel.text = contact.address;
        
    }
    else{
        self.addressLabel.text = @"Click View Map to enter address.";
    }
    self.imageURLField.text = contact.imageURL;
    self.imageView.image = [UIImage imageWithData:contact.image];
}


#pragma mark - Table View Delegate Methods

// Configure the cell based on the data returned from the database.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell"];

    NSArray *sortedSites = [self sortedSitesReturn];

    id social = sortedSites[indexPath.row];
    
    cell.textLabel.text = [social valueForKey:@"identifier"];
    cell.detailTextLabel.text = [social valueForKey:@"accountType"];
    return cell;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.detailItem sites] count];
}


// Allow editing of the TableView that lists the SocialMediaAccount for the Contact.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *sortedSites = [self sortedSitesReturn];
        
        Contact *contact = self.detailItem;
        SocialMediaAccount *deletingSocial = sortedSites[indexPath.row];
        
        [contact removeSitesObject:deletingSocial];
        [self.tableView reloadData];
        NSError *error = nil;
        if (![self.context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark - UITextField Delegate Method

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.imageURLField){
        NSURL *imgURL = [NSURL URLWithString:self.imageURLField.text];
        
        // Download the image in a 'background' queue, so that it does not cause the application to be unresponsive during image download.
        dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(background, ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            UIImage *image = [UIImage imageWithData:imgData];
            self.tempImageData = imgData;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
                UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            });
        });
        
        [textField resignFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sortedSites = [self sortedSitesReturn];
    
    id social = sortedSites[indexPath.row];
    
    // Perform the segue based on the type of 'SocialMediaAccount' that is selected.
    if([[social valueForKey:@"accountType"] isEqualToString:@"Website"]){
        NSLog(@"Website");
        [self performSegueWithIdentifier:@"showWebView" sender:social];
        
    }
    else if([[social valueForKey:@"accountType"] isEqualToString:@"Twitter"]){
        NSLog(@"Twitter Feed");
        [self performSegueWithIdentifier:@"showFeedView" sender:social];
    }
    else if([[social valueForKey:@"accountType"] isEqualToString:@"Flickr"]){
        NSLog(@"Flickr Feed");
        [self performSegueWithIdentifier:@"showFlickrView" sender:social];
    }
    
}


#pragma mark - Segue Preparation 

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Segue to add a new social account.
    if([[segue identifier] isEqualToString:@"addSocial"])
    {
        SocialMediaAccountViewController *svc = [segue destinationViewController];
        svc.context = self.context;
        svc.passedContact = self.detailItem;
    }
    
    // Segue to show the 'Contact's webpage.
    else if([[segue identifier] isEqualToString:@"showWebView"])
    {
        WebsiteViewController *wvc = [segue destinationViewController];
        wvc.passedWebsiteURL = [sender valueForKey:@"identifier"];
    }
    
    // Segue to show 'Contact's Twitter Feed.
    else if ([[segue identifier] isEqualToString:@"showFeedView"])
    {
        FeedTableViewController *fvc = [segue destinationViewController];
        fvc.passedAccount = sender;
        fvc.context = self.context;
       
        NSLog(@"Username: %@ , For Account Type:  %@", [sender valueForKey:@"identifier"], [sender valueForKey:@"accountType"]);
    }
    
    // Segue to show 'Contact's Flickr Feed.
    else if ([[segue identifier] isEqualToString:@"showFlickrView"])
    {
        FlickrTableViewController *fvc = [segue destinationViewController];
        fvc.passedAccount = sender;
        fvc.context = self.context;
        
        NSLog(@"Username: %@ , For Account Type:  %@", [sender valueForKey:@"identifier"], [sender valueForKey:@"accountType"]);
    }
    
    // Segue to show 'Contact's address in a mapView.
    else if([[segue identifier] isEqualToString:@"showMapView"])
    {
        MapViewController *mvc = [segue destinationViewController];
        mvc.context = self.context;
        mvc.passedContact = self.detailItem;
    }

}

// Configure the view controller, when it is about to appear.
- (void) viewWillAppear:(BOOL)animated
{
    [self configureView];
    [self.tableView reloadData];
}



/*
 ** This takes in the current Contact managedObject and returns an NSArray that contains all the social media accounts sorted alphabetically according to the accountType.
 
    Sorting is essential for NSSet to work properly.
 
    Possible accountTypes are: "Flickr", "Twitter" & "Website".
*/
- (NSArray *) sortedSitesReturn
{
    Contact *contact = self.detailItem;
    
    NSSet *socialSiteSet = [contact sites];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"accountType" ascending:YES];
    NSArray *sortedSites = [socialSiteSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSort]];
    
    return sortedSites;
}


// Save the context whenever the view will disappear.
- (void) viewWillDisappear:(BOOL)animated
{
    Contact *contact = self.detailItem;
    contact.firstName = self.firstNameField.text;
    contact.lastName = self.lastNameField.text;
    contact.imageURL = self.imageURLField.text;
    contact.image = self.tempImageData;
    
    NSError *error;
    [self.context save:&error];
}
@end
