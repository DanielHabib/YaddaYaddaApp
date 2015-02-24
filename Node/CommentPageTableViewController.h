//
//  CommentPageTableViewController.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 11/12/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentPageTableViewController : UITableViewController<NSXMLParserDelegate>
@property (nonatomic) NSString *topic;
@property(nonatomic)  int unit;

@end
