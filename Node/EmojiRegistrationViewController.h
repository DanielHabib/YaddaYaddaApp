//
//  EmojiRegistrationViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiPictureChangeViewController.h"

@interface EmojiRegistrationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *happy;
- (IBAction)happyButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *angelic;
- (IBAction)angelButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *sleepy;

- (IBAction)sleepyButton:(id)sender;



@end
