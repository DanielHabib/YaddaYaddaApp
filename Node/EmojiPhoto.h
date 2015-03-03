//
//  EmojiPhoto.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 3/3/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProfileInfo;

@interface EmojiPhoto : NSManagedObject

@property (nonatomic, retain) NSString * emoji;
@property (nonatomic, retain) NSString * emojiString;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * unlocked;
@property (nonatomic, retain) ProfileInfo *profileInfo;

@end
