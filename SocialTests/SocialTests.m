//
//  SocialTests.m
//  SocialTests
//
//  Created by Nishant Shrestha on 18/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <XCTest/XCTest.h>

// Import View Controllers
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FlickrTableViewController.h"
#import "FeedTableViewController.h"


#import "AppDelegate.h"

// Import Model Files
#import "Contact.h"
#import "SocialMediaAccount.h"
#import "TimelineEntry.h"

// Import External APIs

#import "STTwitter.h"
#import "FlickrAPI.h"


// Constants for the APIs
#define USER_TWITTER_API_KEY @"D1b2HpW1s6V8fRKMUK4v9TUDQ"
#define USER_TWITTER_SECRET_KEY @"fKgu15HrrMrOMTTlqRpY35Rvw2kfFtAnBLmBPGeLE1nEIJbigC"
#define MAX_TWEET_COUNT 15

#define USER_FLICKR_API_KEY @"59f3dbe40e6f3d1f62678573b1145dce"
#define DEFAULT_MAX_RESULTS     25

@interface SocialTests : XCTestCase

@property NSManagedObjectContext *testContext;
@property NSFetchedResultsController *testFetchedResultsController;

@property AppDelegate *appDelegate;
@property MasterViewController *masterViewController;


@end

@implementation SocialTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.appDelegate = UIApplication.sharedApplication.delegate;
    self.testContext = self.appDelegate.managedObjectContext;
    
    UINavigationController *navController = (UINavigationController *)self.appDelegate.window.rootViewController;
    
    self.masterViewController = (MasterViewController *)navController.topViewController;
    
    self.testFetchedResultsController = self.masterViewController.fetchedResultsController;
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    self.appDelegate = nil;
    self.testContext = nil;
    self.testFetchedResultsController = nil;
}

- (void) testCoreData
{
    NSManagedObjectContext *context = self.testContext;
    
    
    // Store the initial number of elements in the context.
    int initialCount = [[self.testFetchedResultsController fetchedObjects] count];
    
    NSEntityDescription *contactEntity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:context];
    NSEntityDescription *accountEntity = [NSEntityDescription entityForName:@"SocialMediaAccount" inManagedObjectContext:context];
    
    Contact *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[contactEntity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    newManagedObject.firstName = @"Test";
    newManagedObject.lastName = @"Account";
    newManagedObject.address = @"Test Walkway, 123";
    
    SocialMediaAccount *newAccount = [NSEntityDescription insertNewObjectForEntityForName:[accountEntity name] inManagedObjectContext:context];
    
    newAccount.identifier = @"testFlickr";
    newAccount.accountType = @"Flickr";
    
    [newManagedObject addSitesObject:newAccount];
    
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    //Get new number of elements in the context.
    int finalCount = [[self.testFetchedResultsController fetchedObjects] count];
    
    XCTAssertNil(error, "Error saving the context!");
    
    XCTAssertNotEqual(initialCount, finalCount, @"Initial count and the final count should not be the same");
    
    
    // Test deleting from Core Data.
    
    // Delete the test object.
    [context deleteObject:newManagedObject];
    
    
    // Save the context.
    error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    XCTAssertEqual(initialCount, [[self.testFetchedResultsController fetchedObjects] count], @"Initial count and count after deleting must be the same!");
}

- (void) testTwitter
{
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:USER_TWITTER_API_KEY consumerSecret:USER_TWITTER_SECRET_KEY];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        [twitter getUserTimelineWithScreenName:@"NBA" count:MAX_TWEET_COUNT successBlock:^(NSArray *statuses) {
            
            NSMutableArray *testFeeds = [NSMutableArray arrayWithArray:statuses];
            
            XCTAssertNotNil(testFeeds, @"testFeeds returned nil.");
            
        } errorBlock:^(NSError *error) {
            
            NSLog(@"%@", error.debugDescription);
            XCTAssertNil(error, @"Error while loading twitter feeds!");

        }];
        
    } errorBlock:^(NSError *error) {
        
        NSLog(@"%@", error.debugDescription);
        XCTAssertNil(error, @"Error while verifying credentials for twitter feeds!");
    }];
    
 
}


- (void) testFlickr
{
    
}



@end
