//
//  TopicCell.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 3/3/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GroupMember, RecentMessage;

@interface TopicCell : NSManagedObject

@property (nonatomic, retain) NSString * lastMessage;
@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSData * groupImage;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSDate * lastMessageDate;
@property (nonatomic, retain) NSString * lastMessageUser;
@property (nonatomic, retain) NSSet *groupMembers;
@property (nonatomic, retain) NSSet *recentMessages;
@end

@interface TopicCell (CoreDataGeneratedAccessors)

- (void)addGroupMembersObject:(GroupMember *)value;
- (void)removeGroupMembersObject:(GroupMember *)value;
- (void)addGroupMembers:(NSSet *)values;
- (void)removeGroupMembers:(NSSet *)values;

- (void)addRecentMessagesObject:(RecentMessage *)value;
- (void)removeRecentMessagesObject:(RecentMessage *)value;
- (void)addRecentMessages:(NSSet *)values;
- (void)removeRecentMessages:(NSSet *)values;

@end
