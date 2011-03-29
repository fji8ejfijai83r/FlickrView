//
//  FillPhotoInfoViewController.h
//  FlickrView
//
//  Created by HD hiessu on 11-3-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FillPhotoInfoViewControllerDelegate
- (void)_startUpload:(NSDictionary *)photoInfoDic;
@end


@interface FillPhotoInfoViewController : TTTableViewController {
	id<FillPhotoInfoViewControllerDelegate> delegate;
}

@property (nonatomic, retain)  UITextField* photoTitle;
@property (nonatomic, retain)  TTTextEditor* photoDescription;
@property (nonatomic, retain)  UITextField* photoTags;

@property (nonatomic, retain)  UISwitch *publicSwitch;
@property (nonatomic, retain)  UISwitch *friendSwitch;
@property (nonatomic, retain)  UISwitch *familySwitch;

@property (nonatomic, assign)  id<FillPhotoInfoViewControllerDelegate> delegate; 

@end
