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

#define USER_FLICKR_API_KEY @"59f3dbe40e6f3d1f62678573b1145dce"
#define DEFAULT_MAX_RESULTS     25



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
    // Currently can only be Twitter, but precaution for when Facebook and Weibo maybe added.
    
    self.username = [self.passedAccount valueForKey:@"identifier"];
    self.accountType = [self.passedAccount valueForKey:@"accountType"];
    
    if([self.accountType isEqualToString:@"Twitter"]){
        self.navigationItem.title = [NSString stringWithFormat:@"%@'s Twitter Feed", self.username];
        [self getTimeLineForUser];
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

- (void) getTimeLineForUser
{
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:USER_TWITTER_API_KEY consumerSecret:USER_TWITTER_SECRET_KEY];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        [twitter getUserTimelineWithScreenName:[self.passedAccount valueForKey:@"identifier"] count:MAX_TWEET_COUNT successBlock:^(NSArray *statuses) {
            
            self.timelineFeeds = [NSMutableArray arrayWithArray:statuses];
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            
            [self.tableView reloadData];
            
        } errorBlock:^(NSError *error) {
            
            NSLog(@"%@", error.debugDescription);
            UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
            
        }];
        
    } errorBlock:^(NSError *error) {
        
        NSLog(@"%@", error.debugDescription);
    }];
}



@end
