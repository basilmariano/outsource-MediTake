//
//  MTProfileViewController.m
//  MTMedicineTaker
//
//  Created by Panfilo Mariano Jr. on 4/8/13.
//  Copyright (c) 2013 Pace Creative Studio. All rights reserved.
//

#import "MTProfileViewController.h"
#import "Profile.h"
#import "PCImageDirectorySaver.h"

@interface MTProfileViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
}
@property(nonatomic,retain) UIImage *previousImage;

@end

@implementation MTProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Profile";
        
        UIImage *cancelImageInactive = [UIImage imageNamed:@"Cancel_btn-ss.png"];
        UIImage *cancelImageActive = [UIImage imageNamed:@"Cancel_btn-s.png"];
        
        UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancel.frame = CGRectMake(0, 0, 65.5, 33.5);
        [buttonCancel setImage:cancelImageInactive forState:UIControlStateNormal];
        [buttonCancel setImage:cancelImageActive forState:UIControlStateHighlighted];
        [buttonCancel addTarget:self action:@selector(onButtonCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonCancel = [[[UIBarButtonItem alloc] initWithCustomView:buttonCancel]autorelease];
        self.navigationItem.leftBarButtonItem = barButtonCancel;
        
        UIImage *doneImageInActive = [UIImage imageNamed:@"Done_btn-ss.png"];
        UIImage *doneImageActive = [UIImage imageNamed:@"Done_btn-s.png"];
        
        UIButton *buttonDone = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDone.frame = CGRectMake(0, 0, 62.5, 33.5);
        [buttonDone setImage:doneImageInActive forState:UIControlStateNormal];
        [buttonDone setImage:doneImageActive forState:UIControlStateHighlighted];
        [buttonDone addTarget:self action:@selector(onButtonDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButtonDone = [[[UIBarButtonItem alloc] initWithCustomView:buttonDone]autorelease];
        self.navigationItem.rightBarButtonItem = barButtonDone;
    }
    return self;
}

- (void) dealloc
{
    [_profileImage release];
    [_profileName release];
    [_previousImage release];
    [super dealloc];
}
- (void) onButtonCancelClicked
{
    NSLog(@"Cancel Clicked");
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_profileName resignFirstResponder];
    return YES;
}

-(IBAction)setProfilePicture:(id)sender
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil] autorelease];
    [actionSheet addButtonWithTitle:@"Take Photo"];
    [actionSheet addButtonWithTitle:@"Choose Photo"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    [_profileName resignFirstResponder];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.previousImage = self.profileImage.imageView.image;
    imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.delegate = self;
    
    if(buttonIndex == 0) {
        NSLog(@"Take Photo");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera ;
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            NSLog(@"Error to take photo");
        }
    }else if(buttonIndex == 1) {
        NSLog(@"Choose Photo");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:imagePicker animated:YES];
        }
        else
        {
            NSLog(@"Error to choose photo");
        }
    }
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.profileImage setImage:_previousImage forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    UIImage *fixedOrientationImage = originalImage;
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        fixedOrientationImage = [originalImage fixOrientation];
    }
    
    UIImage *finalImage = [[PCImageDirectorySaver directorySaver] scaleImage:fixedOrientationImage withScaleToSize:CGSizeMake(100.0f,100.0f)];
    //At this point you have the selected image in originalImage
    [self.profileImage setImage:finalImage forState:UIControlStateNormal];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([Profile profileCount] == 0) {
        self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    }
}


- (void) onButtonDoneClicked
{
     NSLog(@"Done Clicked");
    if(![self.profileName.text isEqualToString:@""]) {
        if([self isProfileExist]){
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information:" message:@"Profile Exist!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
            [alert show];
            [alert release];
            [self dismissModalViewControllerAnimated:YES];
        
        }else{
            Profile *profile = [Profile profile];
            profile.name = self.profileName.text;
            NSLog(@"image %@",self.profileImage.imageView.image);
            profile.profileImagePath = [[PCImageDirectorySaver directorySaver] saveImageInDocumentFileWithImage:self.profileImage.imageView.image andAppendingImageName:[NSString stringWithFormat:@"Profile_%@",self.profileName.text]];
    
            [[ManageObjectModel objectManager] saveContext];
    
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning:" message:@"Please fill out the Profile Name!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (BOOL) isProfileExist
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Profile" inManagedObjectContext:[[ManageObjectModel objectManager] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(name like %@)",self.profileName.text];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects =[[[ManageObjectModel objectManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(fetchedObjects.count ==0)
        return NO;
    else
        return YES;
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
