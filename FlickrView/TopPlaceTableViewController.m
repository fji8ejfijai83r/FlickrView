//
//  TopPlaceTableViewController.m
//  Flickr V beta 0.2
//
//  Created by HD hiessu on 11-1-15.
//  Copyright 2011 HD. All rights reserved.
//

#import "TopPlaceTableViewController.h"
#import "ObjectiveFlickr.h"
#import "FlickrAPIKey.h"
#import "FlickrViewAppDelegate.h"

#define kCustomRowCount     8
@interface TopPlaceTableViewController()
@end

@implementation TopPlaceTableViewController

@synthesize data = _data;
@synthesize sections = _sections;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize flickrRequest = _flickrRequest;

NSString *TableViewUpdateNotification = @"TableViewUpdateNotification";

- (id)init
{
	if ((self = [super init])) {
		_flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[FlickrViewAppDelegate sharedDelegate].flickrContext];
		[_flickrRequest setDelegate:self];
	}
	return self;
}

- (id)makeKey:(NSDictionary *)aDic;
{
	return nil;
}

- (NSArray *)rawData
{
	return nil;
}

- (NSMutableDictionary *)makeTableViewData:(NSArray *)rawData
{
	NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionary];
	for (id aData in rawData) {
		id key = [self makeKey:aData];
		// if an array already exists in the name index dictionary
		// simply add the element to it, otherwise create an array
		// and add it to the name index dictionary with the letter as the key
		NSMutableArray *existingArray;
		if ((existingArray = [tempDictionary objectForKey:key])) {
			[existingArray addObject:aData];
		} else {
			NSMutableArray *tempArray = [NSMutableArray array];
			[tempDictionary setObject:tempArray forKey:key];
			[tempArray addObject:aData];
		}
	}
	return tempDictionary;
}

#pragma mark -

- (NSArray *)sections
{
    if (!_sections) {
		_sections = [[[_data allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
	}
	return _sections;
}

#pragma mark -
#pragma mark View lifecycle


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return self.sections ? self.sections.count : 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *dataInSection = [self.data objectForKey:[self.sections objectAtIndex:section]];
    
    int count = dataInSection.count;
    
    if (count == 0)
        count = kCustomRowCount;
    
    return count;
}


- (NSDictionary *)dataInfo:(NSIndexPath *)indexPath
{
	NSArray *placesInSection = [self.data objectForKey:[self.sections objectAtIndex:indexPath.section]];
	return [placesInSection objectAtIndex:indexPath.row];
}

- (void)updateTableView
{
	[[self tableView] reloadData];
}

- (void)viewDidLoad
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(updateTableView) 
												 name:TableViewUpdateNotification 
											   object:nil];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:TableViewUpdateNotification
												  object:nil];
	self.data = nil;
	self.sections = nil;
	self.flickrRequest = nil;
}

- (void)dealloc {
	[_flickrRequest release];
	[_data release];
	[_sections release];
    [super dealloc];
}




@end

