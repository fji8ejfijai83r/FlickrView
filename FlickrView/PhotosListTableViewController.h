//
//  PhotosListTableViewController.h
//  FlickrView
//
//  Created by HD hiessu on 10-12-30.
//  Copyright 2010 HD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopPlaceTableViewController.h"

@class PhotoViewController;


@interface PhotosListTableViewController : TopPlaceTableViewController <UIScrollViewDelegate> {
	NSString *photoId;
	NSString *placeName;
	NSString *thumbnailURL;
	NSMutableDictionary *imageDataDB;
}

@property (copy) NSString *photoId;
@property (copy) NSString *placeName;

@end
