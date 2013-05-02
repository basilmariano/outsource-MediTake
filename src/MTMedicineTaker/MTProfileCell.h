//
//  MTProfileCell.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/3/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCAsyncImageView.h"

@interface MTProfileCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *profileName;
@property (nonatomic, assign) IBOutlet UIImageView *arrowImage;
//@property (nonatomic, assign) IBOutlet PCAsyncImageView *profileImageView;
@property (nonatomic, assign) IBOutlet UIImageView *profileImage;


@end
