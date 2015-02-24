//
//  ChatRoomViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ChatRoomViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate>
- (IBAction)testbutton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
