//
//  MTProfileViewController.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProfileViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic,retain) IBOutlet UITextField *profileName;
@property (nonatomic,retain) IBOutlet UIButton *profileImage;

-(IBAction)setProfilePicture:(id)sender;
@end
