//
// SnapAndRunViewController.m
//
// Copyright (c) 2009 Lukhnos D. Liu (http://lukhnos.org)
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "SnapAndRunViewController.h"
#import "FlickrViewAppDelegate.h"

NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kSetImageTags = @"kSetImageTags";
NSString *kSetImagePers = @"kSetImagePers";
NSString *kUploadImageStep = @"kUploadImageStep";

@interface SnapAndRunViewController (PrivateMethods)
- (void)updateUserInterface:(NSNotification *)notification;
@end


@implementation SnapAndRunViewController
- (void)viewDidUnload
{
    self.flickrRequest = nil;
    self.imagePicker = nil;
    
    self.snapPictureButton = nil;
    self.snapPictureDescriptionLabel = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [self viewDidUnload];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = @"Upload";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self updateUserInterface:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateUserInterface:(NSNotification *)notification
{	
	if ([self.flickrRequest isRunning]) {
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateNormal];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateHighlighted];
		[snapPictureButton setTitle:@"Cancel" forState:UIControlStateDisabled];
	}
	else {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Snap" forState:UIControlStateDisabled];
			snapPictureDescriptionLabel.text = @"Use camera";
		}
		else {
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateNormal];
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateHighlighted];
			[snapPictureButton setTitle:@"Pick Picture" forState:UIControlStateDisabled];						
			snapPictureDescriptionLabel.text = @"Pick from library";
		}
	}
}

#pragma mark Actions

- (IBAction)snapPictureAction
{
	if ([self.flickrRequest isRunning]) {
		[self.flickrRequest cancel];
		[self updateUserInterface:nil];		
		return;
	}
	
    [self presentModalViewController:self.imagePicker animated:YES];
}

- (IBAction)authorizeAction
{    
    NSURL *loginURL = [[FlickrViewAppDelegate sharedDelegate].flickrContext loginURLFromFrobDictionary:nil requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:loginURL];
}

#pragma mark OFFlickrAPIRequest delegate methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
		snapPictureDescriptionLabel.text = @"Setting properties...";

        
        //NSLog(@"%@", inResponseDictionary);
        photoID = [[[inResponseDictionary valueForKeyPath:@"photoid"] textContent] retain];

        flickrRequest.sessionInfo = kSetImageTags;
		
		[flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" 
								   arguments:[NSDictionary dictionaryWithObjectsAndKeys:
											  photoID, @"photo_id", 
											  [photoInfo objectForKey:@"title"], @"title", 
											  [photoInfo objectForKey:@"description"], @"description", nil]];        		        
		
	} else if (inRequest.sessionInfo == kSetImageTags) {
		//NSLog(@"%@", inResponseDictionary);
		snapPictureDescriptionLabel.text = @"Setting Tags...";
		
		flickrRequest.sessionInfo = kSetImagePers;
		[flickrRequest callAPIMethodWithPOST:@"flickr.photos.setTags" 
								   arguments:[NSDictionary dictionaryWithObjectsAndKeys:
											  photoID, @"photo_id", 
											  [photoInfo objectForKey:@"tags"], @"tags", nil]];
		
	} else if (inRequest.sessionInfo == kSetImagePers) {
		snapPictureDescriptionLabel.text = @"Setting Pers...";

		flickrRequest.sessionInfo = kSetImagePropertiesStep;
		
		[flickrRequest callAPIMethodWithPOST:@"flickr.photos.setPerms" 
								   arguments:[NSDictionary dictionaryWithObjectsAndKeys:
											  photoID, @"photo_id",
											  [photoInfo objectForKey:@"is_public"], @"is_public",
											  @"0", @"is_friend",
											  @"0", @"is_family",
											  @"3", @"perm_comment",
											  @"0", @"perm_addmeta", nil]];


	} else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		[photoID release];
		[photoInfo release];
		[self updateUserInterface:nil];		
		snapPictureDescriptionLabel.text = @"Done";
		snapPictureButton.enabled = YES;
		snapPictureDescriptionLabel.text = @"Go on?";
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;		
        
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
		[self updateUserInterface:nil];
		snapPictureDescriptionLabel.text = @"Failed";		
		[UIApplication sharedApplication].idleTimerDisabled = NO;

		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];

	}
	else {
		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
	}
	snapPictureButton.enabled = YES;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes) {
		snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else {
		snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%lu/%lu (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}


#pragma mark UIImagePickerController delegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)_startUpload:(NSDictionary *)photoInfoDic
{
    //[self.imagePicker popViewControllerAnimated:YES];
	//[self dismissModalViewControllerAnimated:YES];
	photoInfo = [photoInfoDic retain];
	
	NSData *JPEGData = UIImageJPEGRepresentation(pickedImage, 1.0);
	TT_RELEASE_SAFELY(pickedImage);
    
	snapPictureButton.enabled = NO;
	snapPictureDescriptionLabel.text = @"Uploading";
	
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"Snap and Run Demo" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self updateUserInterface:nil];
}

#ifndef __IPHONE_3_0
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//  NSDictionary *editingInfo = info;
#else
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
#endif
	
	FillPhotoInfoViewController *fpivc = [[[FillPhotoInfoViewController alloc] init] autorelease];
	fpivc.delegate = self;
	if (pickedImage) TT_RELEASE_SAFELY(pickedImage);
	pickedImage = [image retain];
//	[self dismissModalViewControllerAnimated:NO];

	
	[self.imagePicker pushViewController:fpivc animated:YES];	
	
	snapPictureDescriptionLabel.text = @"Preparing...";
	// we schedule this call in run loop because we want to dismiss the modal view first
//	[self performSelector:@selector(_startUpload:) withObject:image afterDelay:0.0];
}

#pragma mark Accesors

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[FlickrViewAppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (UIImagePickerController *)imagePicker
{
    if (!imagePicker) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
    }
    return imagePicker;
}


#ifndef __IPHONE_3_0
- (void)setView:(UIView *)view
{
	if (view == nil) {
		[self viewDidUnload];
	}
	
	[super setView:view];
}
#endif

@synthesize flickrRequest;
@synthesize imagePicker;

@synthesize snapPictureButton;
@synthesize snapPictureDescriptionLabel;
@end
