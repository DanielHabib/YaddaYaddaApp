//
//  BubbleTableViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface BubbleTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate,NSFetchedResultsControllerDelegate>
{

}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic)NSArray *coreDataResultArray;




@property (strong,nonatomic)NSString *userName;
- (IBAction)sidebarMenu:(id)sender;

@end
