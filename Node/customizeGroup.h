//
//  customizeGroup.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAdditionalMembers.h"

@interface customizeGroup : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *greyBackground;
@property (strong, nonatomic) IBOutlet UILabel *addToGroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *deleteGroupLabel;
@property NSString *topic;


@property int groupID;
- (IBAction)leaveGroup:(id)sender;

- (IBAction)editPicture:(id)sender;

@end
