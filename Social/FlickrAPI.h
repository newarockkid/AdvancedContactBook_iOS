//
//  FlickrAPI.h
//  FlickrAPI
//
//  Created by Nishant Shrestha on 20/05/14.
//  Copyright (c) 2013-2014 Nishant Shrestha. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 * A simple class that demonstrates how to use the Flickr API.
 * For more information on the Flickr API, see
 * http://www.flickr.com/services/api/
 */

@interface FlickrAPI: NSObject

@property NSString *apiKey;             ///< Flickr requires an API key
@property NSInteger maximumResults;     ///< max. results in any one fetch

- initWithAPIKey: (NSString *) key;     ///< create an instance with this key

- (NSMutableArray *) latestPhotos;      ///< get the latest photos

/**
 * Get the photos for a given user
 * @param userName    name of the user whose photos to fetch
 */
- (NSArray *) photosForUserName: (NSString *) userName;

/*
 * Return the availabe photo sizes for the given id. This also contains the url for the images.
 * @param photoID   photoID for the photo to get sizes.
 */
- (NSArray *) photoSizes: (NSString *) photoID;

@end
