//
//  registrationViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/13/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registrationViewController : UIViewController <UITextFieldDelegate>
//@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordConfirmationTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UILabel *logo;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber2;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber3;
@property (strong, nonatomic) IBOutlet UIButton *createVerifLabel;

@property (strong, nonatomic) IBOutlet UIImageView *confirmPasswordVerifImage;

@property (strong, nonatomic) IBOutlet UIImageView *passwordVerifImage;

@property (strong, nonatomic) IBOutlet UIImageView *usernameVerifImage;

@property (strong, nonatomic) IBOutlet UIImageView *phoneVerifImage;
- (IBAction)registrationButton:(id)sender;

@end
