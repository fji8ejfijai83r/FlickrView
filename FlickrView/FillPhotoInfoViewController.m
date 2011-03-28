#import "FillPhotoInfoViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FillPhotoInfoViewController

@synthesize photoTitle;
@synthesize photoDescription;
@synthesize photoTags;
@synthesize publicSwitch;

@synthesize delegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init{
	if (self = [super init]) {
		self.tableViewStyle = UITableViewStyleGrouped;
		self.autoresizesForKeyboard = YES;
		self.variableHeightRows = YES;

		photoTitle = [[[UITextField alloc] init] autorelease];
		photoTitle.font = TTSTYLEVAR(font);
		photoTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		TTTableControlItem* photoTitleItem = [TTTableControlItem itemWithCaption:@"Title:"
																		control:photoTitle];
		
		photoDescription = [[[TTTextEditor alloc] init] autorelease];
		photoDescription.font = TTSTYLEVAR(font);
		photoDescription.backgroundColor = TTSTYLEVAR(backgroundColor);
		photoDescription.autoresizesToText = NO;
		photoDescription.minNumberOfLines = 2;
		photoDescription.placeholder = @"Description:";
		
		photoTags = [[[UITextField alloc] init] autorelease];
		photoTags.font = TTSTYLEVAR(font);
		photoTags.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		TTTableControlItem* photoTagsItem = [TTTableControlItem itemWithCaption:@"Tags:"
																		 control:photoTags];
		
		UILabel *privacySettings = [[[UILabel alloc] init] autorelease];
		privacySettings.text = @"Privacy Settings";
		privacySettings.font = TTSTYLEVAR(font);
		
		publicSwitch = [[[UISwitch alloc] init] autorelease];
		TTTableControlItem* publicItem = [TTTableControlItem itemWithCaption:@"Public" control:publicSwitch];
		
		UISwitch *friendSwitch = [[[UISwitch alloc] init] autorelease];
		TTTableControlItem* friendsItem = [TTTableControlItem itemWithCaption:@"Friends" control:friendSwitch];
		
		UISwitch *familySwitch = [[[UISwitch alloc] init] autorelease];
		TTTableControlItem* familyItem = [TTTableControlItem itemWithCaption:@"Family" control:familySwitch];
		
		self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
						@"\n",
						   photoTitleItem,
						   photoDescription,
						   photoTagsItem,
						@"Privacy Settings",
						   publicItem,
						   friendsItem,
						   familyItem,
						   nil];
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (NSString *)permsNumber:(BOOL)on
{
	return on ? @"1" : @"0";
}

- (NSDictionary *)photoInfo
{
	if (!photoTitle.text) {
		photoTitle.text = @"MyPhoto";
	}
	if (!photoDescription.text) {
		photoDescription.text = @"Donnot want to write";
	}
	if (!photoTags.text) {
		photoTags.text = @"FlickrView";
	}
	return [NSDictionary dictionaryWithObjectsAndKeys:
			photoTitle.text, @"title", 
			photoDescription.text, @"description",
			photoTags.text, @"tags", 
			[self permsNumber:publicSwitch.on], @"is_public", nil];
}

- (void)upload
{
	[self.delegate _startUpload:[self photoInfo]];
	[self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithTitle:@"Upload" 
											   style:UIBarButtonItemStyleBordered 
											   target:self 
											   action:@selector(upload)] autorelease];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}


@end
