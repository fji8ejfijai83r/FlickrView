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

@implementation MyThumbsViewController

- (id)initForPhotoSource:(SearchResultsPhotoSource *)source;
{
	return [self init];
}

- (id)init
{
	if ((self = [super init])) {
		FlickrSearchResultsModel *fsrm = [[[FlickrSearchResultsModel alloc] init] autorelease];
		fsrm.delegate = self;
		SearchResultsPhotoSource *source = [[SearchResultsPhotoSource alloc] 
					initWithModel:fsrm];
		realModel = [[source underlyingModel] retain];
		self.photoSource = source;
	}
	return self;
}

- (void)dealloc
{
	[realModel release];
	[[TTURLCache sharedCache] removeAll:YES];
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


@implementation MySearchThumbsViewController

- (id)initForPhotoSource:(SearchResultsPhotoSource *)source
{
	if ((self = [super init])) {
		realModel = [[source underlyingModel] retain];
		self.photoSource = source;
		UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, TTApplicationFrame().size.width, TT_ROW_HEIGHT)];
		searchBar.delegate = self;
		searchBar.placeholder = @"Image Search";
		self.navigationItem.titleView = searchBar;
		[searchBar release];
	}
	return self;
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

- (void)dealloc
{
	[realModel release];
	[[TTURLCache sharedCache] removeAll:YES];
	[super dealloc];
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Configure our TTModel with the user's search terms
    // and tell the TTModelViewController to reload.
    [searchBar resignFirstResponder];
	//[self.photoSource load:TTURLRequestCachePolicyDefault more:NO];


}

@end

@implementation MyThumbsDataSource

- (id<TTModel>)model
{
	return [(SearchResultsPhotoSource*)_photoSource underlyingModel];
}

@end
