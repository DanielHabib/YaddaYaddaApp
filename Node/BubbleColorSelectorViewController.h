//
//  BubbleColorSelectorViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/10/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleColorSelectorViewController : UIViewController

- (IBAction)red:(id)sender;

- (IBAction)orange:(id)sender;

- (IBAction)green:(id)sender;

- (IBAction)Blue:(id)sender;

- (IBAction)Gray:(id)sender;

- (IBAction)Purple:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *greenButton;
@property (strong, nonatomic) IBOutlet UIButton *orangeButton;
@property (strong, nonatomic) IBOutlet UIButton *redButton;
@property (strong, nonatomic) IBOutlet UIButton *purpleButton;
@property (strong, nonatomic) IBOutlet UIButton *greyButton;
@property (strong, nonatomic) IBOutlet UIButton *blueButton;


@property (strong, nonatomic) IBOutlet UILabel *currentBubbleColor;
@property (strong, nonatomic) IBOutlet UIImageView *greyBackground;

@end
