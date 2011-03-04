// 
//  Photo.m
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import "Photo.h"
#import "Place.h"
#import "FlickrFetcher.h"


@interface Photo (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveIsFavorite;
- (void)setPrimitiveIsFavorite:(NSNumber *)value;
- (Place *)primitiveWhereTook;

@end

@implementation Photo 


+ (Photo *)photoWithFlickrData:(NSDictionary *)flickrData withPlaceName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
	Photo *photo = nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"uniqueId = %@", [flickrData objectForKey:@"id"]];
	
	NSError *error = nil;
	photo = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !photo) {
		photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
		photo.uniqueId = [flickrData objectForKey:@"id"];
		photo.title = [flickrData objectForKey:@"title"];
		photo.subTitle = [[flickrData objectForKey:@"description"] objectForKey:@"_content"];
		if (photo.title.length == 0 && photo.subTitle.length == 0)
			photo.title = [NSString stringWithString:@"Unknown"];
		photo.imageURL = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrData format:FlickrFetcherPhotoFormatLarge];
		photo.lastTimeViewed = [NSDate date];
		photo.IsFavorite = [NSNumber numberWithInt:0];
		photo.imageURL = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrData format:FlickrFetcherPhotoFormatLarge];
		photo.thumbnailURL = [FlickrFetcher urlStringForPhotoWithFlickrInfo:flickrData format:FlickrFetcherPhotoFormatSquare];
		photo.whereTook = [Place placeWithFlickrData:name inManagedObjectContext:context];
		photo.dataPath = nil;
		photo.thumbnailData = nil;
		photo.latitude = [flickrData objectForKey:@"latitude"];
		photo.longitude = [flickrData objectForKey:@"longitude"];
	}
	
	return photo;
}

- (void)processImageDataWithBlock:(void (^)(NSData *imageData))processImage
{
	NSString *url = self.imageURL;
	dispatch_queue_t callerQueue = dispatch_get_current_queue();
	dispatch_queue_t downloadQueue = dispatch_queue_create("Flickr downloader in Photo", NULL);
	dispatch_async(downloadQueue, ^{
		NSData *imageData = [FlickrFetcher imageDataForPhotoWithURLString:url];
		dispatch_async(callerQueue, ^{
		    processImage(imageData);
		});
	});
	dispatch_release(downloadQueue);
}

- (void)processThumbnailWithBlock
{
	NSString *url = self.thumbnailURL;
	dispatch_queue_t downloadQueue = dispatch_queue_create("Thumbnail downloader", NULL);
	dispatch_async(downloadQueue, ^{
		self.thumbnailData = [FlickrFetcher imageDataForPhotoWithURLString:url];
	});
	dispatch_release(downloadQueue);
}

/*- (NSString *)timePast
{
	NSTimeInterval seconds =  [[NSDate date] timeIntervalSinceDate:self.lastTimeViewed];
	int hours = seconds / 60 + 1;
	NSString *titleForHeader;
	if (hours == 1) {
		titleForHeader = [NSString stringWithString:@"Right now"];
	} else {
		titleForHeader = [NSString stringWithFormat:@"%d minitue ago", hours];
	}
	return titleForHeader;
}*/


- (void)setIsFavorite:(NSNumber *)value 
{
    [self willChangeValueForKey:@"IsFavorite"];
    [self setPrimitiveIsFavorite:value];
    [self didChangeValueForKey:@"IsFavorite"];
	[self primitiveWhereTook].hasFavoritePhoto = value;
}

- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D location;
	location.latitude = [self.latitude doubleValue];
	location.longitude = [self.longitude doubleValue];
	return location;
}


@dynamic uniqueId;
@dynamic lastTimeViewed;
@dynamic whereTook;
@dynamic IsFavorite;
@dynamic imageURL;
@dynamic title;
@dynamic subTitle;
@dynamic dataPath;
@dynamic thumbnailURL;
@dynamic thumbnailData;
@dynamic latitude;
@dynamic longitude;

@end










