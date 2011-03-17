//
//  URLModelResponse.m
//
//  Created by Keith Lazuka on 6/3/09.
//  
//

#import "URLModelResponse.h"

@implementation URLModelResponse

@synthesize objects, totalObjectsAvailableOnServer;

+ (id)response
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
    if ((self = [super init])) {
        objects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [objects release];
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////

@end