//
//  SettingsViewController.m
//  FlickrView
//
//  Created by HD hiessu on 11-5-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "FlickrViewAppDelegate.h"


@implementation SettingsViewController
@synthesize signInOrOut;

- (void)popUpForAuthorize
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" 
													message:@"FlickrView will popup safari to login flickr, please make sure"
												   delegate:self 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles:@"OK", nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex != alertView.cancelButtonIndex) {
		NSURL *loginURL = [[FlickrViewAppDelegate sharedDelegate].flickrContext 
						   loginURLFromFrobDictionary:nil requestedPermission:OFFlickrWritePermission];
		[[UIApplication sharedApplication] openURL:loginURL];
	}
}

- (BOOL)isAuthorized
{
	return [[FlickrViewAppDelegate sharedDelegate].flickrContext.authToken length];
}
- (void)viewDidLoad
{
	[self updateButton];
}

- (void)updateButton
{
	if ([self isAuthorized]) {
		[signInOrOut setTitle:@"Sign out" forState:UIControlStateNormal];
		[signInOrOut setTitle:@"Sign out" forState:UIControlStateHighlighted];
		[signInOrOut setTitle:@"Sign out" forState:UIControlStateDisabled];
	} else {
		[signInOrOut setTitle:@"Sign in" forState:UIControlStateNormal];
		[signInOrOut setTitle:@"Sign in" forState:UIControlStateHighlighted];
		[signInOrOut setTitle:@"Sign in" forState:UIControlStateDisabled];
	}
}

- (IBAction)signInOrOut {
	if ([self isAuthorized]) {
		[[FlickrViewAppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
	} else {
		[self popUpForAuthorize];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearCache {
	NSLog(@"clearCache");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.signInOrOut = nil;
}


- (void)dealloc {
    [super dealloc];
	[signInOrOut release];
}


@end
