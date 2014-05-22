//
//  FlickrTableViewController.m
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "FlickrAPI.h"
#import "FlickrImageViewController.h"


#define USER_FLICKR_API_KEY @"59f3dbe40e6f3d1f62678573b1145dce"
#define DEFAULT_MAX_RESULTS     25


@interface FlickrTableViewController ()

@property FlickrAPI *flickrAPI;
@property NSMutableArray *flickr_user_photos;


@end

@implementation FlickrTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.flickrAPI = [[FlickrAPI alloc] initWithAPIKey:USER_FLICKR_API_KEY];
    self.flickr_user_photos = [[self.flickrAPI photosForUserName:@"strictfunctor"] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.flickr_user_photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.flickr_user_photos[indexPath.row] valueForKey:@"title"];
    return cell;
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Add Flickr feed to the SocialMedia's Timeline Entries.
    // Save context.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
