//
//  TopPlaceTableViewController.h
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopPlaceTableViewController.h"
#import "ObjectiveFlickr.h"

@interface TopPlaceTableViewController : UITableViewController 
<OFFlickrAPIRequestDelegate> {
	NSMutableDictionary *data;
	NSArray *sections;
	NSManagedObjectContext *managedObjectContext;
	
	OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
}

@property (retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;

- (id)makeKey:(NSDictionary *)aDic;

- (NSArray *)rawData;

- (NSDictionary *)dataInfo:(NSIndexPath *)indexPath;



@end
