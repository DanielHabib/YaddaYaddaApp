//
//  BubbleTableViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BubbleTableViewController.h"
#import "BubbleChatViewController.h"
#import "ChatRoomViewController.h"
#import <dispatch/dispatch.h>
#import "YaddaYaddaNavigationViewController.h"
#import "AppDelegate.h"
#import "CoreDataAssembly.h"
#import "CoreDataAPI.h"

#define MOVERIGHT  255;
#define SWING 7;
@interface BubbleTableViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;


@end

@implementation BubbleTableViewController{
    NSXMLParser *parser;
    // NSMutableArray *_objects;
    NSMutableDictionary *FBInfo;
    NSMutableArray *TopicList;
    NSMutableArray *groupIDList;
    NSMutableArray *lastMessageMetaDataArray;
    NSMutableString *topic;
    NSMutableString *groupIDUpdate;
    NSMutableString *lastMessageUpdate;
    NSMutableString *lastMessageUserIDUpdate;
    NSMutableString *lastMessageDateUpdate;
    NSMutableDictionary *item;

    NSMutableDictionary *groupMetaData;
    
    NSString *element;
    NSString *phone;
    dispatch_queue_t queue;
    
    UIImageView *logo;
    
    NSString *email;
    NSString* username;
    NSString* password;
    
    int fbID;
    int groupID;
    int userID;
    
    BOOL returningUser;
    BOOL groupMetaDataComplete;
}

@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    NSLog(@"%@",self.coreDataResultArray);
    
    self.coreDataResultArray = [[NSMutableArray alloc]init];
    
    self.coreDataResultArray = [CoreDataAPI fetchGroupList];
    
    logo = [[UIImageView alloc]init];
    groupMetaDataComplete = false;
    phone = [[NSMutableString alloc] init];
    phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [super viewDidLoad];
    groupIDList = [[NSMutableArray alloc]init];
    TopicList = [[NSMutableArray alloc]init];
    lastMessageMetaDataArray = [[NSMutableArray alloc]init];

    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            //NSLog(@"user info: %@", result);

            FBInfo = result;
            email=[FBInfo objectForKey:@"email"];
            NSLog(@"email ::%@",email);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:email forKey:@"email"];
            [defaults synchronize];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/checkIfAccountExists.php?email=%@",email]];
            parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];

        } else {
            // An error occurred, we need to handle the error
            
        }
    }];    dispatch_sync(queue, ^{
    
        [self runXMLParse];
    });
    [self customizeNaviBar];
    [self groupMetaDataArrayConstructor];
   // self.managedObjectContext = [[NSManagedObjectContext alloc]init]
    //[self insertNewObject:@"testing"];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    if (false){//groupMetaDataComplete) {
        return [TopicList count];
    }else{
        return [self.coreDataResultArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    id groupIDT = [groupIDList objectAtIndex:indexPath.row];
    __block NSData *imageData;
    __block NSString *topicText;
    __block UILabel *Topic = (UILabel *)[cell viewWithTag:2];
    __block UIImageView *groupImage = (UIImageView *)[cell viewWithTag:1];
    __block UILabel *lastMessage = (UILabel *)[cell viewWithTag:3];
    __block UILabel *lastUpdateDate = (UILabel *)[cell viewWithTag:4];
    
    if (groupMetaDataComplete) {
        
        NSMutableDictionary * groupData = [groupMetaData objectForKey:[NSString stringWithFormat:@"%@",groupIDT]];
        NSData *groupImageData = [groupData objectForKey:@"image"];
        NSString *title = [groupData objectForKey:@"title"];
        NSString *user = [groupData objectForKey:@"user"];
        NSString *message = [groupData objectForKey:@"message"];
        NSString *dateH = [groupData objectForKey:@"date"];
//        NSDate *date = [CoreDataAPI stringToDateConverter:dateH];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
//        NSInteger hour = [components hour];
//        NSInteger minute = [components minute];
        
        Topic.text = title;
        groupImage.image = [UIImage imageWithData:groupImageData];
        lastMessage.text = [NSString stringWithFormat:@"%@ : %@ ",user,message];
        lastUpdateDate.text = [[dateH substringFromIndex:10] substringToIndex:6];
        
    }else{

        if (true) {
            dispatch_async(queue, ^{
                TopicCell *groupInfo = [self.coreDataResultArray objectAtIndex:indexPath.row];
                
               
                topicText = groupInfo.groupName;
                imageData = groupInfo.groupImage;
                
                dispatch_sync(dispatch_get_main_queue(),^{
                    NSLog(@"%@",groupInfo);
                    groupImage.image=[UIImage imageWithData:imageData];
                    lastMessage.text = groupInfo.lastMessage;
                    Topic.text = topicText;
                    
                });
            });
        }else{
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
        dispatch_async(queue, ^{
    
        
            topicText = [[TopicList objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
      
            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%@/groupPic.jpg",[groupIDList objectAtIndex:indexPath.row]]]];
        
            dispatch_sync(dispatch_get_main_queue(),^{
                groupImage.image=[UIImage imageWithData:imageData];
            });
    
        });
    
        Topic.text = [TopicList objectAtIndex:indexPath.row];
  
        }
    }
    
    return cell;
    
}









-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topicList.php?email=%@",email]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"Topics"]) {
        item    = [[NSMutableDictionary alloc] init];
        topic  = [[NSMutableString alloc] init];
        groupIDUpdate = [[NSMutableString alloc]init];
        lastMessageUpdate = [[NSMutableString alloc]init];
        lastMessageUserIDUpdate = [[NSMutableString alloc]init];
        lastMessageDateUpdate = [[NSMutableString alloc]init];

        
    }else if ([element isEqualToString:@"true"]){
        returningUser=true;
        
        [CoreDataAPI newProfileInformationWithUsername:username email:email userID:0 phoneNumber:nil profilePhoto:nil password:password];
        if ([TopicList count]== 0) {
            [self runXMLParse];
        }
    }else if ([element isEqualToString:@"false"]){
        returningUser=false;
        [self createAccount];
//        NSLog(@"create account");
//        NSLog(@"%@",FBInfo);
        NSUserDefaults*defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:email forKey:@"email"];
        [defaults setValue:[FBInfo objectForKey:@"first_name"] forKey:@"username"];
        //[defaults setValue:[FBInfo objectForKey:@"fbid"] forKey:@"fbid"];
        [defaults synchronize];
        [self.tableView reloadData];
    }else if ([element isEqualToString:@"registration"]){
        NSLog(@"register realized");
    }
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
   // NSLog(@"Step 1");
    if ([element isEqualToString:@"topic"]) {
        [topic appendString:string];
    }
    else if ([element isEqualToString:@"id"]) {
        [groupIDUpdate appendString:string];
    }else if ([element isEqualToString:@"added"]){
        [lastMessageDateUpdate appendString:string];
    }
    else if ([element isEqualToString:@"userID"]){
        [lastMessageUserIDUpdate appendString:string];
    }else if ([element isEqualToString:@"message"]){
        [lastMessageUpdate appendString:string];
    }
}
// CLEAN THIS PARSING UP TO FIX THE INCORRECT GROUP MATCHING PROBLEM
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
   // NSLog(@"3");
    if ([elementName isEqualToString:@"Topics"]) {
        // this is the questionable part
        [item setObject:[NSNumber numberWithInt:[groupIDUpdate intValue]] forKey:@"groupID"];
        [item setObject:topic forKey:@"topic"];
        [item setObject:lastMessageUpdate forKey:@"lastMessage"];
        [item setObject:lastMessageUserIDUpdate forKey:@"userID"];
        [item setObject:lastMessageDateUpdate forKey:@"date"];
        [lastMessageMetaDataArray addObject:item];
        
        [TopicList addObject:[topic copy]];//The problem lies in add objects
        [groupIDList addObject:[groupIDUpdate copy]];
    
    }
}
- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError{   
  //  NSLog(@"parse error");
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    topic = [TopicList objectAtIndex:indexPath.row];
    groupID = [[groupIDList objectAtIndex:indexPath.row] intValue];
   [self performSegueWithIdentifier:@"chatSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"sceneSegue"])
    {
         BubbleChatViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",topic];
        vc.userName = [NSString stringWithFormat:@"%@",_userName];
    }

    else if ([[segue identifier] isEqualToString:@"chatSegue"])
    {
        ChatRoomViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",topic];
        vc.groupID = groupID;
        vc.userName = [NSString stringWithFormat:@"%@",_userName];
    }
}


-(void)groupMetaDataArrayConstructor{
    groupMetaData=[[NSMutableDictionary alloc]init];
    dispatch_queue_t queueT = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    
    dispatch_async(queueT, ^{
        
        for (NSString*groupIDT in groupIDList) {
            NSMutableDictionary * groupInfo = [[NSMutableDictionary alloc]init];
            NSInteger index = [groupIDList indexOfObject:groupIDT];
            NSString* title=[[TopicList objectAtIndex:index] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            NSData * groupImage = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%@/groupPic.jpg",groupIDT]]];
            
            NSMutableDictionary *itemH = [lastMessageMetaDataArray objectAtIndex:index];
            NSString *date = [itemH objectForKey:@"date"];
            NSString *userIDH =[itemH objectForKey:@"userID"];

            NSArray *result = [CoreDataAPI fetchSpecificGroupMemberWithUserID:[userIDH intValue]];
            NSString *user = @"placeHolder";
            if ([result count]!=0) {
                GroupMember *specificMember = [result objectAtIndex:0];
                user = specificMember.username;
                
            }else{
             
                user = @"NoUserFound";
            }
            
            NSString *lastMessage = [itemH objectForKey:@"lastMessage"];
           // NSString *lastMessageAdded = [[date substringFromIndex:[date length]-8] substringToIndex:5];
            NSString *lastMessageAdded = date;
            NSLog(@"%@",date);
            NSString *lastMessageUser = user;
            
            if (!groupImage) {
                groupImage = UIImagePNGRepresentation([UIImage imageNamed:@"YY.png"]);
            }

            [groupInfo setObject:userIDH forKey:@"userID"];
            [groupInfo setObject:groupIDT forKey:@"id"];
            [groupInfo setObject:title forKey:@"title"];
            [groupInfo setObject:groupImage forKey:@"image"];
            [groupInfo setObject:lastMessage forKey:@"message"];
            [groupInfo setObject:lastMessageAdded forKey:@"date"];
            [groupInfo setObject:lastMessageUser forKey:@"user"];
            
            [groupMetaData setObject:groupInfo forKey:groupIDT];
            
        }
        groupMetaDataComplete = true;
        NSLog(@"GroupMemberMetaData Load Complete");
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            
        
            [self.tableView reloadData];
            [self updateCoreDataResultArray];
        });
    });
}

-(void)customizeNaviBar{
    logo =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YYLogo40x40.png"]];
    logo.backgroundColor = [UIColor clearColor];
    logo.userInteractionEnabled = YES;
    self.navigationItem.titleView = logo;
    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *logoTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(spinTheLogo)];
    [logo addGestureRecognizer:logoTapped];
    
//    self.navigationItem.leftBarButtonItem.image = [[UIImage imageNamed:@"stockProfImage.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem.tintColor =[UIColor grayColor];
    
    
    

}

-(void)spinTheLogo{
    NSLog(@"spint the Logo recognized");
    CGFloat duration=0.5;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0  ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    [logo.layer addAnimation:rotationAnimation forKey:@"LogoSpin"];
    
}


-(void)postDeviceID{
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* DeviceToken = [defaults objectForKey:@"DeviceToken"];
        NSString *post = [NSString stringWithFormat:@"&email=%@&DeviceToken=%@",email,DeviceToken];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateDeviceToken.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        // NSString *isValid =[NSString stringwit]
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }

}
-(void)createAccount{
    
    NSString *firstName = [FBInfo objectForKey:@"first_name"];
    NSString *post = [NSString stringWithFormat:@"&username=%@&email=%@&",firstName,email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/registration.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    // NSString *isValid =[NSString stringwit]
    if(conn) {
        NSLog(@"Connection Successful");
        
        [CoreDataAPI newProfileInformationWithUsername:username email:email userID:0 phoneNumber:nil profilePhoto:nil password:password];
    } else {
        NSLog(@"Connection could not be made");
    }
    NSLog(@"Newly Registered Account");
    
}

- (IBAction)sidebarMenu:(id)sender {
}
-(void)updateCoreDataResultArray{

    dispatch_queue_t queueH = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queueH, ^{
    
        for ( NSString *groupIDT in groupIDList) {
            
            
            int groupIDH = [groupIDT intValue];
            NSMutableDictionary * groupData = [groupMetaData objectForKey:groupIDT];
           // int groupIDH = [[groupData objectForKey:@"id"]intValue];
            NSArray *result = [CoreDataAPI fetchSpecificGroupWithGroupID:groupIDH];
            NSData *groupImageData = [groupData objectForKey:@"image"];
            NSString *title = [groupData objectForKey:@"title"];
            NSString *message = [groupData objectForKey:@"message"];
            if ([result count]>0) {
                NSDate *date = [CoreDataAPI stringToDateConverter:[groupData objectForKey:@"date"]];
                
                NSString *user = [groupData objectForKey:@"user"];
                
                

                
                
                
                
                [CoreDataAPI updateGroupWithGroupID:groupIDH groupName:title groupImage:groupImageData lastMessage:message lastMessageDate:date lastMessageUser:user];
            }
            else {
                [CoreDataAPI newGroup:title groupID:groupIDH groupImageData:groupImageData];
            }
        }
        NSLog(@"Core Data Array Updated");
    });

}



@end
