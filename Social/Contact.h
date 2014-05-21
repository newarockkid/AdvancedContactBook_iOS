//
//  Contact.h
//  Social
//
//  Created by Nishant Shrestha on 21/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SocialMediaAccount;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *sites;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addSitesObject:(SocialMediaAccount *)value;
- (void)removeSitesObject:(SocialMediaAccount *)value;
- (void)addSites:(NSSet *)values;
- (void)removeSites:(NSSet *)values;

@end
