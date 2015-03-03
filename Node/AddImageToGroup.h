//
//  AddImageToGroup.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/8/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AddImageToGroup : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)CameraButton:(id)sender;
- (IBAction)GalleryButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;

//@property (strong, nonatomic) IBOutlet UIButton *Finished;
@property UIImagePickerController *picker;
@property NSString *topic;
@property NSMutableArray *addedMembers;

@property int groupID;
@end