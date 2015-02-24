//
//  TopicCell.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 1/23/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TopicCell : NSManagedObject

@property (nonatomic, retain) NSData * topicImage;
@property (nonatomic, retain) NSString * topicName;
@property (nonatomic, retain) NSNumber * lastMessage;

@end
