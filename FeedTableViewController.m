//
//  FeedTableViewController.m
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import "FeedTableViewController.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "STTwitter.h"
#import "FlickrAPI.h"

#define USER_TWITTER_API_KEY @"D1b2HpW1s6V8fRKMUK4v9TUDQ"
#define USER_TWITTER_SECRET_KEY @"fKgu15HrrMrOMTTlqRpY35Rvw2kfFtAnBLmBPGeLE1nEIJbigC"
#define MAX_TWEET_COUNT 15


@interface FeedTableViewController ()

@property NSMutableArray *timelineFeeds;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSString *username;
@property NSString *accountType;

@end

@implementation FeedTableViewController

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
    
    // Initialise the account type to determine which framework to utilise.
    // Currently can only be Twitter, but can be changed for when Facebook or other social media is added.
    
    self.username = [self.passedAccount valueForKey:@"identifier"];
    self.accountType = [self.passedAccount valueForKey:@"accountType"];
    
    if([self.accountType isEqualToString:@"Twitter"]){
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Twitter Feed", self.username];
        
        // If there is so 'Tweet Feed' for the current Account Object, then go and get the Twitter Feed.
        if([[self.passedAccount entries] count] == 0){
            [self getTimeLineForUser];
        }
        // Otherwise just load the existing tweets.
        else{
            self.timelineFeeds = [[self sortedFeedsReturn] mutableCopy];
        }
    }

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timelineFeeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if([self.accountType isEqualToString:@"Twitter"]){
        NSDictionary *tempDictionary = [self.timelineFeeds objectAtIndex:indexPath.row];
        cell.textLabel.text = [tempDictionary valueForKeyPath:@"text"];
        return cell;
    }
    
    return cell;
}


#pragma mark - Twitter API 1.1 methods using STTwitter.

/* 
    This function uses the STTwitter framework.
    Utilises the USER_TWITTER_API_KEY, USER_TWITTER_SECRET_KEY, MAX_TWEET_COUNT constants defined above.
 
    For each 'feed' in the returned 'statuses' array, it creates a 'TimelineEntry' object, and adds it to the 'SocialMediaAccount' in the context.
 
    This function does not deal with 'saving' the context.
 
 */
- (void) getTimeLineForUser
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:USER_TWITTER_API_KEY consumerSecret:USER_TWITTER_SECRET_KEY];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        [twitter getUserTimelineWithScreenName:[self.passedAccount valueForKey:@"identifier"] count:MAX_TWEET_COUNT successBlock:^(NSArray *statuses) {
            
            self.timelineFeeds = [NSMutableArray arrayWithArray:statuses];
            
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimelineEntry" inManagedObjectContext:self.context];
            
            for (NSDictionary *feed in self.timelineFeeds)
            {
                TimelineEntry *entry = [[TimelineEntry alloc] initWithEntity:entity insertIntoManagedObjectContext:self.context];
                entry.text = [feed valueForKey:@"text"];
                [self.passedAccount addEntriesObject:entry];
            }
            
            [self.tableView reloadData];
            
        } errorBlock:^(NSError *error) {
            
            NSLog(@"%@", error.debugDescription);
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            
        }];
        
    } errorBlock:^(NSError *error) {
        
        NSLog(@"%@", error.debugDescription);
    }];
}




// Manually call reload if desired.

- (IBAction)reloadButtonPressed:(UIBarButtonItem *)sender {
    [self getTimeLineForUser];
}


// Save the context everytime the view is about to disappear.
- (void) viewWillDisappear:(BOOL)animated
{
    // Save context.
    NSError *error;
    [self.context save:&error];
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

@end
