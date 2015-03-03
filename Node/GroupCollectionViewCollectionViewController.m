//
//  GroupCollectionViewCollectionViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 11/4/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "GroupCollectionViewCollectionViewController.h"
#import <dispatch/dispatch.h>
#import "AddAdditionalMembers.h"

@interface GroupCollectionViewCollectionViewController ()

@end

@implementation GroupCollectionViewCollectionViewController{
    NSString * username;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *MemberList;
    NSString *element;
    NSMutableString *memberUpdate;
    NSMutableString *emailUpdate;
    NSString *email;
    NSMutableString*phoneUpdate;
    NSData *imageDataUpdate;
    dispatch_queue_t queue;
    int checkUnit;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    checkUnit = 0;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    
    dispatch_async(queue, ^{
    MemberList = [[NSMutableArray alloc]init];
        [self runXMLParse];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
    [super viewDidLoad];

    username  = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    emailUpdate = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];

    NSLog(@"COUNT:: MEMBERLIST %lu",(unsigned long)[MemberList count]);
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [MemberList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    NSData *memberData;
    NSString*memberUsername;
    // Configure the cell
    memberUsername = [[MemberList objectAtIndex:indexPath.row] objectForKey:@"member"];
    memberData = [[MemberList objectAtIndex:indexPath.row] objectForKey:@"imageData"];
    // replace with user name in group
    //NSLog(@"cellFOund");
    UILabel *label= (UILabel *)[cell viewWithTag:100];
    label.text = memberUsername;
    
    //replace with user image in group
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:40];
    imageView.layer.cornerRadius=10;
    imageView.layer.masksToBounds=YES;
    imageView.image = [UIImage imageWithData: memberData];
 
    
    cell.layer.cornerRadius=10;
    cell.layer.masksToBounds=YES;
    
    return cell;
}

-(void)runXMLParse{
    //runs the parse
    NSLog(@"topic at collection View:%@",self.topic);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topicMembers.php?topic=%d",self.groupID]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    NSLog(@"parser called");
    if ([element isEqualToString:@"Members"]) {
        item    = [[NSMutableDictionary alloc] init];
        memberUpdate  = [[NSMutableString alloc] init];
        imageDataUpdate = [[NSData alloc]init];
        phoneUpdate = [[NSMutableString alloc]init];
        emailUpdate = [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    NSLog(@"Step 1");
    if ([element isEqualToString:@"username"]) {
        [memberUpdate appendString:string];

    }
   else if ([element isEqualToString:@"email"]) {
        [emailUpdate appendString:string];
               imageDataUpdate =[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",emailUpdate]]];
       
   }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
     NSLog(@"3");
    if ([elementName isEqualToString:@"Members"]) {
        [item setObject:memberUpdate forKey:@"member"];
        if (imageDataUpdate) {
            
        
        [item setObject:imageDataUpdate forKey:@"imageData"];
    }
        [item setObject:emailUpdate forKey:@"email"];
        //[item setObject:phoneUpdate forKey:@"phoneNumber"];
        [MemberList addObject:[item copy]];//The problem lies in add objects
        NSLog(@"member update ::%@",memberUpdate);
        memberUpdate=[[NSMutableString alloc]init];
    }}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"error occured");
    NSLog(@"PARSE ERROR %@",parseError );
    
};

#pragma mark <UICollectionViewDelegate>
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"AddMembers"])
    {
        
        
        AddAdditionalMembers *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.groupID = self.groupID;
        vc.topic = [NSString stringWithFormat:@"%@",self.topic];

        vc.memberList = [NSMutableArray arrayWithArray: MemberList];
        
    }
    
    
    
}


@end
