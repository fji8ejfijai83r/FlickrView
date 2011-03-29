//
//  FlickrSearchResultsModel.h
//
//  Created by Keith Lazuka on 7/23/09.
//  
//

#import "Three20/Three20.h"
#import "SearchResultsModel.h"
#import "ObjectiveFlickr.h"
#import "FlickrResponse.h"

@class URLModelResponse;

/*
 *      FlickrSearchResultsModel
 *      -----------------------
 *
 */
@protocol FlickrSearchResultsModelDelegate
- (NSString *)apiMethod;
- (NSDictionary *)argumentsForApiMethod;
@end


@interface FlickrSearchResultsModel : TTURLRequestModel <SearchResultsModel>
{
    FlickrResponse *responseProcessor;
    NSUInteger page;
	OFFlickrAPIRequest *flickrRequest;
	id<FlickrSearchResultsModelDelegate> delegate;
}
@property (nonatomic, assign)  id<FlickrSearchResultsModelDelegate> delegate;
	
@end
