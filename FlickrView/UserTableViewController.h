//
//  UserTableViewController.h
//  FlickrView
//
//  Created by HD hiessu on 11-3-4.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

@interface UserTableViewController : UITableViewController 
<OFFlickrAPIRequestDelegate> {

}
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;

- (NSString *)apiMethod;
- (NSDictionary *)argumentsForApiMethod;
@end
