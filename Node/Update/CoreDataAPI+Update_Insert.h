//
//  CoreDataAPI+Update_Insert.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI.h"

@interface CoreDataAPI (Update)

+(void)checkForNeccesaryUpdatesToCoreDataStore;




+(BOOL)updateAllGroupMembersModel;


+(BOOL)newGroupModel:(NSString *)groupName
        groupID:(int)groupID
 groupImageData:(NSData *)imageData;

+(BOOL)updateGroupModelWithGroupID:(int)groupID groupName:(NSString*)groupName groupImage:(NSData *)imageData lastMessage:(NSString *)lastMessage  lastMessageDate:(NSDate *)lastMessageDate  lastMessageUser:(NSString *)lastMessageUser;


+(BOOL)newProfileInformationModelWithUsername:(NSString *)username
                                      email:(NSString *)email
                                    userID :(int)userID
                                phoneNumber:(NSString *)phoneNumber
                               profilePhoto:(NSData *)photo
                                     password:(NSString *)password;
    
+(BOOL)updateProfileInformationModelWithUsername:(NSString *)username
                                      email:(NSString *)email
                                    userID :(int)userID
                                phoneNumber:(NSString *)phoneNumber
                               profilePhoto:(NSData *)photo
                                   password:(NSString *)password;

+(BOOL)newEmojiPhotoModelWithEmojiString:(NSString*)emojiString
                                     emoji:(NSString *)emoji
                               emojiPhoto :(NSData *)photo;
    
    
    
    
 
@end
