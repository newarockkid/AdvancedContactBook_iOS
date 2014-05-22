//
//  SocialMediaAccount.h
//  Social
//
//  Created by Nishant Shrestha on 22/05/2014.
//  Copyright (c) 2014 Nishant Shrestha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, TimelineEntry;

@interface SocialMediaAccount : NSManagedObject

@property (nonatomic, retain) NSString * accountType;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) NSSet *entries;
@end

@interface SocialMediaAccount (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(TimelineEntry *)value;
- (void)removeEntriesObject:(TimelineEntry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
