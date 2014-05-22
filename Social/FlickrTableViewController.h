//
//  FlickrTableViewController.h
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialMediaAccount.h"
#import "TimelineEntry.h"

@interface FlickrTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property NSManagedObjectContext *context;

@property SocialMediaAccount *passedAccount;


@end
