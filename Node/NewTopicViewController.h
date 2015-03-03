//
//  NewTopicViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/19/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitationPage.h"

@interface NewTopicViewController : UIViewController <UITextFieldDelegate>
//@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)nextButtonAction:(id)sender;

@end
