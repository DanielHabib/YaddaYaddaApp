//
//  BubbleTableViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BubbleTableViewController.h"
#import "BubbleChatViewController.h"
#define MOVERIGHT  255;
#define SWING 7;
@interface BubbleTableViewController ()

@end

@implementation BubbleTableViewController{
    NSXMLParser *parser;
    // NSMutableArray *_objects;
    NSMutableDictionary *item;
    NSMutableArray *TopicList;
    NSMutableString *topic;
    NSString *element;
}

- (id)initWithStyle:(UITableViewStyle)style
{
   // [self.view sendSubviewToBack:_sideView];
       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //[self runXMLParse];
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    

    return self;
}

- (void)viewDidLoad
{
    
    
 /*   for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }*/
    
    
    [super viewDidLoad];
    TopicList = [[NSMutableArray alloc]init];
    [self runXMLParse];
    //  NSLog(@"TESTING : %lu",(unsigned long)[TopicList count]);
    //for (NSString *topicItem in TopicList) {
    //    NSLog(@"topics-");
    //    NSLog(@"%@",topicItem);
    //}
    
    //_userName = self.userName;
    //[self.tableView reloadData];

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
    NSLog(@"%lu",(unsigned long)[TopicList count]);
    return [TopicList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSString *topicText = [[TopicList objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%@/groupPic.jpg",[TopicList objectAtIndex:indexPath.row]]]];
    
    
    cell.imageView.image =[UIImage imageWithData:imageData];
    cell.imageView.layer.cornerRadius =  40;
    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = topicText;
    return cell;
    
}
-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:@"http://104.131.53.146/topicList.php"];
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

    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    //NSLog(@"Step 1");
    if ([element isEqualToString:@"topic"]) {
        [topic appendString:string];
       // NSLog(@"%@",topic);
        //NSLog(@"Found User");
        //NSLog(@"title element found – create a new instance of Title class...");
    }


}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
   // NSLog(@"3");
    if ([elementName isEqualToString:@"Topics"]) {
        [item setObject:topic forKey:@"topic"];
        [TopicList addObject:[topic copy]];//The problem lies in add objects
        
        topic  = [[NSMutableString alloc] init];

    }}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    topic = [TopicList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"sceneSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"sceneSegue"])
    {
         BubbleChatViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",topic];
        vc.userName = [NSString stringWithFormat:@"%@",_userName];
    }}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sidebarMenu:(id)sender {
}
@end
