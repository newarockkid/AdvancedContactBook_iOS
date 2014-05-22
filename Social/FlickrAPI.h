//
//  FlickrAPI.h
//  FlickrAPI
//
//  Created by Rene Hexel on 22/04/13.
//  Copyright (c) 2013-2014 Rene Hexel. All rights reserved.
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
- (NSMutableArray *) topPlacesByRegion; ///< top 100 places in the last 24 hours

/**
 * Get the photos for a given user
 * @param friendUserName    name of the user whose photos to fetch
 */
- (NSArray *) photosForUser: (NSString *) friendUserName;

/**
 * Get the photos in a given region
 * @param place    dictonary whose place_id contains the Flickr ID of a region
 */
- (NSArray *) photosInRegion: (NSDictionary *) place;

/**
 * Get the download URL for a given photo
 * @param photo dictionary containing Flickr photo data
 */
- (NSURL *) photoURLFor: photo;

/**
 * Same as above, but get the URL for a photo in the given format.
 * See below for valid photo formats!
 * @param photo             dictionary containing Flickr photo data
 * @param flickrPhotoFormat a string designating the Flickr photo format
 */
- (NSURL *) photoURLFor: photo format: (NSString *) flickrPhotoFormat;

/**
 * Return the URL for a given photo (in a given format) as a string.
 * @param photo     dictionary containing Flickr photo data
 * @param format    a string designating the Flickr photo format
 */
- (NSString *) urlStringForPhoto: photo format: (NSString *) format;



/*
 Return the availabe photo sizes for the given id. This also contains the url for the images.
 */
- (NSArray *) photoSizes: (NSString *) photoID;


- (NSArray *) photosForUserName: (NSString *) userName;

@end




/**
 * Flickr photo formats.
 * You need to specify one of them for downloading.
 * They should be pretty self explanatory, but you might want to
 * consult the Flickr API above for details!
 */
extern NSString *kFlickrPhotoFormatOriginal;
extern NSString *kFlickrPhotoFormatSquare;
extern NSString *kFlickrPhotoFormatBig;
extern NSString *kFlickrPhotoFormatSmall;
extern NSString *kFlickrPhotoFormatThumbnail;
extern NSString *kFlickrPhotoFormat500;
extern NSString *kFlickrPhotoFormat640;

