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
    
    // Check if Flickr Data is already existing for the account.
    if([[self.passedAccount entries] count] == 0){
        [self loadFlickrData];
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
    cell.textLabel.text = [self.flickr_user_photos[indexPath.row] valueForKey:@"title"];
    return cell;
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Add Flickr feed to the SocialMedia's Timeline Entries.
    // Save context.
    NSError *error;
    [self.context save:&error];
    NSLog(@"Saved Flickr Data");
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FlickrImageViewController *fivc = [segue destinationViewController];
    
    fivc.flickrAPI = self.flickrAPI;
    fivc.context = self.context;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    fivc.tempObject = [self.flickr_user_photos objectAtIndex:indexPath.row];

}


- (void) loadFlickrData
{
    dispatch_queue_t background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(background, ^{
        UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
        self.flickr_user_photos = [[self.flickrAPI photosForUserName:[self.passedAccount identifier]] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            [self populateCoreData];
            [self.tableView reloadData];
        });
    });
    
}

- (void) populateCoreData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimelineEntry" inManagedObjectContext:self.context];
    
    for (NSDictionary *photo in self.flickr_user_photos)
    {
        TimelineEntry *entry = [[TimelineEntry alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
        entry.text = [photo valueForKey:@"title"];
        entry.entryID = [photo valueForKey:@"id"];
        
        [self.passedAccount addEntriesObject:entry];
    }
    
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
- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
    [self loadFlickrData];
}
@end
