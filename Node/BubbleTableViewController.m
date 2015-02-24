//
//  BubbleTableViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BubbleTableViewController.h"
#import "BubbleChatViewController.h"
#import <dispatch/dispatch.h>
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
    NSString *phone;
    dispatch_queue_t queue;
    
    NSString* username;
    NSString* password;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//   // [self.view sendSubviewToBack:_sideView];
//       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    //[self runXMLParse];
//    
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    
//
//    return self;
//}

- (void)viewDidLoad
{
    phone = [[NSMutableString alloc] init];
    phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    username=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSLog(@"phoneValue = :%@",phone);
    

    
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [super viewDidLoad];
    
    TopicList = [[NSMutableArray alloc]init];
    dispatch_sync(queue, ^{
            [self runXMLParse];

    });

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
    cell.imageView.image=[UIImage imageNamed:@"gray.jpeg"];
    cell.imageView.layer.cornerRadius =  cell.imageView.frame.size.width/2;
    cell.imageView.layer.masksToBounds = YES;
    __block NSData *imageData;
    __block NSString *topicText;
    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        
        
        
    topicText = [[TopicList objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%@/groupPic.jpg",[TopicList objectAtIndex:indexPath.row]]]];
        
    
        dispatch_sync(dispatch_get_main_queue(),^{
                cell.imageView.image =[UIImage imageWithData:imageData];
                //cell.imageView.layer.cornerRadius = cell.imageView.layer.frame.size.width/2;
                cell.textLabel.text = topicText;
                cell.textLabel.font = [UIFont fontWithName:@"NexaLight" size:12];
        });
    });

    
   

    return cell;
    
}
-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topicList.php?phoneNumber=%@&username=%@&password=%@",phone,username,password]];
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
    NSLog(@"Step 1");
    if ([element isEqualToString:@"topic"]) {
        [topic appendString:string];
        NSLog(@"topic loading:::%@",topic);

    }


}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
   // NSLog(@"3");
    if ([elementName isEqualToString:@"topic"]) {
        [item setObject:topic forKey:@"topic"];
        [TopicList addObject:[topic copy]];//The problem lies in add objects
        topic = [[NSMutableString alloc]init];
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
