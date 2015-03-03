//
//  ProfileAdjustment.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 1/6/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileAdjustment : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneInputTextField;
@property (strong, nonatomic) IBOutlet UIButton *PhoneSync;
- (IBAction)buttonPressed:(id)sender;

@end
