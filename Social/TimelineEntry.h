//
//  TimelineEntry.h
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SocialMediaAccount;

@interface TimelineEntry : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * siteData;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) SocialMediaAccount *account;

@end
