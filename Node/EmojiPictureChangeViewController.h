//
//  EmojiPictureChangeViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiPictureChangeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property UIImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) NSString *emojiType;
- (IBAction)takeImage:(id)sender;
- (IBAction)Submit:(id)sender;
- (IBAction)Gallery:(id)sender;

@end
