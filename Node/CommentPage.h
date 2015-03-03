//
//  CommentPage.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 1/12/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentPage : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UILabel *mainPost;
@property NSString *mainPostString;
@property (nonatomic) NSString *topic;
@property(nonatomic)int groupID;
@property(nonatomic)  int unit;


@end
