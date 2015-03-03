//
//  ProfileViewerViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewerViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profilePic;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactsLabel;
@property (strong, nonatomic) IBOutlet UILabel *settingsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bluebackgound;
@property (strong, nonatomic) IBOutlet UIImageView *grayBackground;

@property (strong, nonatomic) IBOutlet UIButton *changeProfilePic;

@end
