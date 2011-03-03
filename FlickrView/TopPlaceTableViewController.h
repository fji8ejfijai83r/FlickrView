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
	
	OFFlickrAPIRequest *flickrRequest;
}

@property (retain) NSManagedObjectContext *managedObjectContext;	    
@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;


- (id)makeKey:(NSDictionary *)aDic;
- (NSArray *)rawData;
- (NSDictionary *)dataInfo:(NSIndexPath *)indexPath;
- (void)updateTableView;
- (NSMutableDictionary *)makeTableViewData:(NSArray *)rawData;

@end
