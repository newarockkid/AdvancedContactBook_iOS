//
//  DetailViewController.m
//  Social
//
//  Created by Nishant Shrestha on 18/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "DetailViewController.h"
#import "SocialMediaAccountViewController.h"

#import "Contact.h"

@interface DetailViewController ()

// Outlets for the UI elements.

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *imageURLField;

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


- (void) configureView
{
    Contact *contact = self.detailItem;
    
    self.firstNameField.text = contact.firstName;
    self.lastNameField.text = contact.lastName;
    //self.addressLabel.text = contact.address;
    self.imageURLField.text = contact.imageURL;
    self.imageView.image = [UIImage imageWithData:contact.image];
}


#pragma mark - Table View Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell"];
    
    Contact *contact = self.detailItem;
   
    NSSet *socialSiteSet = [contact sites];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"accountType" ascending:YES];
    NSArray *sortedSites = [socialSiteSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSort]];
    
    id social = sortedSites[indexPath.row];
    
    cell.textLabel.text = [social valueForKey:@"identifier"];
    cell.detailTextLabel.text = [social valueForKey:@"accountType"];
    return cell;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.detailItem sites] count];
}

#pragma mark - UITextField Delegate Method

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.imageURLField){
        NSURL *imgURL = [NSURL URLWithString:self.imageURLField.text];
        
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


#pragma mark - Segue Preparation 

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [[segue identifier] isEqualToString:@"addSocial"])
    {
        SocialMediaAccountViewController *svc = [segue destinationViewController];
        svc.context = self.context;
        
        svc.passedContact = self.detailItem;
    }
}


- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}



- (void) viewWillDisappear:(BOOL)animated
{
    // Should do this in the MasterViewController. Call a delegate method for it.
    Contact *contact = self.detailItem;
    contact.firstName = self.firstNameField.text;
    contact.lastName = self.lastNameField.text;
    //contact.address = self.addressLabel.text;
    contact.imageURL = self.imageURLField.text;
    contact.image = self.tempImageData;
    
    NSError *error;
    [self.context save:&error];
}
@end
