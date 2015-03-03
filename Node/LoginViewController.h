//
//  LoginViewController.h
//  Node
//
//  Created by Daniel Habib on 9/11/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//
//#import "Globals.h"
#import "ViewController.h"
#import <UIKit/UIKit.h>

//#import "GLOBALS.h"
@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *logoSpot;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)loginButton:(id)sender;

@end
