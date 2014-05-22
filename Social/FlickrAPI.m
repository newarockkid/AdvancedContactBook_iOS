//
//  FlickrAPI.m
//  FlickrAPI
//
//  Created by Nishant Shrestha on 20/05/14.
//  Copyright (c) 2013-2014 Nishant Shrestha. All rights reserved.
//

#import "FlickrAPI.h"

#define DEFAULT_MAX_RESULTS 25


@implementation FlickrAPI

- initWithAPIKey: (NSString *) key
{
        if (!(self = [super init]))
                return nil;

        self.apiKey = key;
        self.maximumResults = DEFAULT_MAX_RESULTS;

        return self;
}


- (NSMutableArray *) latestPhotos
{
        NSString *request = [NSString stringWithFormat: @"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=%@&per_page=%ld&format=json&nojsoncallback=1", self.apiKey, (long) self.maximumResults];

        return [[self fetch: request] valueForKeyPath: @"photos.photo"];
}



/**
 * This is the method that actually fetches data from Flickr.
 * Don't invoke directly (unless you want to extend this Flickr API),
 * use one of the public methods instead!
 */
- (NSDictionary *) fetch: (NSString *) request
{
    NSString *query = [[NSString stringWithFormat: @"%@&api_key=%@&format=json&nojsoncallback=1", request, self.apiKey]
                       stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *queryURL = [NSURL URLWithString: query];
    NSData *responseData = [NSData dataWithContentsOfURL: queryURL];
    if (!responseData)
        return nil;

    NSError *error = nil;
    NSDictionary *jsonContent = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: &error];

    if (!jsonContent)
        NSLog(@"Could not fetch '%@': %@", request, error);

    return jsonContent;
}




// Added to function with the new Flickr API

- (NSArray *) photosForUserName: (NSString *) userName
{
    NSString *request = [NSString stringWithFormat: @"https://api.flickr.com/services/rest/?method=flickr.people.findByUsername&api_key=%@&username=%@&format=json&nojsoncallback=1", self.apiKey, userName];
    NSDictionary *result = [self fetch: request];
    NSString *nsid = [result valueForKeyPath: @"user.nsid"];
    
    if(!nsid){
        NSLog(@"Could not find the username");
    }
    
    request = [NSString stringWithFormat: @"https://api.flickr.com/services/rest/?method=flickr.people.getPhotos&api_key=%@&user_id=%@&per_page=%d&format=json&nojsoncallback=1", self.apiKey, nsid, DEFAULT_MAX_RESULTS];
    
    result = [self fetch: request];
    return [result valueForKeyPath: @"photos.photo"];
}

- (NSMutableArray *) photoSizes: (NSString *) photoID
{
    NSString *request =  [NSString stringWithFormat: @"https://api.flickr.com/services/rest/?method=flickr.photos.getSizes&photo_id=%@&api_key=%@&format=json&nojsoncallback=1", photoID, self.apiKey];
    
    return [[self fetch: request] valueForKeyPath: @"sizes.size"];
}


@end
