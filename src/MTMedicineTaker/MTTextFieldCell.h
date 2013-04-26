//
//  MTTextFieldCell.h
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/18/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTTextFieldCell;

@protocol MTTextFieldCellDelegate <NSObject>

@optional
- (void)textFieldFinishedTyping:(UITextField *)textField andTextFieldId:(NSNumber *)textFieldId;
- (void)textFieldWillStartTyping:(NSUInteger) cellIndex;

@end

@interface MTTextFieldCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITextField *textField;
@property (nonatomic, assign) IBOutlet UILabel *title;
@property (nonatomic, assign) IBOutlet UIButton *buttonDone;
@property (nonatomic, assign) UIView *viewParam;
@property (nonatomic, retain) NSString *placeHolder;
@property (nonatomic, assign) id<MTTextFieldCellDelegate> delegate;
@property (nonatomic) int textFieldRange;
@property (nonatomic) NSUInteger textId;
@property (nonatomic) NSUInteger index;

@end
