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

#import "TimelineEntry.h"

#define USER_FLICKR_API_KEY @"59f3dbe40e6f3d1f62678573b1145dce"
#define DEFAULT_MAX_RESULTS     25


@interface FlickrTableViewController ()

@property FlickrAPI *flickrAPI;
@property NSMutableArray *flickr_user_photos;
@property NSString *userName;


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
    self.userName = [self.passedAccount valueForKey:@"identifier"];
    // Check if Flickr Data is already existing for the account.
    
    
    if([[self.passedAccount entries] count] == 0){
        [self loadFlickrData];
    }
    else{
        self.flickr_user_photos = [[self sortedFeedsReturn] mutableCopy];
    }
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
    TimelineEntry  *entry = [self.flickr_user_photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [entry valueForKeyPath:@"text"];
    cell.detailTextLabel.text = [self.passedAccount identifier];
    return cell;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Add Flickr feed to the SocialMedia's Timeline Entries.
    // Save context.
    NSError *error;
    [self.context save:&error];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
}


- (void) loadFlickrData
{
    
}



/*
 The 'Entries' entity in the SocialMediaAccount object is a set. Before any manipulation can take place, it must first be sorted.
 This function sorts the NSSet according to the tweet's title/text.
 */
- (NSArray *) sortedFeedsReturn
{
    SocialMediaAccount *account = self.passedAccount;
    
    NSSet *feedSet = [account entries];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
    NSArray *sortedFeeds = [feedSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameSort]];
    
    return sortedFeeds;
}

// Manual refreshing of Flickr Data.
/*- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
    [self loadFlickrData];
}*/
@end
