//
//  AddAdditionalMembers.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@interface AddAdditionalMembers : UITableViewController<NSXMLParserDelegate>
@property NSString* topic;
@property int groupID;
@property NSMutableArray *memberList;
@end
