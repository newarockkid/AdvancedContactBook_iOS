//
//  FeedTableViewController.h
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialMediaAccount.h"
#import "TimelineEntry.h"

@interface FeedTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSManagedObjectContext *context;

@property SocialMediaAccount *passedAccount;

@end
