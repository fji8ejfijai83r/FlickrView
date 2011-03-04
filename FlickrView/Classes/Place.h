//
//  Place.h
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Photo;

@interface Place :  NSManagedObject  
{
}

+ (Place *)placeWithFlickrData:(NSString *)placeName inManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSSet* photos;
@property (nonatomic, retain) NSNumber * hasFavoritePhoto;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;

@end


@interface Place (CoreDataGeneratedAccessors)
- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)value;
- (void)removePhotos:(NSSet *)value;

@end

