//
//  GroupMember.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 3/3/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TopicCell;

@interface GroupMember : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) TopicCell *groupInfo;

@end
