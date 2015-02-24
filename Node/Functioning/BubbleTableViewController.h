//
//  BubbleTableViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong,nonatomic)NSString *userName;
- (IBAction)sidebarMenu:(id)sender;

@end
