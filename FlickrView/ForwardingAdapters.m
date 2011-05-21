//
//  ForwardingAdapters.m
//  TTRemoteExamples
//
//  Created by Keith Lazuka on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ForwardingAdapters.h"
#import "SearchResultsPhotoSource.h"
#import "SearchResultsModel.h"
#import "FlickrSearchResultsModel.h"

@implementation MyPhotoViewController

@synthesize realModel;

- (void)setModel:(id<TTModel>)m { [super setModel:realModel]; }

- (void)dealloc
{
	[realModel release];
	[super dealloc];
}

@end

@implementation MyBaseThumbsViewController

- (void)dealloc
{
	[realModel release];
	[super dealloc];
}

- (void)setModel:(id<TTModel>)m { [super setModel:realModel]; }

- (TTPhotoViewController*)createPhotoViewController
{
	MyPhotoViewController *vc = [[[MyPhotoViewController alloc] init] autorelease];
	vc.realModel = realModel;
	return vc;
}

- (id<TTTableViewDataSource>)createDataSource {
	return [[[MyThumbsDataSource alloc] initWithPhotoSource:_photoSource delegate:self] autorelease];
}

@end

@implementation MyThumbsViewController

- (id)init
{
	if ((self = [super init])) {
		FlickrSearchResultsModel *fsrm = [[[FlickrSearchResultsModel alloc] init] autorelease];
		fsrm.delegate = self;
		SearchResultsPhotoSource *source = [[SearchResultsPhotoSource alloc] 
											initWithModel:fsrm];
		realModel = [[source underlyingModel] retain];
		self.photoSource = source;
		
		UIBarButtonItem *reloadItem = 
        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                     target:self
                                                     action:@selector(refresh:)];
        
        reloadItem.width = 25.0;
		self.navigationItem.rightBarButtonItem = reloadItem;
		[reloadItem release];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)refresh:(id)sender
{
    [self.photoSource load:TTURLRequestCachePolicyNoCache more:NO];
}

#pragma mark -
#pragma mark FlickrSearchResultsModelDelegate
- (NSString *)apiMethod
{
	return nil;
}

- (NSDictionary *)argumentsForApiMethod
{
	return nil;
}

@end



@implementation MyExploreThumbsViewController

- (void)dealloc
{
	//[[TTURLCache sharedCache] removeAll:YES];
	[super dealloc];
}

#pragma mark -
#pragma mark FlickrSearchResultsModelDelegate
- (NSString *)apiMethod
{
	return @"flickr.interestingness.getList";
}

- (NSDictionary *)argumentsForApiMethod
{
	return nil;
}
@end

@implementation MyPhotoThumbsViewController

- (id)initWithName:(NSString *)aName
{
	name = [aName copy];
	if (self = [super init]) {
		self.photoSource.title = @"Photos";
	}
	return self;
}

- (void)dealloc
{
	[name release];
	[super dealloc];
}

- (NSString *)apiMethod
{
	return @"flickr.people.getPhotos";
}

- (NSDictionary *)argumentsForApiMethod
{
	return [NSDictionary dictionaryWithObjectsAndKeys:name, @"user_id", nil];
}

@end

@implementation MyFavPhotoThumbsViewController

- (id)init
{
	if (self = [super init]) {
		self.photoSource.title = @"Favortie";
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (NSString *)apiMethod
{
	return @"flickr.favorites.getList";
}

@end

@implementation MyContactsRecentThumbsViewController

- (NSString *)apiMethod
{
	return @"flickr.contacts.getList";
//	return @"flickr.people.getInfo";
//	return @"flickr.people.getPhotos";
}

- (NSDictionary *)argumentsForApiMethod
{
//	return [NSDictionary dictionaryWithObjectsAndKeys:@"29272314@N06", @"user_id", nil];
//	return [NSDictionary dictionaryWithObjectsAndKeys:@"me", @"user_id", nil];
	return nil;
}

@end


@implementation MySearchThumbsViewController

- (id)initWithSearchText:(NSString *)aSearchText
{
	searchText = [aSearchText copy];
	NSLog(@"%@", searchText);
	if ((self = [super init])) {		

	}
	return self;
}

- (void)dealloc
{
	[searchText release];
	[super dealloc];
}

#pragma mark -
#pragma mark FlickrSearchResultsModelDelegate
- (NSString *)apiMethod
{
	return @"flickr.photos.search";
}

- (NSDictionary *)argumentsForApiMethod
{
	return [NSDictionary dictionaryWithObjectsAndKeys:searchText, @"text", nil];
}

@end

@implementation MyThumbsDataSource

- (id<TTModel>)model
{
	return [(SearchResultsPhotoSource*)_photoSource underlyingModel];
}

@end
