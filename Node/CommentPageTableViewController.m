//
//  CommentPageTableViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 11/12/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "CommentPageTableViewController.h"

@interface CommentPageTableViewController ()


@end

@implementation CommentPageTableViewController{
    NSMutableArray *commentList;
    NSMutableString *userUpdate;
    NSMutableString *MessageUpdate;
    NSString *element;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    dispatch_queue_t queue;
    
    
}

- (void)viewDidLoad {
    commentList = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        [self runXMLParse];
        
    });

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
    return [commentList count];
}

-(void)runXMLParse{
    //runs the parse
    NSLog(@"topic at collection View:%@",self.topic);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/commentPage.php?topic=%@&unit=%d",self.topic,self.unit]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    NSLog(@"parser called");
    if ([element isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        item    = [[NSMutableDictionary alloc] init];
        userUpdate  = [[NSMutableString alloc] init];
        MessageUpdate= [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    NSLog(@"Step 1");
    if ([element isEqualToString:@"message"]) {
        [MessageUpdate appendString:string];
    }
    else if([element isEqualToString:@"username"]){
        [userUpdate appendString:string];
        }

    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"3");
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@",self.topic]]) {
        [item setObject:MessageUpdate forKey:@"message"];
        [item setObject:userUpdate forKey:@"username"];
        [commentList addObject:[item copy]];//The problem lies in add objects
        //NSLog(@"member update ::%@",MessageUpdate);
       // messageUpdate=[[NSMutableString alloc]init];
    }}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"error occured");
    NSLog(@"PARSE ERROR %@",parseError );
    
};







- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    
    
   NSMutableDictionary* comment= [commentList objectAtIndex:indexPath.row];
    NSString*message = comment[@"message"];
    NSString*name= comment[@"username"];
    
    UILabel *NameLabel = (UILabel *)[cell viewWithTag:10];
    NameLabel.text =name ;
    UILabel *messageLabel = (UILabel *)[cell viewWithTag:20];
    messageLabel.text = message;
    messageLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
    messageLabel.layer.cornerRadius = 10;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.numberOfLines = 0;
    messageLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
  
    // Configure the cell...
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
