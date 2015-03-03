//
//  CommentPage.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 1/12/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "CommentPage.h"

@implementation CommentPage{
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
    self.mainPost.text=self.mainPostString;
    self.mainPost.layer.cornerRadius = self.mainPost.frame.size.width/2;
    self.mainPost.layer.masksToBounds = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        [self runXMLParse];
        
    });
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, nil, self.view.frame.size.width/2, self.mainPost.frame.origin.y+self.mainPost.frame.size.height/2);
//    CGPathAddLineToPoint(path, nil, 40, self.mainPost.frame.origin.y+self.mainPost.frame.size.height/2);
    
    UIColor * pathColor = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0];
    
    CGPoint start = CGPointMake(self.view.frame.size.width/2, self.mainPost.frame.origin.y+self.mainPost.frame.size.height/2);
    CGPoint bend = CGPointMake(25,self.mainPost.frame.origin.y+self.mainPost.frame.size.height/2);
    CGPoint end = CGPointMake(25, self.view.frame.size.height);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:start];
    [path addLineToPoint:bend];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:bend];
    [path2 addLineToPoint:end];
    
    
    
    //[path addLineToPoint:end];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [pathColor CGColor];
    shapeLayer.lineWidth = 3.0;
//    shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    shapeLayer.zPosition = -4;
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.path = [path2 CGPath];
    shapeLayer2.strokeColor = [pathColor CGColor];
    shapeLayer2.lineWidth = 3.0;
    //    shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    shapeLayer2.zPosition = -4;
    
    
    
    [self.view.layer addSublayer:shapeLayer];
    [self.view.layer addSublayer:shapeLayer2];
    
    
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
    UILabel *messageLabel = (UILabel *)[cell viewWithTag:20];
    UILabel *colorIndicator = (UILabel *)[cell viewWithTag:30];
    

    
    
    colorIndicator.layer.cornerRadius = colorIndicator.frame.size.width/2;
    colorIndicator.layer.masksToBounds = YES;
    
    
    
    NameLabel.text =name ;
    messageLabel.text = message;
    //messageLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
    messageLabel.layer.cornerRadius = 10;
    messageLabel.layer.masksToBounds = YES;
    messageLabel.numberOfLines = 0;
    messageLabel.translatesAutoresizingMaskIntoConstraints=NO;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    
    height=150;
    
    return height;
}














-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/commentPage.php?topic=%@&unit=%d&topicID=%d",self.topic,self.unit,self.groupID]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        item    = [[NSMutableDictionary alloc] init];
        userUpdate  = [[NSMutableString alloc] init];
        MessageUpdate= [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    if ([element isEqualToString:@"message"]) {
        [MessageUpdate appendString:string];
    }
    else if([element isEqualToString:@"username"]){
        [userUpdate appendString:string];
    }
    
    
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@",self.topic]]) {
        
        if (MessageUpdate) {
            // NSLog(@"Message Pre::%@",messageUpdate);
            
            NSData *data = [MessageUpdate dataUsingEncoding:NSUTF8StringEncoding];
            @try {
                MessageUpdate = [[NSMutableString alloc] initWithString: [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding]];
            }
            @catch (NSException *exception) {
                //[NSException raise:@"Invalid messageUpdate Value" format:@"The value %@ cannot be processed", messageUpdate];
            }
            @finally {
                // NSLog(@"Message Post::%@",messageUpdate);
                
            }
            
            
            
            
        }
        
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
