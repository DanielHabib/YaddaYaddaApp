//
//  InvitationPage.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/10/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "InvitationPage.h"
#import <dispatch/dispatch.h>
@interface InvitationPage ()

@end

@implementation InvitationPage{
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *MemberList;
    NSString *element;

    NSMutableString *memberNumberUpdate;
    NSMutableString *usernameUpdate;
                      
    NSString * addressBookNum;
    CFArrayRef allPeople;
    ABAddressBookRef addressBook;
    NSMutableArray *addedMembers;
    NSMutableArray *listOfPhoneNumbers;
    NSMutableArray *selected;
    dispatch_queue_t queue;

}






- (void)viewDidLoad {
    MemberList = [[NSMutableArray alloc]init];
    addedMembers = [[NSMutableArray alloc]init];
    selected = [[NSMutableArray alloc]init];
    [self runXMLParse];

    [super viewDidLoad];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSLog(@"count:%lu",(unsigned long)[MemberList count]);
    return  [MemberList count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
   NSString* phone ;

    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    
    NSString *username;
    
    
    phone = [[MemberList objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
    username= [[MemberList objectAtIndex:indexPath.row] objectForKey:@"username"];
    __block NSData *imageData;
    //Recipe *recipe = [recipes objectAtIndex:indexPath.row];
    UIImageView *profileImageView = (UIImageView *)[cell viewWithTag:20];
    profileImageView.layer.cornerRadius=profileImageView.frame.size.width/2;
    profileImageView.layer.masksToBounds=YES;
    profileImageView.image= [UIImage imageNamed:@"blueToPurpleGradient.png"];
    
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",phone]]];
                   dispatch_sync(dispatch_get_main_queue(), ^{
                       dispatch_sync(queue, ^{
                           if (imageData) {
                           profileImageView.image= [UIImage imageWithData:  imageData];
                           }
                       });
                profileImageView.image =   [UIImage imageWithData:imageData];

        });
                   
                   
                   
    });
    
    UILabel *NameLabel = (UILabel *)[cell viewWithTag:30];
    NameLabel.text = username;

    
    UIImageView *addedImageView = (UIImageView *)[cell viewWithTag:10];
    
    if ([[selected objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
        addedImageView.image=[UIImage imageNamed:@"memberAdded"];
    }
    else{
        addedImageView.image = [UIImage imageNamed:@"addIn.png"];

    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *phone = [[MemberList objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
    //if (![listOfPhoneNumbers containsObject:phone]) {
       // if ([self postTest:phone]) {
    
    
    if ([[selected objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
        
    
    [addedMembers addObject:phone];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:@"memberAdded.png"];
    
    UIImageView *addedImageView = (UIImageView *)[cell viewWithTag:10];
    addedImageView.image = [UIImage imageNamed:@"memberAdded.png"];
    NSString *number = @"1";
    [selected setObject:number atIndexedSubscript:indexPath.row];
}
    else{
        [addedMembers removeObjectIdenticalTo:phone];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *addedImageView = (UIImageView *)[cell viewWithTag:10];
        addedImageView.image = [UIImage imageNamed:@"addIn.png"];
        NSString *number = @"0";
        [selected setObject:number atIndexedSubscript:indexPath.row];
        
        
    }
//}

    //Add in + animation----------------------------------------------------
    
    //topic = [TopicList objectAtIndex:indexPath.row];
   // [self performSegueWithIdentifier:@"sceneSegue" sender:self];
}





-(NSString *)cleanThePhoneNumber:(NSString *)phoneNumber{
  
   __block NSString *phoneNumber1 = [NSString stringWithFormat:phoneNumber];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@")" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumber1 = [phoneNumber1 stringByReplacingOccurrencesOfString:@"+1" withString:@""];
    });
    return phoneNumber1;
}



-(BOOL)postTest:(NSString *)phoneNumber{
    
    __block BOOL hold;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{

    
        NSString *strURL = [NSString stringWithFormat:@"http://104.131.53.146/checkPhoneNumber.php?phoneNumber=%@",phoneNumber];
        NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
        NSString *strResult = [[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding];
        
        
        
        
        
    if ([strResult length] > 1) {
        
    
        NSString *verificationString =[strResult substringFromIndex: [strResult length] - 4];
    
        NSLog(@"%@",verificationString);
        if ([@"Pass" isEqualToString:verificationString]) {
            hold =  YES;
        }
    }
    
    });
    
 
    if (hold) {
        return YES;
    }
        return NO;
    
    
    
    
    
}





-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    */
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"InvToImage"])
    {
        
        
        
        [addedMembers addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]];
        AddImageToGroup *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",self.topic];
        vc.addedMembers = [NSMutableArray arrayWithArray:addedMembers];

    }
}

-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/allMembers.php"]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"Members"]) {
        item    = [[NSMutableDictionary alloc] init];
        memberNumberUpdate  = [[NSMutableString alloc] init];
        usernameUpdate =[[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    if ([element isEqualToString:@"phoneNumber"]) {
        [memberNumberUpdate appendString:string];
        
    }
    else if ([element isEqualToString:@"username"]){
        [usernameUpdate appendString:string];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Members"]) {
        NSLog(@"memberNumberUpdate::%@",memberNumberUpdate);
        NSLog(@"usernameUpdate: %@",usernameUpdate);
        [item setObject:memberNumberUpdate forKey:@"phoneNumber"];
        [item setObject:usernameUpdate forKey:@"username"];
        [MemberList addObject:item];//The problem lies in add objects
        [selected addObject:@"0"];
    }}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"error occured");
    NSLog(@"PARSE ERROR %@",parseError );
    
};


@end
