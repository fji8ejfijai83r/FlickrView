//
//  Photo.h
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@class Place;

@interface Photo :  NSManagedObject <MKAnnotation> 

+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData withPlaceName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)processImageDataWithBlock:(void (^)(NSData *imageData))processImage;
- (void)processThumbnailWithBlock;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSDate * lastTimeViewed;
@property (nonatomic, retain) NSNumber * IsFavorite;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subTitle;
@property (nonatomic, retain) Place * whereTook;
@property (nonatomic, retain) NSString *dataPath;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSData * thumbnailData;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end








