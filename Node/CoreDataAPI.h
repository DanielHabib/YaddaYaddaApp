//
//  CoreDataAPI.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataAssembly.h"

#import "EmojiPhoto.h"
#import "RecentMessage.h"
#import "ProfileInfo.h"
#import "GroupMember.h"
#import "TopicCell.h"

@interface CoreDataAPI : NSObject
// Make to work with NSFetchedResultsController
@property NSManagedObjectContext * context;
+(BOOL)saveContext:(NSManagedObjectContext *)context;
+(NSManagedObjectContext *)grabGlobalManagedObjectContext;
+(NSManagedObjectModel *)grabGlobalyManagedObjectModel;
+(NSPersistentStoreCoordinator *)grabGloballyPersistentStoreCoordinator;
+(NSDate *)stringToDateConverter:(NSString *)date;


#pragma mark -Update/Insert
+(BOOL)newProfileInformationWithUsername:(NSString *)username
                                      email:(NSString *)email
                                    userID :(int)userID
                                phoneNumber:(NSString *)phoneNumber
                               profilePhoto:(NSData *)photo
                                password:(NSString *)password;
+(BOOL)updateProfileInformationWithUsername:(NSString *)username
                                      email:(NSString *)email
                                    userID :(int)userID
                                phoneNumber:(NSString *)phoneNumber
                               profilePhoto:(NSData *)photo
                                   password:(NSString *)password;

+(BOOL)newEmojiPhotoWithEmojiString:(NSString*)emojiString
                              emoji:(NSString *)emoji
                        emojiPhoto :(NSData *)photo;
+(BOOL)newGroup:(NSString *)groupName
             groupID:(int)groupID
      groupImageData:(NSData *)imageData;
+(BOOL)updateGroupWithGroupID:(int)groupID
                         groupName:(NSString*)groupName
                        groupImage:(NSData *)imageData
                       lastMessage:(NSString *)lastMessage
                   lastMessageDate:(NSDate *)lastMessageDate
              lastMessageUser:(NSString *)lastMessageUser;
+(BOOL)updateAllGroupMembers;
#pragma mark - Fetch
+(NSArray *)fetchUpdatedGroupMemberListFromServer;

+(NSArray *)fetchSpecificGroupMemberWithUserID:(int)userID;
+(NSArray *)fetchProfileInfo;
+(NSArray *)fetchAllEmojiPhotos;
+(NSArray *)fetchSpecificEmojiEntitiy:(NSString *)emoji;
+(NSArray *)fetchGroupList;
+(NSArray *)fetchSpecificGroupWithGroupID:(int)groupID;




#pragma mark - Delete
+ (void)deleteAllObjectsInCoreData;
+(void)deleteGroupWithGroupID:(int)groupID;






@end
