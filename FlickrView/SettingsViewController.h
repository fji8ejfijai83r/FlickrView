//
//  SettingsViewController.h
//  FlickrView
//
//  Created by HD hiessu on 11-5-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
	UIButton *signInOrOut;
}

@property (nonatomic, retain) IBOutlet UIButton *signInOrOut; 

- (IBAction)signInOrOut;
- (IBAction)clearCache;
@end
