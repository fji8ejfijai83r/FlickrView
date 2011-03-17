//
//  FlickrSearchResultsModel.m
//
//  Created by Keith Lazuka on 7/23/09.
//  
//

#import "FlickrSearchResultsModel.h"
#import "FlickrResponse.h"
#import "FlickrViewAppDelegate.h"
#import "JSON.h"
#import "FlickrAPIKey.h"


const static NSUInteger kFlickrBatchSize = 16;   // The number of results to pull down with each request to the server.

@implementation FlickrSearchResultsModel

- (id)init
{
    if ((self = [super init])) {
		flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[FlickrViewAppDelegate sharedDelegate].flickrContext];
		responseProcessor = [[FlickrResponse alloc] init];
		page = 1;
    }
    return self;
}

- (NSString *)apiMethod
{
	return @"flickr.interestingness.getList";
	//return @"flickr.people.getPhotos";

}

- (NSDictionary *)argumentsForApiMethod
{
	NSString *batchSize = [NSString stringWithFormat:@"%lu", (unsigned long)kFlickrBatchSize];
	return [NSDictionary dictionaryWithObjectsAndKeys:
			batchSize, @"per_page", 
			[NSString stringWithFormat:@"%lu", (unsigned long)page], @"page", 
			@"url_m,url_t", @"extras", 
			@"me", @"user_id",
			nil];
	//return [NSDictionary dictionaryWithObjectsAndKeys:@"16", @"per_page", nil];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (more)
        page++;
    else
        [responseProcessor.objects removeAllObjects]; // Clear out data from previous request.
    
    NSString *url = [flickrRequest callAPIForJsonURL:[self apiMethod] arguments:[self argumentsForApiMethod]];
	TTURLRequest *request = [TTURLRequest requestWithURL:url delegate:self];
    request.cachePolicy = cachePolicy;
    request.response = responseProcessor;
    request.httpMethod = @"GET";
    
    // Dispatch the request.
    [request send];
}

- (void)reset
{
    page = 1;
    [[responseProcessor objects] removeAllObjects];
}

#pragma mark -
#pragma mark SearchResultsModel protocol

- (NSArray *)results
{
	return [[[responseProcessor objects] copy] autorelease];
}

- (NSUInteger)totalResultsAvailableOnServer
{
    return [responseProcessor totalObjectsAvailableOnServer];
}

- (void)dealloc
{
    [flickrRequest release];
	[responseProcessor release];
    [super dealloc];
}


@end
