//
//  ChatRoomViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/1/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//
#import "ChatRoomViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import <dispatch/dispatch.h>
#import "UITextView+VerticalAlignment.h"
#import "customizeGroup.h"
#import "YYCommentButton.h"
#import "CommentPage.h"

#define HTTP_HEADER 30
#define HTTP_BODY 20
#define LABEL_WIDTH 140
#define OPTION_WIDTH 80
#define POLL_BAR_WIDTH 140;
#define STANDARD_CELL_HEIGHT 200;
@interface ChatRoomViewController ()
{
    
    
    
    //storage
    NSMutableDictionary *groupMemberData;
    //Constants
    CGFloat SCREEN_WIDTH;
    CGFloat SCREEN_HEIGHT;
    BOOL live;
    BOOL groupMemberDataFlag;
    NSString * phonenumber;
    NSMutableString *bubbleColor;
    
    //Parsing
    __block NSXMLParser *parser;
    __block NSMutableDictionary *item;
    __block NSString *element;
    __block NSString *email;
    __block NSMutableString *CommentsUpdate;
    __block NSMutableString *contentHeightUpdate;
    __block NSMutableString *unitUpdate;
    __block NSMutableString *userUpdate;
    __block NSMutableString *messageUpdate;
    __block NSMutableString *colorUpdate;
    __block NSMutableString *emailUpdate;
    __block NSMutableString *identifier;
    __block NSMutableString *pathColor;
    __block NSMutableString *pathStyle;
    __block NSMutableString *option1Update;
    __block NSMutableString *option2Update;
    __block NSMutableString *timeUpdate;
    __block NSMutableString *tier;
    __block NSMutableString *phoneNumberUpdate;
    __block NSMutableArray *NodeList;
    __block NSMutableArray *PollList;
    //PollParsing

    __block NSMutableString *pollIdUpdate;
    __block NSMutableString *stats1Update;
    __block NSMutableString *stats2Update;
    __block NSMutableString *votedUpdate;
    
    int highestID;
    int highestUnit;
    int lowestUnit;
    BOOL isParseRunning;
    
    UIImageView *groupPhoto;
    
    NSUInteger  scrollCheck;
    NSInteger instanceKey;
    GCDAsyncSocket *socket;
    int commentUnit;
    NSMutableString*mainPost;
    //Storage arrays and dictionaries
    __block NSMutableArray *CellClassList;
    __block NSMutableDictionary *CellList;// Late to be used for quick lookup
    __block NSMutableDictionary *CommentDictionary;
    __block NSMutableArray *commentTestingList;
    //Threading
    NSMutableArray *parseQueue;
    //UIElements
    UITextView *textField;
    UITextView *option1Entry;
    UITextView *option2Entry;
    UIVisualEffectView *visualEffectView;

    //dispatch_queue_t queue;
    
    //Posting Related
    int unitComment;
    int tierCreation;
    int highestUnitForScroll;
   // UITapGestureRecognizer *nodeTapped;
}
@end

@implementation ChatRoomViewController


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prep segue noticed");
    if ([[segue identifier] isEqualToString:@"customize"])
    {
        
        
        
        customizeGroup *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",self.topic];
        vc.groupID = self.groupID;
        [socket readDataWithTimeout:-1 buffer:0 bufferOffset:0 maxLength:1000 tag:HTTP_BODY];
        
    }else if ([[segue identifier] isEqualToString:@"commentPage"]){
        
        CommentPage *vc = [segue destinationViewController];
        vc.unit = commentUnit;
        vc.topic = self.topic;
        vc.groupID = self.groupID;
        vc.mainPostString = mainPost;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUpObserver];
    if ([CellClassList count]>3) {
//     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[CellClassList count]-1 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        scrollCheck = [CellClassList count];
    }


    if ([socket isDisconnected]) {
        NSError *err = nil;
        if (![socket connectToHost:@"104.131.53.146" onPort:8080 error:&err]) // Asynchronous!
        {
            NSLog(@"I goofed: %@", err);
        }

        
        
        
        
        
    }
    live=true;
    
    
    [self groupMemberData];
    [self.tableView reloadData];
   // [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.view.frame.size.height)];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    groupMemberData = [[NSMutableDictionary alloc]init];
    groupMemberDataFlag=false;
    NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
    [output setObject:@"dis" forKey:@"type"];
    [output setObject:[NSString stringWithFormat:@"%ld",(long)instanceKey] forKey:@"instanceKey"];
    [output setObject:[NSString stringWithFormat:@"%d", self.groupID] forKey:@"groupID"];
    [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];
    
}
- (void)viewDidLoad {
    live=false;
    groupMemberDataFlag=false;
    lowestUnit = 0;
    mainPost = [[NSMutableString alloc]init];
    isParseRunning=false;
    [super viewDidLoad];
    groupPhoto = [[UIImageView alloc]init];
    self.messageSentProgressView.backgroundColor= [UIColor clearColor];
    self.messageSentProgressView.tintColor=[UIColor blueColor];
    self.sendTheMessageProperties.layer.cornerRadius=self.sendTheMessageProperties.frame.size.width/2;
    self.sendTheMessageProperties.layer.masksToBounds=YES; 
    self.navigationItem.title=[self.topic stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    self.tableView.separatorColor = [UIColor clearColor];
    phonenumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    bubbleColor =[[NSUserDefaults standardUserDefaults] objectForKey:@"bubbleColor"];
    highestID = 0;
    highestUnitForScroll=0;
    SCREEN_WIDTH = self.view.frame.size.width;
    SCREEN_HEIGHT = self.view.frame.size.height;
    PollList = [[NSMutableArray alloc]init];
    parseQueue = [[NSMutableArray alloc]init];
    CellClassList = [[NSMutableArray alloc]init];
    CommentDictionary = [[NSMutableDictionary alloc]init];
    commentTestingList = [[NSMutableArray alloc]init];
    groupMemberData=[[NSMutableDictionary alloc]init];
    email = [[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //self.groupID=1;
    //NSLog(@"groupID %d",self.groupID);
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.groupPhotoBar.image=[UIImage imageNamed:@"gray.jpeg"];
    dispatch_queue_t queuePhoto = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    __block NSData *imageData;
    dispatch_async(queuePhoto, ^{
           imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/topics/%d/groupPic.jpg",self.groupID]]];// Change to groupID
        dispatch_sync(dispatch_get_main_queue(), ^{
          //  self.groupPhotoBar.image = [UIImage imageWithData:imageData];
            
            
        });
        
    });
    
    
    
    NSError *err = nil;
    if (![socket connectToHost:@"104.131.53.146" onPort:8080 error:&err]) // Asynchronous!
    {
        NSLog(@"I goofed: %@", err);
    }
    
    
    
    CGFloat pattern[2];
    pattern[0] = 10.0;
    pattern[1] = 10.0;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.view.frame.size.width/4, 0)];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width/4, self.view.frame.size.height)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    
//    CGPathRef pathHolder=CGPathCreateCopyByDashingPath([path CGPath], NULL, 0, pattern, 2) ;
    //shapeLayer.path = pathHolder;
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[self colorWithHexString:@"D7D7D7"] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[self colorWithHexString:@"D7D7D7"] CGColor];
    shapeLayer.zPosition = -4;
    [self.view.layer addSublayer:shapeLayer];
    
    
    
    
    
    
    
    

    [socket readDataWithTimeout:-1 buffer:0 bufferOffset:0 maxLength:1000 tag:HTTP_BODY];
    [self runNodeParse];
    [parseQueue addObject:@"comment"];
    [parseQueue addObject:@"poll"];
    [self.view bringSubviewToFront:self.StartTheMessageProperties];
    option1Entry=[[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.height, self.view.frame.size.width/2, 0, 0)];
    option2Entry=[[UITextView alloc]initWithFrame:CGRectMake(self.view.frame.size.height, self.view.frame.size.width/2, 0, 0)];
    option1Entry.backgroundColor=option2Entry.backgroundColor=[self colorWithHexString:@"8EBEF1"];
    option1Entry.keyboardType=option2Entry.keyboardType=UIKeyboardTypeDefault;
    option1Entry.userInteractionEnabled=option2Entry.userInteractionEnabled=NO;
    option1Entry.textAlignment=option2Entry.textAlignment=NSTextAlignmentCenter;
    option1Entry.layer.cornerRadius = option2Entry.layer.cornerRadius=10;
    option1Entry.layer.masksToBounds = option2Entry.layer.masksToBounds=YES;
    option1Entry.textColor=option2Entry.textColor=[UIColor whiteColor];
    
    
    [self.view addSubview:option1Entry];
    [self.view addSubview:option2Entry];
    textField = [[UITextView alloc] initWithFrame:CGRectMake(0, -200 , 10 , 10)];
    //textField.font = [UIFont fontWithName:@"Nexa Light" size:12];
    textField.font = [UIFont fontWithName:@"Times" size:12];
    textField.textColor = [UIColor blackColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.userInteractionEnabled = NO;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.backgroundColor = [UIColor whiteColor];
    textField.backgroundColor =[self colorWithHexString: bubbleColor];
    textField.layer.cornerRadius = LABEL_WIDTH/2;
    textField.layer.masksToBounds = YES;
    [self.view addSubview:textField];
   
    
    [option1Entry addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [option2Entry addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [textField addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

    self.pollNodeProperties.alpha=0;
    self.pollNodeProperties.userInteractionEnabled=NO;
    self.regularNodeProperties.alpha=0;
    self.regularNodeProperties.userInteractionEnabled=NO;
    self.sendTheMessageProperties.alpha=0;
    self.sendTheMessageProperties.userInteractionEnabled=NO;
    // nodeTapped=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectNodeTap:)];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectSingleTap:)];
    [self.tableView addGestureRecognizer:singleTap];
    [self.view bringSubviewToFront:self.messageSentProgressView];

    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width );
 //   [self customizeNaviBar];
}

-(void)detectNodeTap:(YYTapGesture *)tapRec{
    tierCreation=2;
    unitComment=tapRec.unit;
//    NSLog(@"tap recognized");
//    NSLog(@"tapRec unit:%d",tapRec.unit);
    [textField becomeFirstResponder];
    
    
}
-(void)detectSingleTap:(UIGestureRecognizer *)tapRec{
    [textField resignFirstResponder];
    
}


#pragma mark - tableviewcelldelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [CellClassList count];
}
- (void)drawRect:(CGRect)rect {
    CGFloat rectHeight = CGRectGetHeight(rect);
    CGFloat rectWidth = CGRectGetWidth(rect);
    
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:CGPointMake(0, rectHeight / 2)];
    [line addLineToPoint:CGPointMake(rectWidth, rectHeight / 2)];
    
    [[UIColor lightGrayColor] setStroke];
    [line stroke];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    
    YYTapGesture *  nodeTapped=[[YYTapGesture alloc]initWithTarget:self action:@selector(detectNodeTap:)];
    
       if ([CellClassList count]>=indexPath.row ) {
    
    NSMutableDictionary* Cell=[CellClassList objectAtIndex:indexPath.row];
           nodeTapped.unit = [[Cell objectForKey:@"unit"]intValue];

    if ([[Cell objectForKey:@"tier"] isEqualToString:@"1"]) {
        if ([[Cell objectForKey:@"unit"] intValue]%2||true) {
            static NSString *simpleTableIdentifier = @"OddNode";
            cell.backgroundColor = [UIColor clearColor];

            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
           //NSLog(@"%f", cell.frame.size.height) ;
            

           if ([[Cell objectForKey:@"unit"]intValue]!=0) {
               if(indexPath.row!=0){
                   NSMutableDictionary*prevCell =[CellClassList objectAtIndex:indexPath.row-1];
                   if ([[prevCell objectForKey:@"tier"]intValue]!=3) {

                       
                       
                       
                       
                       

                   }
                }
           }
           
        
            
            __block UIImageView *profImage = (UIImageView *)[cell viewWithTag:108];
            profImage.layer.cornerRadius=profImage.frame.size.width/2;
            profImage.layer.masksToBounds=YES;
            NSString *emailForProfileCreation= [Cell objectForKey:@"email"];
            //__block NSData *imageData;
            
            
            if ([Cell objectForKey:@"emojiFlag"]) {

                
                NSString *emojiString= [Cell objectForKey:@"emojiFlag"];
                NSString *emailCell= [Cell objectForKey:@"email"];
                NSString *key = [emailCell stringByAppendingString:emojiString];
                
                if ([groupMemberData objectForKey:key]) {
                    NSData * imageData = [[groupMemberData copy]objectForKey:key];
                    profImage.image = [UIImage imageWithData:imageData];
                }
                else{
                    profImage.image = [UIImage imageNamed:@"YY.png"];

                }
                
                
            }
            else{
            if (groupMemberDataFlag) {
                profImage.image = [UIImage imageWithData:[groupMemberData objectForKey:emailForProfileCreation]];
               // profImage.image = [UIImage imageNamed:@"grayBackground.png"];

            }else{
                profImage.image = [UIImage imageNamed:@"YY.png"];
            }
            }
            
            

            YYCommentButton *commentSegue = (YYCommentButton *)[cell viewWithTag:109];
            [commentSegue setTitle:@"" forState:UIControlStateNormal] ;
            UILabel *message1 = (UILabel *)[cell viewWithTag:102];
            message1.text=@"";
            message1.font = [UIFont fontWithName:@"Times" size:13];
            message1.backgroundColor = [UIColor clearColor];
            UILabel *message2 = (UILabel *)[cell viewWithTag:103];
            message2.text=@"";
            message2.font = [UIFont fontWithName:@"Times" size:13];

            message2.backgroundColor = [UIColor clearColor];
            UILabel *message3 = (UILabel *)[cell viewWithTag:104];
            message3.text=@"";
            message3.font = [UIFont fontWithName:@"Times" size:13];

            message3.backgroundColor = [UIColor clearColor];
            UILabel *user = (UILabel *)[cell viewWithTag:100];
            user.text =[Cell objectForKey:@"username"];
            if ([[Cell objectForKey:@"email"]isEqualToString:email]) {
                user.textColor = [self colorWithHexString:@"2B2B2B"];
            }else {
                user.textColor = [self colorWithHexString:@"B8B8B8"];
            }
            
            
            UILabel *commentUser1 = (UILabel *)[cell viewWithTag:105];
            commentUser1.alpha=0;
            UILabel *commentUser2 = (UILabel *)[cell viewWithTag:106];
            commentUser2.alpha=0;
            UILabel *commentUser3 = (UILabel *)[cell viewWithTag:107];
            commentUser3.alpha=0;
            UIView *color1 = (UIView*)[cell viewWithTag:111];
            UIView *color2 = (UIView*)[cell viewWithTag:112];
            UIView *color3 = (UIView*)[cell viewWithTag:113];
            color1.alpha=color2.alpha=color3.alpha=0;
            UILabel *message = (UILabel *)[cell viewWithTag:101];
            message.text =[Cell objectForKey:@"message"];
            
            [message addGestureRecognizer:nodeTapped];
            message.userInteractionEnabled=YES;
            
            UILabel *time = (UILabel *)[cell viewWithTag:130];
            time.text = [Cell objectForKey:@"time"];
            
            
           //message.font = [UIFont fontWithName:@"Nexa Bold" size:12];
           // message.backgroundColor =[self colorWithHexString: [Cell objectForKey:@"color"]];
            message.numberOfLines = 0;
            message.lineBreakMode = NSLineBreakByWordWrapping;
            //[message sizeToFit];
            message.layer.cornerRadius = message.frame.size.width/2;
            message.layer.masksToBounds=YES;
            
            //[message sizeToFit];
            //[cell sizeToFit];
            
            
            
            if ([Cell objectForKey:@"comment1"]) {
                NSMutableDictionary * comments=[Cell objectForKey:@"comment1"];
                
                UILabel *commentUser = (UILabel *)[cell viewWithTag:105];
                commentUser.text=[comments objectForKey:@"username"];
                commentUser.alpha=1;
                commentUser.font = [UIFont fontWithName:@"Times" size:9];
                if ([[comments objectForKey:@"email"]isEqualToString:email]) {
                    commentUser.textColor = [self colorWithHexString:@"2B2B2B"];
                }
                     else{
                         commentUser.textColor = [self colorWithHexString:@"B8B8B8"];
                     }
                commentUser.textColor =[UIColor grayColor];

                
                UILabel *comment1 = (UILabel *)[cell viewWithTag:102];
                comment1.text = [comments objectForKey:@"message" ];
                comment1.numberOfLines=0;
                comment1.lineBreakMode = NSLineBreakByCharWrapping;
                //comment1.backgroundColor = [self colorWithHexString:@"E3E3E3"];
                YYCommentButton *commentSegue = (YYCommentButton *)[cell viewWithTag:109];
                commentSegue.mainPost = [Cell objectForKey:@"message"];
                [commentSegue setTitle:@"..." forState:UIControlStateNormal] ;

                commentSegue.unit=[[comments objectForKey:@"unit"]intValue];

                //comment1.font=[UIFont fontWithName:@"NexaLight" size:12];
                comment1.layer.cornerRadius = 10;
                comment1.layer.masksToBounds = YES;
                if (comment1.text.length > 60) {
                    comment1.text = [comment1.text substringToIndex:60];
                    comment1.text = [comment1.text stringByAppendingString:@"..."];
                }
                
                UIView *colorIndicator = (UIView*)[cell viewWithTag:111];
                colorIndicator.backgroundColor = [UIColor yellowColor];
                colorIndicator.layer.cornerRadius = colorIndicator.frame.size.width/2;
                colorIndicator.layer.masksToBounds=YES;
                colorIndicator.alpha=1;
                //[cell addSubview:colorIndicator];
                
                if ([Cell objectForKey:@"comment2"]) {
                    NSMutableDictionary * comments2=[Cell objectForKey:@"comment2"];
                    UILabel *comment2 = (UILabel *)[cell viewWithTag:103];
                    comment2.text = [comments2 objectForKey:@"message"];
                    comment2.numberOfLines=0;
                    comment2.lineBreakMode = NSLineBreakByCharWrapping;
                    //comment2.backgroundColor = [self colorWithHexString:@"E3E3E3"];                    //comment2.backgroundColor = [UIColor grayColor];
                    comment2.layer.cornerRadius = 10;
                    comment2.layer.masksToBounds = YES;
                    UILabel *commentUser2 = (UILabel *)[cell viewWithTag:106];
                    commentUser2.text=[comments2 objectForKey:@"username"];
                    commentUser2.alpha=1;
                    if ([[comments2 objectForKey:@"email"]isEqualToString:email]) {
                        commentUser2.textColor = [self colorWithHexString:@"2B2B2B"];
                    }
                    else{
                        commentUser2.textColor = [self colorWithHexString:@"B8B8B8"];
                    }
                    commentUser2.textColor=[UIColor grayColor];
                    commentUser2.font = [UIFont fontWithName:@"Times" size:9];
                   // comment2.font=[UIFont fontWithName:@"Nexa Light" size:12];
                    if (comment2.text.length > 60) {
                        comment2.text = [comment2.text substringToIndex:60];
                        comment2.text = [comment2.text stringByAppendingString:@"..."];
                    }
                    UIView *colorIndicator2 = (UIView*)[cell viewWithTag:112];
                    colorIndicator2.backgroundColor = [UIColor grayColor];
                    colorIndicator2.layer.cornerRadius = colorIndicator.frame.size.width/2;
                    colorIndicator2.layer.masksToBounds=YES;
                    colorIndicator2.alpha=1;

                    if ([Cell objectForKey:@"comment3"]) {
                        
                        NSMutableDictionary * comments3=[Cell objectForKey:@"comment3"];
                        UILabel *comment3 = (UILabel *)[cell viewWithTag:104];
                        comment3.text = [comments3 objectForKey:@"message"];
                        comment3.numberOfLines=0;
                        comment3.lineBreakMode = NSLineBreakByCharWrapping;
                        //comment3.backgroundColor = [self colorWithHexString:@"E3E3E3"];
                        if ([[comments3 objectForKey:@"email"]isEqualToString:email]) {
                            commentUser3.textColor = [self colorWithHexString:@"2B2B2B"];
                        }
                        else{
                            commentUser3.textColor = [self colorWithHexString:@"B8B8B8"];
                        }
                        UILabel *commentUser3 = (UILabel *)[cell viewWithTag:107];
                        commentUser3.text=[comments3 objectForKey:@"username"];
                        commentUser3.alpha=1;
                        commentUser3.textColor=[UIColor grayColor];
                        commentUser3.font = [UIFont fontWithName:@"Times" size:9];
                        
                        comment3.layer.cornerRadius = 10;
                        comment3.layer.masksToBounds = YES;
                       // comment3.font=[UIFont fontWithName:@"Nexa Light" size:12];
                        if (comment3.text.length > 60) {
                            comment3.text = [comment3.text substringToIndex:60];
                            comment3.text = [comment3.text stringByAppendingString:@"..."];
                        }
                        UIView *colorIndicator3 = (UIView*)[cell viewWithTag:113];
                        colorIndicator3.backgroundColor = [UIColor blueColor];
                        colorIndicator3.layer.cornerRadius = colorIndicator.frame.size.width/2;
                        colorIndicator3.layer.masksToBounds=YES;
                        colorIndicator3.alpha=1;
                    }
                }
            }
            

            [cell bringSubviewToFront:profImage];

        }else{
            static NSString *simpleTableIdentifier = @"EvenNode";
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
           
            
            if (cell == nil) {
                

                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            __block UIImageView *profImage=(UIImageView *)[cell viewWithTag:208];
            profImage.image = [UIImage imageNamed:@"grayBackground.png"];
            profImage.layer.cornerRadius=profImage.frame.size.width/2;
            profImage.layer.masksToBounds=YES;
            NSString *emailForProfileCreation= [Cell objectForKey:@"email"];

            if (!groupMemberDataFlag) {
                profImage.image = [UIImage imageWithData:[groupMemberData objectForKey:emailForProfileCreation]];
            }
            UILabel *message1 = (UILabel *)[cell viewWithTag:202];
            message1.text=@"";

            message1.backgroundColor = [UIColor clearColor];
            UILabel *message2 = (UILabel *)[cell viewWithTag:203];
            message2.text=@"";
            message2.backgroundColor = [UIColor clearColor];
            UILabel *message3 = (UILabel *)[cell viewWithTag:204];
            message3.text=@"";
            message3.backgroundColor = [UIColor clearColor];
            UILabel *user = (UILabel *)[cell viewWithTag:200];
            user.text =[Cell objectForKey:@"username"];
            UILabel *commentUser1 = (UILabel *)[cell viewWithTag:205];
            commentUser1.alpha=0;
            UILabel *commentUser2 = (UILabel *)[cell viewWithTag:206];
            commentUser2.alpha=0;
            UILabel *commentUser3 = (UILabel *)[cell viewWithTag:207];
            commentUser3.alpha=0;
            
            UILabel *message = (UILabel *)[cell viewWithTag:201];
            message.text =[Cell objectForKey:@"message"];
            
            [message addGestureRecognizer:nodeTapped];
            message.userInteractionEnabled=YES;
           // message.font = [UIFont fontWithName:@"Nexa Light" size:12];
            //message.backgroundColor =[self colorWithHexString: [Cell objectForKey:@"color"]];
            message.numberOfLines = 0;
            message.lineBreakMode = NSLineBreakByWordWrapping;
            //[message sizeToFit];
            message.layer.cornerRadius = message.frame.size.width/2;
            message.layer.masksToBounds=YES;
            //[message sizeToFit];
            //[cell sizeToFit];
            
            
            
            if ([Cell objectForKey:@"comment1"]) {
                NSMutableDictionary * comments=[Cell objectForKey:@"comment1"];

                
                
                    UILabel *comment1 = (UILabel *)[cell viewWithTag:202];
                    comment1.text = [comments objectForKey:@"message" ];
                    comment1.numberOfLines=0;
                    comment1.lineBreakMode = NSLineBreakByCharWrapping;
                    comment1.backgroundColor = [self colorWithHexString:@"E3E3E3"];                    comment1.layer.cornerRadius = 10;
                    comment1.layer.masksToBounds = YES;
               // comment1.font = [UIFont fontWithName:@"Nexa Light" size:12];
                UILabel *commentUser1 = (UILabel *)[cell viewWithTag:205];
                commentUser1.text=[comments objectForKey:@"username"];
                commentUser1.alpha=1;
                    if (comment1.text.length > 60) {
                        comment1.text = [comment1.text substringToIndex:60];
                        comment1.text = [comment1.text stringByAppendingString:@"..."];
                    }
                comment1.alpha=.9;
                if ([Cell objectForKey:@"comment2"]) {
                    NSMutableDictionary * comments2=[Cell objectForKey:@"comment2"];
                    UILabel *comment2 = (UILabel *)[cell viewWithTag:203];
                    comment2.text = [comments2 objectForKey:@"message"];
                    comment2.numberOfLines=0;
                    comment2.lineBreakMode = NSLineBreakByCharWrapping;
                    comment2.backgroundColor = [self colorWithHexString:@"E3E3E3"];                    UILabel *commentUser2 = (UILabel *)[cell viewWithTag:206];
                    commentUser2.text=[comments objectForKey:@"username"];
                    commentUser2.alpha=1;
                    comment2.layer.cornerRadius = 10;
                    comment2.layer.masksToBounds = YES;
                    //comment2.font=[UIFont fontWithName:@"Nexa Light" size:12];
                    comment2.alpha=.9;
                    if (comment2.text.length > 60) {
                        comment2.text = [comment2.text substringToIndex:60];
                        comment2.text = [comment2.text stringByAppendingString:@"..."];
                    }
                    
                    if ([Cell objectForKey:@"comment3"]) {
                        
                        NSMutableDictionary * comments3=[Cell objectForKey:@"comment3"];
                        UILabel *comment3 = (UILabel *)[cell viewWithTag:204];
                        comment3.text = [comments3 objectForKey:@"message"];
                        comment3.numberOfLines=0;
                        comment3.lineBreakMode = NSLineBreakByCharWrapping;
                        comment3.backgroundColor = [self colorWithHexString:@"E3E3E3"];                        UILabel *commentUser3 = (UILabel *)[cell viewWithTag:207];
                        commentUser3.text=[comments objectForKey:@"username"];
                        commentUser3.alpha=1;
                        comment3.layer.cornerRadius = 10;
                        comment3.layer.masksToBounds = YES;
                       // comment3.font=[UIFont fontWithName:@"Nexa Light" size:12];
                        comment3.alpha=.9;
                        if (comment3.text.length > 60) {
                            comment3.text = [comment3.text substringToIndex:60];
                            comment3.text = [comment3.text stringByAppendingString:@"..."];
                        }
                    }
                }
            }
        }
        cell.backgroundColor = [UIColor clearColor];

    }
    else if ([[Cell objectForKey:@"tier"] isEqualToString:@"3"]){
        
        
        
        
        
        if ([[Cell objectForKey:@"selected"]isEqualToString:@"0"]) {
            

        static NSString *simpleTableIdentifier = @"PollCell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            NSLog(@"cell ==nil");
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
            UILabel *message = (UILabel *)[cell viewWithTag:301];
            message.text = [Cell objectForKey:@"message"];
           // message.font = [UIFont fontWithName:@"Nexa Bold" size:14];
            VotingBallot *option1 = (VotingBallot *)[cell viewWithTag:302];
            [option1 setTitle:[Cell objectForKey:@"option1"] forState:UIControlStateNormal];
            [self.tableView bringSubviewToFront:option1];
            VotingBallot *option2 = (VotingBallot *)[cell viewWithTag:303];
            [option2 setTitle:[Cell objectForKey:@"option2"] forState:UIControlStateNormal];
            [self.tableView bringSubviewToFront:option2];
            option1.backgroundColor=option2.backgroundColor= [self colorWithHexString:@"8EBEF1"];
            option1.unit = option2.unit = [Cell objectForKey:@"unit"];
            option1.layer.cornerRadius = option2.layer.cornerRadius = 5;
            option1.layer.masksToBounds = option2.layer.masksToBounds = YES;
            option1.pollID=option2.pollID=[[Cell objectForKey:@"pollID"]intValue];
        }
        else if ([[Cell objectForKey:@"selected"]isEqualToString:@"1"]){
            
            static NSString *simpleTableIdentifier = @"PollVoted";
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil) {
                NSLog(@"cell ==nil");
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            //fill in the rest of it
            UILabel *message = (UILabel *)[cell viewWithTag:351];
            UILabel *option1 = (UILabel *)[cell viewWithTag:352];
            UILabel *option2 = (UILabel *)[cell viewWithTag:353];
            UILabel *stats1 = (UILabel *)[cell viewWithTag:354];
            UILabel *stats2 = (UILabel *)[cell viewWithTag:355];
            
            message.text = [Cell objectForKey:@"message"];
            message.layer.cornerRadius = message.frame.size.width/2;
            message.layer.masksToBounds = YES;
           // message.font = [UIFont fontWithName:@"Nexa Light" size:12];
            option1.text = [Cell objectForKey:@"option1"];
            option2.text = [Cell objectForKey:@"option2"];
            //option1.font = option2.font = [UIFont fontWithName:@"Nexa Light" size:9];
            option1.numberOfLines=option2.numberOfLines=0;
            option1.lineBreakMode=option2.lineBreakMode = NSLineBreakByCharWrapping;
            
            
            [option1 setTransform:CGAffineTransformMakeRotation(-45.0/360.0)];
            [option2 setTransform:CGAffineTransformMakeRotation(-45.0/360.0)];
            stats1.backgroundColor = [self colorWithHexString:@"C7E1A9"];
            stats2.backgroundColor = [self colorWithHexString:@"A5C3CE"];
            stats1.text=stats2.text = @"";
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

            dispatch_async(queue, ^{
                
                
                
                CGFloat statsOne;
                CGFloat statsTwo;
                if ([Cell objectForKey:@"stats1"]) {
                     statsOne = [[Cell objectForKey:@"stats1"]intValue];
                }else{
                    statsOne=.1;
                }
                if ([Cell objectForKey:@"stats2"]) {
                    statsTwo = [[Cell objectForKey:@"stats2"]intValue];
                }else{
                    statsTwo=.1;
                }
                
                //                CGFloat statsOne = 7.0;
//                CGFloat statsTwo = 5.0;
                CGFloat total = statsOne + statsTwo;
                //Cgfloats are stupid
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [stats1 setFrame:CGRectMake(stats1.frame.origin.x, stats1.frame.origin.y, 140*(statsOne/total)+5, stats1.frame.size.height)];
                    [stats2 setFrame:CGRectMake(stats2.frame.origin.x, stats2.frame.origin.y, 140*(statsTwo/total)+5, stats2.frame.size.height)];
                });
            });
            
        }
        
    }
    else if ([[Cell objectForKey:@"tier"] isEqualToString:@"1000"]){
        
        static NSString *simpleTableIdentifier = @"memberAdded";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        UILabel *memberAdded = (UILabel *)[cell viewWithTag:1000];
        memberAdded.text = [Cell objectForKey:@"message"];
    }
       }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@" connected! That was easy.");
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (tag == 1)
        NSLog(@"First request sent");
    else if (tag == 2)
        NSLog(@"Second request sent");
}

- (void)socket:(GCDAsyncSocket *)sender didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == HTTP_HEADER)
    {
        // Ignore welcome message
        NSLog(@"Message seen1");

        
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"header::%@",newStr);
        
        [socket readDataWithTimeout:-1 buffer:0 bufferOffset:0 maxLength:1000 tag:HTTP_BODY];
        
        
        
        
    }
    else if (tag == 2)
    {;
        NSLog(@"Message seen2");
        
    }
    else if (tag == HTTP_BODY)
    {
            NSDictionary *result = [self parseJSON:data];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.2];
            self.messageSentProgressView.progress=1;
            self.messageSentProgressView.alpha=0;
            [UIView commitAnimations];

        
        
        
        NSString * type = [result objectForKey:@"type"];
        
        if([type isEqualToString:@"Connection"]){
            instanceKey = [[result objectForKey:@"instanceKey"] integerValue];
            NSLog(@"connectionRecognized");
            NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
            [output setObject:@"con" forKey:@"type"];
            [output setObject:[NSString stringWithFormat:@"%ld",(long)instanceKey] forKey:@"instanceKey"];
            [output setObject:[NSString stringWithFormat:@"%d", self.groupID] forKey:@"groupID"];
            [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];
            
        
        }
        
        
        

        else if([type isEqualToString:@"node"]){
            [self runNodeParse];
            //replace these reload datas
            [self.tableView reloadData];
            if ([CellClassList count]>3) {
                
                //[self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height) animated:YES]; //self.tableView.contentSize.height-self.view.frame.size.height+280) animated:YES];
                [self performSelector:@selector(goToBottom) withObject:nil afterDelay:1.0];
                }
        }
        else if ([type isEqualToString:@"poll"]){
            [self runPollParse];
            [self.tableView reloadData];
            //if ([CellClassList count]>3) {
             //   [self.tableView setContentOffset:CGPointMake(0,  self.tableView.contentSize.height-self.view.frame.size.height+150) animated:YES];
            //}
            
        }else if([type isEqualToString:@"comment"]){
            [self runCommentParse];
            [self.tableView reloadData];

        }
        
        
        
        

        // NSData *term = [@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding];
        //[socket readDataToData:term withTimeout:-1 tag:HTTP_HEADER];
        //[socket readDataWithTimeout:-1 tag:HTTP_HEADER];
        [socket readDataWithTimeout:-1 buffer:0 bufferOffset:0 maxLength:1000 tag:HTTP_BODY];
    }
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error{
    
    NSError *err = nil;
    if (![socket connectToHost:@"104.131.53.146" onPort:8080 error:&err]) // Asynchronous!
    {
        NSLog(@"I goofed: %@", err);
    }
    
    
    [socket readDataWithTimeout:-1 buffer:0 bufferOffset:0 maxLength:1000 tag:HTTP_BODY];
    
}




#pragma mark - JSON Handling
-(NSDictionary *)parseJSON:(NSData *)data{
    NSDictionary *results;
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
        if(error) { /* JSON was malformed, act appropriately here */ }
       // NSLog(@"bad json");
        if([object isKindOfClass:[NSDictionary class]])
        {
            results = object;
            NSLog(@"dict recognized");
        }
        else
        {
        }
    }
    return results;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSData *)JsonCreator:(id)dictionaryOrArrayToOutput{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryOrArrayToOutput
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got JSON an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return   [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return [@"invalidJson" dataUsingEncoding:NSUTF8StringEncoding];
}


#pragma Mark - Parsing



-(void)runNodeParse{
    //runs the parse
   if (!isParseRunning) {
            isParseRunning=true;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%d",highestID,self.groupID]];
        parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
       
       dispatch_sync(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
           if (highestUnitForScroll<highestUnit) {
               highestUnitForScroll=highestUnit;
               
           }
               isParseRunning=false;
       });
    });
   }
   else{
       [parseQueue addObject:@"node"];
   }
}
-(void)runCommentParse{
    if (!isParseRunning) {
    isParseRunning=true;
        NSLog(@"Comment parsing....");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateComments.php?unit=%d&topic=%d",lowestUnit,self.groupID]];
        // update updateComments to pull all values greater than that of the lowerst unit
        
        parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
               isParseRunning=false;

        });
        
    });
    
        
    }
    else{
        [parseQueue addObject:@"comment"];
    }
}
-(void)runPollParse{
    if (!isParseRunning) {
        isParseRunning=true;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(queue, ^{
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updatePoll.php?unit=%d&topic=%d&email=%@",lowestUnit,self.groupID,email]];
            NSLog(@"Poll Parsing....");
            parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
                isParseRunning=false;
                if (highestUnitForScroll<highestUnit) {
                    highestUnitForScroll=highestUnit;

                }
                
            });
            
        });
        
        
    }
    else{
        [parseQueue addObject:@"poll"];
    }
    
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        item    = [[NSMutableDictionary alloc] init];
        identifier = [[NSMutableString alloc]init];
        userUpdate  = [[NSMutableString alloc] init];
        messageUpdate  = [[NSMutableString alloc] init];
        //xPosition = [[NSMutableString alloc]init];
        //yPosition = [[NSMutableString alloc]init];
        //predxPosition = [[NSMutableString alloc]init];
        //predyPosition = [[NSMutableString alloc]init];
        unitUpdate = [[NSMutableString alloc]init];
        //Likes = [[NSMutableString alloc]init];
        CommentsUpdate = [[NSMutableString alloc]init];
        tier = [[NSMutableString alloc]init];
        emailUpdate = [[NSMutableString alloc]init];
        colorUpdate = [[NSMutableString alloc]init];
        pathStyle = [[NSMutableString alloc]init];
        pathColor = [[NSMutableString alloc]init];
        contentHeightUpdate = [[NSMutableString alloc]init];
        phoneNumberUpdate=[[NSMutableString alloc]init];
        option1Update = [[NSMutableString alloc]init];
        option2Update = [[NSMutableString alloc]init];
        pollIdUpdate = [[NSMutableString alloc]init];
        timeUpdate = [[NSMutableString alloc]init];
    }
    else if ([element isEqualToString:@"Polls"]){
        item    = [[NSMutableDictionary alloc] init];
        stats1Update = [[NSMutableString alloc]init];
        stats2Update = [[NSMutableString alloc]init];
        pollIdUpdate = [[NSMutableString alloc]init];
        unitUpdate = [[NSMutableString alloc]init];
        votedUpdate = [[NSMutableString alloc]init];
        
    }
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Node&Comment
    if ([element isEqualToString:@"username"]) {
        [userUpdate appendString:string];
        // NSLog(@"username found tier 1");
    }else if ([element isEqualToString:@"email"]){
        [emailUpdate appendString:string];
    }
    else if ([element isEqualToString:@"id"]){
        [identifier appendString:string];
    }
    else if ([element isEqualToString:@"pathColor"]){
        [pathColor appendString:string];
    }
    else if ([element isEqualToString:@"pathStyle"]){
        [pathStyle appendString:string];
    }
    else if ([element isEqualToString:@"color"]){
        [colorUpdate appendString:string];
    }
    else if ([element isEqualToString:@"unit"]){
        [unitUpdate appendString:string];
    }
    else if ([element isEqualToString:@"Comments"]){
        [CommentsUpdate appendString:string];}
    else if ([element isEqualToString:@"tier"]){
        [tier appendString:string];}
    else if ([element isEqualToString:@"message"]){
        [messageUpdate appendString:string];}
    else if ([element isEqualToString:@"contentHeight"]){
        [contentHeightUpdate appendString:string];
   }
    else if ([element isEqualToString:@"phoneNumber"]){
        [phoneNumberUpdate appendString:string];
    }
    else if ([element isEqualToString:@"option1"]){
        [option1Update appendString:string];
        
    }
    else if ([element isEqualToString:@"option2"]){
        [option2Update appendString:string];
    }
    //Poll
    else if ([element isEqualToString:@"stats1"]){
        [stats1Update appendString:string];
    }
    else if ([element isEqualToString:@"stats2"]){
        [stats2Update appendString:string];
    }
    else if ([element isEqualToString:@"PollId"]){
        [pollIdUpdate appendString:string];
    }
    else if ([element isEqualToString:@"userVoted"]){
        [votedUpdate appendString:string];
    }
    else if ([element isEqualToString:@"time"]){
        [timeUpdate appendFormat:string];
        
    }
    
    
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
//    NSData *data = [messageUpdate dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//        messageUpdate = [[NSMutableString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    if ([tier isEqualToString:@"1"]||[tier isEqualToString:@"2"] ) {
        
        
        if (messageUpdate) {
           // NSLog(@"Message Pre::%@",messageUpdate);

        NSData *data = [messageUpdate dataUsingEncoding:NSUTF8StringEncoding];
            @try {
                messageUpdate = [[NSMutableString alloc] initWithString: [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding]];
            }
            @catch (NSException *exception) {
                //[NSException raise:@"Invalid messageUpdate Value" format:@"The value %@ cannot be processed", messageUpdate];
            }
            @finally {
               // NSLog(@"Message Post::%@",messageUpdate);

            }
            

            
            
        }
        

    
        
    }

    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        [item setObject:identifier forKey:@"id"];
        [item setObject:userUpdate forKey:@"username"];   
        [item setObject:messageUpdate forKey:@"message"];
        [item setObject:unitUpdate forKey:@"unit"];
        if ([colorUpdate isEqualToString:@"(null)"]) {
            colorUpdate = [NSMutableString stringWithFormat:@"B09FE5"];
        }
        [item setObject:CommentsUpdate forKey:@"Comments"];
        [item setObject:colorUpdate forKey:@"color"];
        [item setObject:tier forKey:@"tier"];
        [item setObject:pathColor forKey:@"pathColor"];
        [item setObject:pathStyle forKey:@"pathStyle"];
        [item setObject:contentHeightUpdate forKey:@"contentHeight"];
        [item setObject:phoneNumberUpdate forKey:@"phoneNumber"];
        [item setObject:option1Update forKey:@"option1"];
        [item setObject:option2Update forKey:@"option2"];
        [item setObject:pollIdUpdate forKey:@"pollID"];// not updating correctly
        [item setObject:emailUpdate forKey:@"email"];

        if([tier isEqualToString:@"1"]){
            
            [self User:emailUpdate inputMessage:messageUpdate emojiInput:@"😴" emojiString:@"sleepy" itemInput:item];
            [self User:emailUpdate inputMessage:messageUpdate emojiInput:@"😇" emojiString:@"angel" itemInput:item];
            [self User:emailUpdate inputMessage:messageUpdate emojiInput:@"😀" emojiString:@"happy" itemInput:item];

            
            NSUInteger i =5;
        
            timeUpdate =[NSMutableString stringWithFormat:@"%@", [timeUpdate substringToIndex:i]];
        
            [item setObject:timeUpdate forKey:@"time"];
            
            /*
            if ([messageUpdate rangeOfString:@"😴"].location == NSNotFound) {
            } else {
                [item setObject:@"sleepy" forKey:@"emojiFlag"];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://104.131.53.146/users/%@/emojis/%@/emojiPicture.jpg",@"sleepy",emailUpdate]]];
                    NSString *key = [emailUpdate stringByAppendingString:@"sleepy"];
                    [groupMemberData setObject:imageData forKey:key];
                    
                });
                
                
                
            }if ([messageUpdate rangeOfString:@"😇"].location == NSNotFound) {
            } else {
                [item setObject:@"angel" forKey:@"emojiFlag"];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://104.131.53.146/users/%@/emojis/%@/emojiPicture.jpg",@"angel",emailUpdate]]];
                    NSString *key = [emailUpdate stringByAppendingString:@"angel"];
                    [groupMemberData setObject:imageData forKey:key];
                    
                });
                
                
                
            }if ([messageUpdate rangeOfString:@"😀"].location == NSNotFound) {
            } else {
                [item setObject:@"happy" forKey:@"emojiFlag"];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://104.131.53.146/users/%@/emojis/%@/emojiPicture.jpg",@"happy",emailUpdate]]];
                    NSString *key = [emailUpdate stringByAppendingString:@"happy"];
                    [groupMemberData setObject:imageData forKey:key];
                    
                });
                
                

            }
             
             */
//
//            
            
            
            
            if ([identifier intValue]>highestID) {
            highestID=[identifier intValue];
            }
            if ([tier intValue]==1) {
                [NodeList addObject:item];
            
            }
            if([unitUpdate intValue]<lowestUnit){
                lowestUnit = [unitUpdate intValue];
            }
            [CellClassList addObject:item];
            [CellList setObject:item forKey:unitUpdate];
        }
        
        else if ([tier isEqualToString:@"2"] ){
            
            for (NSMutableDictionary *node in CellClassList) {
                
                if([[node objectForKey:@"unit"]isEqualToString:unitUpdate]){

                    if([CommentsUpdate isEqualToString:@"1"]){
                        
                        
                       // NSLog(@"comment1 set");
                        [node setObject:item forKey:@"comment1"];
                    }
                    else if ([CommentsUpdate isEqualToString:@"2"]){
                        [node setObject:item forKey:@"comment2"];
                    }
                    else if ([CommentsUpdate isEqualToString:@"3"]){
                        [node setObject:item forKey:@"comment3"];
                    }
                
                }
                
                
                
            }
            
        }
        
        
        
        
        else if ([tier isEqualToString:@"3"]){
            NSLog(@"Tier 3 parsed");
            [item setObject:@"0" forKey:@"selected"];
//            [item setObject:@"1" forKey:@"stats1"];
//            [item setObject:@"1" forKey:@"stats2"];
            [CellClassList addObject:item];
            [CellList setObject:item forKey:unitUpdate];
            if ([identifier intValue]>highestID) {
                highestID=[identifier intValue];
            }
            if ([tier intValue]==3) {
                [PollList addObject:item];
                
            }
            if([unitUpdate intValue]<lowestUnit){
                lowestUnit = [unitUpdate intValue];
            }

            
        }else if([tier isEqualToString:@"1000"]){
            BOOL checkFlag = true;
            for (NSMutableDictionary *dict in CellClassList) {
                if([unitUpdate isEqualToString:dict[@"unit"]]){
                    checkFlag=false;
                    break;
                }
                
            }
            if (checkFlag) {
                [CellClassList addObject:item];

            }
        }
        else{
            NSLog(@"Unrecognized Tier");
        }
    }

    else if ([elementName isEqualToString:@"Polls"]){
//        NSLog(@"Polls Parsed read");
        
        for (NSMutableDictionary *Poll in CellClassList) {
            if ([Poll[@"unit"] isEqualToString:unitUpdate]) {
                [Poll setObject:votedUpdate forKey:@"selected"];
                [Poll setObject:stats1Update forKey:@"stats1"];
                [Poll setObject:stats2Update forKey:@"stats2"];
                [Poll setObject:pollIdUpdate forKey:@"pollID"];
                
                
               // NSLog(@"Poll Updated");
                
            }
        }
        
        
        
        
        
    }
}




- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isParseRunning=false;
    
    if ([parseQueue count]>0) {
        
        NSString *currentCall = [parseQueue objectAtIndex:0];

    if (currentCall!=nil) {
        
    
        if ([currentCall isEqualToString:@"node"]) {
            [self runNodeParse];
        }
        else if ([currentCall isEqualToString:@"comment"]){
            [self runCommentParse];
        }
        else if ([currentCall isEqualToString:@"poll"]){
            [self runPollParse];
        }
        else{
            NSLog(@"Unrecognized Call");
        }
        [parseQueue removeObjectAtIndex:0];
        [self sort];
    
        }
    }
  
}




#pragma mark - text delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[self processReturn];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textedField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *newString = [textedField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = newString;//edits it live
    
    if([self isCorrectTypeOfString:string]){
        return YES;
        
    }
    return YES;
}

#pragma mark -
#pragma mark Helpers
-(void)processReturn{
    
    
    
    
}

-(BOOL)isCorrectTypeOfString:(NSString *)stringPlacement{
    
    
    NSCharacterSet* notletters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if ([stringPlacement rangeOfCharacterFromSet:notletters].location == NSNotFound){
        return YES;
    }
    
    return NO;
}


- (void)textViewDidChange:(UITextView *)textView{
    //NSLog(@"%@",textField.text);
//    
//    if (tierCreation==1) {
//        if (textField.contentSize.height > textField.font.lineHeight*3 & textField.contentSize.height<textField.frame.size.height) {
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationDuration:1.0 ];
//            textField.layer.cornerRadius = labelWidth/3;
//            [UIView commitAnimations];
//        }
//    }
//    if (textField.contentSize.height>textField.frame.size.height) {
//        //CGFloat Addition;
//        
//        [textField setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y-(textField.contentSize.height-textField.frame.size.height), textField.frame.size.width, textField.contentSize.height)];
//        adjustedContentSize = textField.frame.size.height;
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:1.0 ];
//        textField.layer.cornerRadius = 10;
//        [UIView commitAnimations];
//    }
    

}







#pragma mark- buttons



-(void)addToParsequeue:(NSString*)call{
    if(isParseRunning){
        [parseQueue addObject:call];
    }
    else{
        if([call isEqualToString:@"node"]){
            [self runNodeParse];
        }
        else if ([call isEqualToString:@"comment"]){
            [self runCommentParse];
        }
        else if ([call isEqualToString:@"poll"]){
            [self runPollParse];
        }
        else{
            NSLog(@"unrecognied");
        }
    }
    
}




#pragma mark - buttons
- (IBAction)StartTheMessage:(id)sender {
    tierCreation=1;
    if ([textField becomeFirstResponder]) {
        //NSLog(@"accepted textfield recieved view");
    }else{
       // NSLog(@"rejected");
    }
    
    [textField setFrame:CGRectMake(SCREEN_WIDTH/2-LABEL_WIDTH, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH)];
    
    
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.tableView.alpha=.4;
    textField.backgroundColor = [self colorWithHexString:@"26B0FF"];
    [textField setFrame:CGRectMake(SCREEN_WIDTH/2-LABEL_WIDTH/2, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH)];
    textField.userInteractionEnabled=YES;
    textField.alpha=1;
    self.pollNodeProperties.alpha=.8;
    self.pollNodeProperties.userInteractionEnabled=YES;
    [self.view bringSubviewToFront:self.pollNodeProperties];
    self.regularNodeProperties.alpha=.8;
    self.regularNodeProperties.userInteractionEnabled=YES;
    [self.view bringSubviewToFront:self.regularNodeProperties];
    self.sendTheMessageProperties.alpha=1;
    self.sendTheMessageProperties.userInteractionEnabled=YES;
    [self.view bringSubviewToFront:self.sendTheMessageProperties];
    [UIView commitAnimations];
    
    
    
    
}



- (IBAction)regularNode:(id)sender {
    if (tierCreation!=1) {
        tierCreation=1;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        
        
        
        option1Entry.alpha=option2Entry.alpha=0;
        option1Entry.userInteractionEnabled=option2Entry.userInteractionEnabled=NO;
        textField.layer.cornerRadius=LABEL_WIDTH/2;
        [textField setFrame:CGRectMake(SCREEN_WIDTH/2-LABEL_WIDTH/2, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH)];
        textField.backgroundColor = [self colorWithHexString:@"26B0FF"];
        [UIView commitAnimations];
        
        
        
        
    }
    
    
    
}

- (IBAction)pollNode:(id)sender {
    if (tierCreation!=3) {
        tierCreation=3;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [textField setFrame:CGRectMake(0,SCREEN_HEIGHT/8+OPTION_WIDTH/2 , SCREEN_WIDTH, 45)];
        [option1Entry setFrame:CGRectMake(SCREEN_WIDTH/4-10, SCREEN_HEIGHT/2-OPTION_WIDTH*1.5, OPTION_WIDTH, OPTION_WIDTH)];
        [option2Entry setFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-OPTION_WIDTH*1.5, OPTION_WIDTH, OPTION_WIDTH)];
        option1Entry.alpha=option2Entry.alpha=1;
        option1Entry.userInteractionEnabled=option2Entry.userInteractionEnabled=YES;
        textField.layer.cornerRadius=0;
        textField.backgroundColor = [self colorWithHexString:@"64F192"];
        [UIView commitAnimations];
    }
}

- (IBAction)sendTheMessage:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
    self.messageSentProgressView.alpha=1;
    self.messageSentProgressView.progress=.6;
    email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    [UIView commitAnimations];
    if (tierCreation==1) {
        
        
        //Database
        NSString * newText = [NSString stringWithString:textField.text];

        
        
        NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
        pathColor = [defaults objectForKey:@"pathColor"];
        pathStyle = [defaults objectForKey:@"pathStyle"];
        
        //FINISH BY ADJUSTING THE PATH ATTTRIBUTES
        
        //NSString *contentString = [NSString stringWithFormat:@"%f",newText];
        
        NSData *data = [newText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        newText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        
        
        NSString *Comments=@"0";
        NSString *post = [NSString stringWithFormat:@"&email=%@&message=%@&topic=%d&unit=%@&numberOfComments=%@&tier=%d&color=%@&pathColor=%@&pathStyle=%@",email,newText,self.groupID,unitUpdate,Comments,tierCreation,bubbleColor,pathColor,pathStyle];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/addToServer.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }

        
        [UIView beginAnimations:nil  context:nil];
        [UIView setAnimationDuration:.3];
        [textField setFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH)];
        textField.alpha=0;
        [UIView commitAnimations];

        //Socket
        
        
        NSString *instance = [[NSString alloc]initWithFormat:@"%ld",(long)instanceKey ];
        NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
        [output setObject:@"node" forKey:@"type"];
        [output setObject:[NSString stringWithFormat:@"%d",self.groupID] forKey:@"groupID"];
        [output setObject:instance forKey:@"instanceKey"];
        [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];
    }
    else if (tierCreation==2){
        NSString * newText = [NSString stringWithString:textField.text];

        NSData *data = [newText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        newText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
        pathColor = [defaults objectForKey:@"pathColor"];
        pathStyle = [defaults objectForKey:@"pathStyle"];
        
        //FINISH BY ADJUSTING THE PATH ATTTRIBUTES
        
        //NSString *contentString = [NSString stringWithFormat:@"%f",newText];
        
        NSString *Comments=@"0";
        NSLog(@"%d",unitComment);
        NSString *post = [NSString stringWithFormat:@"&email=%@&message=%@&topic=%d&unit=%d&numberOfComments=%@&tier=%d&color=%@&pathColor=%@&pathStyle=%@&option1=%@&option2=%@",email,newText,self.groupID,unitComment,Comments,tierCreation,bubbleColor,pathColor,pathStyle,option1Entry.text,option2Entry.text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/addToServer.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        [textField setFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH/2)];
        textField.alpha=0;
        [UIView commitAnimations];
        
        
        
        NSString *instance = [[NSString alloc]initWithFormat:@"%ld",(long)instanceKey ];
        NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
        [output setObject:@"comment" forKey:@"type"];
        [output setObject:[NSString stringWithFormat:@"%d",self.groupID] forKey:@"groupID"];
        [output setObject:instance forKey:@"instanceKey"];
        [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];

    }
    else if (tierCreation==3){
        NSString * newText = [NSString stringWithString:textField.text];

        
        NSData *data = [newText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
        newText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
        pathColor = [defaults objectForKey:@"pathColor"];
        pathStyle = [defaults objectForKey:@"pathStyle"];
        
        //FINISH BY ADJUSTING THE PATH ATTTRIBUTES
        
        //NSString *contentString = [NSString stringWithFormat:@"%f",newText];
        
        NSString *Comments=@"0";
        NSString *post = [NSString stringWithFormat:@"&email=%@&message=%@&topic=%d&unit=%@&numberOfComments=%@&tier=%d&color=%@&pathColor=%@&pathStyle=%@&option1=%@&option2=%@",email,newText,self.groupID,unitUpdate,Comments,tierCreation,bubbleColor,pathColor,pathStyle,option1Entry.text,option2Entry.text];
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/addToServer.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(conn) {
            NSLog(@"Connection Successful");
        } else {
            NSLog(@"Connection could not be made");
        }

    
        NSString *instance = [[NSString alloc]initWithFormat:@"%ld",(long)instanceKey ];
        NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
        [output setObject:@"node" forKey:@"type"];
        [output setObject:[NSString stringWithFormat:@"%d",self.groupID] forKey:@"groupID"];
        [output setObject:instance forKey:@"instanceKey"];
        [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];

    }
    

    [option1Entry resignFirstResponder];
    [option2Entry resignFirstResponder];
    [textField resignFirstResponder];
    textField.text=@" ";
    option2Entry.text=@" ";
    option1Entry.text=@" ";
}

- (IBAction)commentSegueButton:(YYCommentButton*)sender {
    
    commentUnit=sender.unit;
    mainPost = sender.mainPost;
    NSLog(@"comment Button Recognized");
    [self shouldPerformSegueWithIdentifier:@"commentPage" sender:self];
    
    
    
}

- (IBAction)VotingBallot1:(VotingBallot *)sender {
    //create your vote
    
    
 
    
    NSString *post = [NSString stringWithFormat:@"&pollID=%d&unit=%@&topicID=%d&email=%@&vote=1",sender.pollID,sender.unit,self.groupID,email];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/VotingBooth.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    
    NSString *instance = [[NSString alloc]initWithFormat:@"%ld",(long)instanceKey ];
    NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
    [output setObject:@"poll" forKey:@"type"];
    [output setObject:[NSString stringWithFormat:@"%d",self.groupID] forKey:@"groupID"];
    [output setObject:instance forKey:@"instanceKey"];
    [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];


    
    
}

- (IBAction)VotingBallot2:(VotingBallot *)sender {
    //create your vote
    
    NSString *post = [NSString stringWithFormat:@"&pollID=%d&unit=%@&topicID=%d&email=%@&vote=2",sender.pollID,sender.unit,self.groupID,email];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/VotingBooth.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    
    NSString *instance = [[NSString alloc]initWithFormat:@"%ld",(long)instanceKey ];
    NSMutableDictionary *output = [[NSMutableDictionary alloc]init];
    [output setObject:@"poll" forKey:@"type"];
    [output setObject:[NSString stringWithFormat:@"%d",self.groupID] forKey:@"groupID"];
    [output setObject:instance forKey:@"instanceKey"];
    [socket writeData:[self JsonCreator:output] withTimeout:-1 tag:2];


}








- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    int tierT;
    NSMutableDictionary *cell = [CellClassList objectAtIndex:indexPath.row];
    tierT=[[cell objectForKey:@"tier"]intValue];
    if (tierT ==1) {
        height=STANDARD_CELL_HEIGHT;
    }
    else if (tierT==3){
        height=150;
    }
    else if (tierT==1000) {
        height=35;
    }
    else{
        height=150;
    }
   
    
    return height;
}
-(void)sortCellClassList{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(queue, ^{
        NSSortDescriptor *sortDescriptor;
    //sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"unit"
     //                                            ascending:YES];
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                     ascending:YES selector:@selector(localizedStandardCompare:)] ;
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [CellClassList sortedArrayUsingDescriptors:sortDescriptors];
    CellClassList = [NSMutableArray arrayWithArray:sortedArray];  

        
    });
 
    [self.tableView reloadData];


    
}
-(void)sort
{
    //This is the array of dictionaries, where each dictionary holds a record
    NSMutableArray * array=CellClassList ;
    //allocate the memory to the mutable array and add the records to the arrat
    
    // I have used simple bubble sort you can use any other algorithm that suites you
    //bubble sort
    //
    for(int i = 0; i < [array count]; i++)
    {
        for(int j = i+1; j < [array count]; j++)
        {
            NSDictionary *recordOne = [array objectAtIndex:i];
            NSDictionary *recordTwo = [array objectAtIndex:j];
            
            if([[recordOne valueForKey:@"unit"] floatValue] > [[recordTwo valueForKey:@"unit"] floatValue])
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }

    [self.tableView reloadData];

    //Here you get the sorted array
}







-(UIColor *)colorWithHexString:(NSString *)hexString{
    unsigned int hex;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (void)setUpObserver
{
    // This could be in an init method.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardArrived:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardLeft:) name:UIKeyboardDidHideNotification object:nil];
}
- (void)keyboardArrived:(NSNotification*)notification{
    if (self.tableView.alpha!=.4) {
        
    
//                 UIVisualEffect *blurEffect;
//            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//            
//            visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//            visualEffectView.alpha=0;
//            visualEffectView.frame = self.tableView.bounds;
    //        [self.tableView addSubview:visualEffectView];
           
        
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    self.tableView.alpha=.4;
   //     visualEffectView.alpha=1;
        

        
    [UIView commitAnimations];
        
        if(tierCreation==2) {
            
            
            
            

            
            
            [textField setFrame:CGRectMake(SCREEN_WIDTH/2-LABEL_WIDTH, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH/2)];
            textField.font = [UIFont fontWithName:@"Times" size:14];
            
            textField.backgroundColor = [UIColor clearColor];//[self colorWithHexString:@"E3E3E3"];
            NSLog(@"tiercreation=2");
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.3];
            [textField setFrame:CGRectMake(SCREEN_WIDTH/2-LABEL_WIDTH/2, SCREEN_HEIGHT/2-LABEL_WIDTH, LABEL_WIDTH, LABEL_WIDTH/2)];
            textField.layer.cornerRadius=20;
            textField.alpha=1;

            self.sendTheMessageProperties.alpha=1;
            self.sendTheMessageProperties.userInteractionEnabled=YES;
            [UIView commitAnimations];
            
            
            
            
        }
    }
}
-(void)keyboardLeft:(NSNotification *)notification{
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3];
    self.pollNodeProperties.alpha=self.regularNodeProperties.alpha=self.sendTheMessageProperties.alpha=0;
    self.pollNodeProperties.userInteractionEnabled=self.regularNodeProperties.userInteractionEnabled=self.sendTheMessageProperties.userInteractionEnabled=NO;
    textField.alpha=0;
    textField.userInteractionEnabled=NO;
    textField.layer.cornerRadius=LABEL_WIDTH/2;
    self.tableView.alpha=1;
    option1Entry.alpha=option2Entry.alpha=0;
    option1Entry.userInteractionEnabled=option2Entry.userInteractionEnabled=NO;
   // visualEffectView.alpha=0;
    [UIView commitAnimations];
   // [visualEffectView removeFromSuperview];

    
}



-(void)User:(NSString*)user
     inputMessage:(NSString*)messageText
       emojiInput:(NSString*)emoji
      emojiString:(NSString*)emojiString
        itemInput:(NSMutableDictionary *)CellDict
{
    
    if ([messageText rangeOfString:emoji].location == NSNotFound) {
        
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://104.131.53.146/users/%@/emojis/%@/emojiPicture.jpg",user,emojiString]]];
            NSString *key = [emailUpdate stringByAppendingString:emojiString];
            if (imageData) {
                [groupMemberData setObject:imageData forKey:key];
                [CellDict setObject:emojiString forKey:@"emojiFlag"];

            }
            
        });
    }
}

    
    

//}

-(void)groupMemberData{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        for (NSMutableDictionary * cell in [CellClassList copy]) {
            NSString *photoEmail;
            photoEmail=[cell objectForKey:@"email"];
            __block NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://104.131.53.146/users/%@/profilePic.jpg",photoEmail]]];
            
            [groupMemberData setObject:imageData forKey:photoEmail];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
            groupMemberDataFlag=true;
        NSLog(@"GroupMemberDataComplete");
        
    });
    
}


-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.tableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.tableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}



-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    
        UITextView *txtview = object;
        CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
        topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
        
            txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
    

    
    
}


-(void)customizeNaviBar{
    groupPhoto =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YYLogo40x40.png"]];
    groupPhoto.backgroundColor = [UIColor clearColor];
    groupPhoto.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem.image = groupPhoto.image;
    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"stockProfImage.png"];
//    UITapGestureRecognizer *logoTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(spinTheLogo)];
//    [logo addGestureRecognizer:logoTapped];
    
    
    
}


@end
