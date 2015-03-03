//
//  CoreDataAPI+Fetch.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 2/24/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CoreDataAPI+Fetch.h"
#import "AFNetworking.h"

@implementation CoreDataAPI (Fetch)


+(NSArray *)fetchSpecificGroupMemberModelWithUserID:(int)userID{
    
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupMember" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d",@"userid",userID];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setEntity:entity];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Unable to fetch Specific Group Member ");
        NSLog(@"%@,%@",error,error.description);
    }else{
        NSLog(@"Fetched Specific Group Member succesfully");
    }
    return result;
    
    
    
}




+(NSArray *)fetchSpecificGroupModelWithGroupID:(int)groupID{
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupInfo" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d",@"groupID",groupID];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setEntity:entity];
    [fetch setPredicate:predicate];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetch error:&error];
    if (error) {
        
        NSLog(@"Unable to Fetch specific Group");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }else{
        NSLog(@"Specific Group fetched Successfully");
    }
    return result;
    
    
}
+(NSArray *)fetchGroupListModel{
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GroupInfo" inManagedObjectContext:context];
    NSSortDescriptor *orderByActivity = [[NSSortDescriptor alloc]initWithKey:@"lastMessageDate" ascending:NO];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setEntity:entity];
    [fetch setSortDescriptors:@[orderByActivity]];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetch error:&error];
    if (error) {
        
        NSLog(@"Unable to Fetch group List");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }else{
        NSLog(@"GroupList fetched Successfully");
    }
    return result;
}


+(NSArray *)fetchProfileInfoModel{
    
    
    
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ProfileInfo" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    
    [fetch setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *profileInformation = [context executeFetchRequest:fetch error:&error];
    
    if (error) {
        NSLog(@"Unable To Fetch Profile Information");
        NSLog(@"%@, %@", error, error.localizedDescription);

    }else{
        NSLog(@"Profile Information Fetched Successfully");
    }
    return profileInformation;
}


+(NSArray *)fetchAllEmojiPhotosModel{
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmojiPhoto" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    [fetch setEntity:entity];
    NSError *error = nil;
    NSArray *result =[context executeFetchRequest:fetch error:&error];
    
    if (error) {
        NSLog(@"Fetching All emojis failed");
    }else{
        NSLog(@"Fetching All emojis Successful");
    }
    return  result;
}


+(NSArray *)fetchSpecificEmojiEntitiyModel:(NSString *)emoji{
    NSManagedObjectContext *context = [self grabGlobalManagedObjectContext];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entitiy = [NSEntityDescription entityForName:@"EmojiPhoto" inManagedObjectContext:context];
    [fetch setEntity:entitiy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@",@"emoji",emoji];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result =[context executeFetchRequest:fetch error:&error];
    
    if (error) {
        NSLog(@"Fetching Specific Emoji Failed");
    }else{
        NSLog(@"Fetching Specific Emoji Successful");
    }
    //Handle an Empty Result
    return result;
}
+(NSArray *)fetchUpdatedGroupMemberListFromServerModel{
    NSArray *result = [CoreDataAPI fetchProfileInfo];
    ProfileInfo *profInfo = [[ProfileInfo alloc]init];
    if ([result count]>0) {
        profInfo = [result objectAtIndex:0];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"userID": profInfo.userID};
    [manager POST:@"104.131.53.146" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
        return [[NSArray alloc]init];

    }else{

    return [[NSArray alloc]init];
    }
}

@end
