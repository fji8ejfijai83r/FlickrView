//
//  ContactsListDataSource.m
//  FlickrView
//
//  Created by HD hiessu on 11-3-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactsListDataSource.h"


@implementation ContactsListDataSource

- (void)tableViewDidLoadModel:(UITableView *)tableView
{
	[super tableViewDidLoadModel:tableView];
	
	[self.items removeAllObjects];
	
   // for (SearchResult *result in [(id<SearchResultsModel>)self.model results]) {
//		
//	}
}

#pragma mark TTTableViewDataSource protocol

- (UIImage*)imageForEmpty
{
	return [UIImage imageNamed:@"Three20.bundle/images/empty.png"];
}

- (UIImage*)imageForError:(NSError*)error
{
    return [UIImage imageNamed:@"Three20.bundle/images/error.png"];
}

#pragma mark -
#pragma mark FlickrSearchResultsModelDelegate
- (NSString *)apiMethod
{
	return @"flicrk.contacts.getList";
}

- (NSDictionary *)argumentsForApiMethod
{
	return nil;
}
@end
