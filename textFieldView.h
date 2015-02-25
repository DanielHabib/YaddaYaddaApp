//
//  textFieldView.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/23/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textFieldView : UIViewController
- (IBAction)sendMessage:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@end
