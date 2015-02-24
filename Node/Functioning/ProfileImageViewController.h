//
//  ProfileImageViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *image;
- (IBAction)imageButton:(id)sender;
@property UIImagePickerController *picker;
- (IBAction)lookUpPhoto:(id)sender;
- (IBAction)imageSubmit:(id)sender;

@end
