//
//  UserPhotosTableViewController.h
//  FlickrView
//
//  Created by HD hiessu on 11-3-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTableViewController.h"
#import "ObjectiveFlickr.h"


@interface UserPhotosTableViewController : UserTableViewController {
	NSArray *photosData;
	OFFlickrAPIRequest *flickrRequest;
}

@property (nonatomic, retain) NSString *userName;
@end
