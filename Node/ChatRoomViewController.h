//
//  ChatRoomViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//
#import "YYTapGesture.h"
#import "VotingBallot.h"
#import <UIKit/UIKit.h>
@interface ChatRoomViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate,NSXMLParserDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *StartTheMessageProperties;
@property (strong, nonatomic) IBOutlet UIButton *regularNodeProperties;
@property (strong, nonatomic) IBOutlet UIButton *pollNodeProperties;
@property (strong, nonatomic) IBOutlet UIButton *sendTheMessageProperties;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *groupPhotoBar;

@property (strong, nonatomic) IBOutlet UIProgressView *messageSentProgressView;

- (IBAction)StartTheMessage:(id)sender;
- (IBAction)VotingBallot1:(id)sender;
- (IBAction)VotingBallot2:(id)sender;
- (IBAction)regularNode:(id)sender;
- (IBAction)pollNode:(id)sender;
- (IBAction)sendTheMessage:(id)sender;
- (IBAction)commentSegueButton:(id)sender;








@property(strong,nonatomic) NSString *topic;
@property(strong, nonatomic) NSString *userName;
@property int groupID;
@end
