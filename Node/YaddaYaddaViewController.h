//
//  YaddaYaddaViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customizeGroup.h"
#import <SpriteKit/SpriteKit.h>
#import "textFieldView.h"
#import "CommentPageTableViewController.h"
#import <dispatch/dispatch.h>
#import <AudioToolbox/AudioToolbox.h>


@interface YaddaYaddaViewController : UIViewController<UIScrollViewDelegate, UITextViewDelegate, NSXMLParserDelegate>{
}
- (IBAction)voteBubble:(id)sender;
- (IBAction)SendTheMessage:(UIButton *)sender;
- (IBAction)StartTheMessage:(UIButton *)sender;
- (IBAction)regularChatBubble:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *RegularChatBubbleDesc;

@property (strong, nonatomic) IBOutlet UIButton *BlueBubble;
@property (strong, nonatomic) IBOutlet UIButton *purpleVoteBubble;
@property (strong, nonatomic) IBOutlet UIButton *GreenBubble;
@property CGPoint start;
@property CGPoint end;
@property(strong,nonatomic) NSString *topic;
@property(strong, nonatomic) NSString *userName;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonCustomize;
@property(strong,nonatomic)IBOutlet UINavigationItem *naviBar;
@end
