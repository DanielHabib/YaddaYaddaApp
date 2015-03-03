//
//  ProfileInfo.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 3/3/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EmojiPhoto;

@interface ProfileInfo : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * phonenumber;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *emojiPhotos;
@end

@interface ProfileInfo (CoreDataGeneratedAccessors)

- (void)addEmojiPhotosObject:(EmojiPhoto *)value;
- (void)removeEmojiPhotosObject:(EmojiPhoto *)value;
- (void)addEmojiPhotos:(NSSet *)values;
- (void)removeEmojiPhotos:(NSSet *)values;

@end
