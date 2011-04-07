//
//  FlickrViewAppDelegate.h
//  FlickrView
//
//  Created by HD hiessu on 11-3-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

extern NSString *SnapAndRunShouldUpdateAuthInfoNotification;

@interface FlickrViewAppDelegate : NSObject <UIApplicationDelegate, OFFlickrAPIRequestDelegate> {
	//OFFlickrAPIContext *flickrContext;
	//OFFlickrAPIRequest *flickrRequest;
	//NSString *flickrUserName;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *ngc;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, readonly) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, copy) NSString *flickrUserName;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIView *progressView;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UILabel *progressDescription;

+ (FlickrViewAppDelegate *)sharedDelegate;
+ (UIColor *)FlickrViewNavBarTintColor;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken;
- (IBAction)cancelAction;

@end
