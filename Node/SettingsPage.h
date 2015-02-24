//
//  SettingsPage.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsPage : UIViewController
- (IBAction)logOut:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *privacy;
@property (strong, nonatomic) IBOutlet UILabel *suppourt;
@property (strong, nonatomic) IBOutlet UILabel *notifications;
@property (strong, nonatomic) IBOutlet UILabel *logOut;
@property (strong, nonatomic) IBOutlet UILabel *logo;

@end
