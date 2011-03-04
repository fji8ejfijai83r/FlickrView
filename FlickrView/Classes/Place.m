// 
//  Place.m
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import "Place.h"
#import "Photo.h"

@interface Place (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber *)primitiveHasFavoritePhoto;
- (void)setPrimitiveHasFavoritePhoto:(NSNumber *)value;

@end

@implementation Place 

+ (NSString *)placeTitle:(NSString *)placeName
{
	NSRange range = [placeName rangeOfString:@","];
	if (range.location == NSNotFound) return placeName;
	return [placeName substringToIndex:range.location];  
}

+ (NSString *)placeSubTitle:(NSString *)placeName
{
	NSRange range = [placeName rangeOfString:@", "];
	if (range.location == NSNotFound) return placeName;
	return [placeName substringFromIndex:range.location + 2]; 	
}

+ (Place *)placeWithFlickrData:(NSString *)placeName inManagedObjectContext:(NSManagedObjectContext *)context
{
	Place *place= nil;
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:
			@"title = %@ and subTitle = %@", [Place placeTitle:placeName], [Place placeSubTitle:placeName]];
	
	NSError *error = nil;
	place = [[context executeFetchRequest:request error:&error] lastObject];
	[request release];
	
	if (!error && !place) {
		place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
		place.hasFavoritePhoto = [NSNumber numberWithInt:0];
		place.title = [Place placeTitle:placeName];
		place.subTitle = [Place placeSubTitle:placeName];
	}
	
	return place;
}

- (NSString *)firstLetterOfName
{
	return [[self.title substringToIndex:1] capitalizedString];
}

- (void)setHasFavoritePhoto:(NSNumber *)value 
{
    [self willChangeValueForKey:@"hasFavoritePhoto"];
    int number = [[self primitiveHasFavoritePhoto] intValue];
	number += [value intValue] > 0 ? 1 : -1;
	if (number < 0) number = 0;
	[self setPrimitiveHasFavoritePhoto:[NSNumber numberWithInt:number]];
    [self didChangeValueForKey:@"hasFavoritePhoto"];
}

@dynamic photos;
@dynamic hasFavoritePhoto;
@dynamic title;
@dynamic subTitle;

@end





