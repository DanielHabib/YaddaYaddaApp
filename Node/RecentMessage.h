//
//  RecentMessage.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 3/3/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TopicCell;

@interface RecentMessage : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * tier;
@property (nonatomic, retain) NSNumber * unit;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) TopicCell *groupInfo;

@end
