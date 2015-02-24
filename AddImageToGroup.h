//
//  AddImageToGroup.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/8/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageToGroup : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)GalleryButton:(id)sender;
- (IBAction)CameraButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIImagePickerController *picker;
@property NSString *topic;

@end