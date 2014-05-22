//
//  FlickrImageViewController.h
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrAPI.h"

#import "TimelineEntry.h"

@interface FlickrImageViewController : UIViewController


@property FlickrAPI *flickrAPI;

@property NSManagedObjectContext *context;
@property TimelineEntry *passedEntry;


@end
