//
//  BubbleChatScene.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BubbleChatScene.h"


typedef NS_ENUM(NSInteger, BubbleSceneZPosition)
{
    BubbleSceneZPositionScrolling = 0,
    BubbleSceneZPositionVerticalAndHorizontalScrolling,
    BubbleSceneZPositionStatic,
};
@interface BubbleChatScene  ()

//BubbleSceneZPositionScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToScroll;
//@property (nonatomic, weak) SKSpriteNode *spriteForScrollingGeometry;

//BubbleSceneZPositionStatic
@property (nonatomic, weak) SKSpriteNode *spriteForStaticGeometry;

//BubbleSceneZPositionVerticalAndHorizontalScrolling
@property (nonatomic, weak) SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForHorizontalScrolling;
@property (nonatomic, weak) SKSpriteNode *spriteForVerticalScrolling;
@end


@implementation BubbleChatScene{
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *NodeList;
    NSMutableArray *tempList;
    NSMutableString *userUpdate;
    NSMutableString *messageUpdate;
    NSMutableString *identifier;
    NSString *element;
    SKShapeNode *myWorld;
    CGPoint previousTouchLoc;
    NSMutableString *xPosition;
    NSMutableString *yPosition;
    NSMutableString *predxPosition;
    NSMutableString *predyPosition;
   // NSMutableString *username;
    
    CFTimeInterval lastUpdateTimeInterval;
    double timeSinceLastTick;
    
    int highestID;
    int labelWidth;
    int labelHeight;
    int counter;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //NSUserDefaults >> life
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *topic = [defaults objectForKey:@"currentTopic"];
        NSString *username = [defaults objectForKey:@"username"];
        _userName = username;
        _topic = topic;

        
        
        //_topic = self.topic;
        NodeList = [[NSMutableArray alloc]init];
        counter = 0;
        timeSinceLastTick = 0;
        labelHeight = 100;
        labelWidth = 100;
        self.backgroundColor = [UIColor whiteColor];
        //_labeledNode = [[UILabel alloc]init];
        
        [self setUpTextBox];
        //username = [NSMutableString stringWithFormat:@"%@",@"Dan"];
        predxPosition = predyPosition = 0;
        
        _labelList = [[NSMutableArray alloc]init];
        NodeList = [[NSMutableArray alloc]init];
        
        
        [self setAnchorPoint:(CGPoint){0,1}];
        SKSpriteNode *spriteToScroll = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToScroll setAnchorPoint:(CGPoint){0,1}];
        [spriteToScroll setZPosition:BubbleSceneZPositionScrolling];
        [self addChild:spriteToScroll];
        
        //Overlay sprite to make anchor point 0,0 (lower left, default for SK)
        SKSpriteNode *spriteForScrollingGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForScrollingGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForScrollingGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteToScroll addChild:spriteForScrollingGeometry];
        _spriteForScrollingGeometry = spriteForScrollingGeometry;
        
        //NSLog(@"Current Position :%f",_spriteForScrollingGeometry.position.y);
        
        SKSpriteNode *spriteForStaticGeometry = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteForStaticGeometry setAnchorPoint:(CGPoint){0,0}];
        [spriteForStaticGeometry setPosition:(CGPoint){0, -size.height}];
        [spriteForStaticGeometry setZPosition:BubbleSceneZPositionStatic];
        [self addChild:spriteForStaticGeometry];
        
        SKSpriteNode *spriteToHostHorizontalAndVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [spriteToHostHorizontalAndVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteToHostHorizontalAndVerticalScrolling setPosition:(CGPoint){0, -size.height}];
        [spriteToHostHorizontalAndVerticalScrolling setZPosition:BubbleSceneZPositionVerticalAndHorizontalScrolling];
        [self addChild:spriteToHostHorizontalAndVerticalScrolling];
        
        CGSize upAndDownSize = size;
        upAndDownSize.width = 30;
        SKSpriteNode *spriteForVerticalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:upAndDownSize];
        [spriteForVerticalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteForVerticalScrolling setPosition:(CGPoint){0,30}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForVerticalScrolling];
        
        CGSize leftToRightSize = size;
        leftToRightSize.height = 30;
        SKSpriteNode *spriteForHorizontalScrolling = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:leftToRightSize];
        [spriteForHorizontalScrolling setAnchorPoint:(CGPoint){0,0}];
        [spriteForHorizontalScrolling setPosition:(CGPoint){10,0}];
        [spriteToHostHorizontalAndVerticalScrolling addChild:spriteForHorizontalScrolling];
        
        //Test sprites for constrained Scrolling
        //CGFloat labelPosition = -500.0;
        //CGFloat stepSize = 50.0;
        /* while (labelPosition < 2000.0)
         {
         NSString *labelText = [NSString stringWithFormat:@"%5.0f", labelPosition];
         
         SKLabelNode *scrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
         [scrollingLabel setText:labelText];
         [scrollingLabel setFontSize:14.0];
         [scrollingLabel setFontColor:[SKColor darkGrayColor]];
         [scrollingLabel setPosition:(CGPoint){.x = 0.0, .y = labelPosition}];
         [scrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
         [spriteForHorizontalScrolling addChild:scrollingLabel];
         
         scrollingLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
         [scrollingLabel setText:labelText];
         [scrollingLabel setFontSize:14.0];
         [scrollingLabel setFontColor:[SKColor darkGrayColor]];
         [scrollingLabel setPosition:(CGPoint){.x = labelPosition, .y = 0.0}];
         [scrollingLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
         [scrollingLabel setZPosition:kIIMySceneZPositionVerticalAndHorizontalScrolling];
         [spriteForVerticalScrolling addChild:scrollingLabel];
         labelPosition += stepSize;
         }
         
         //Test sprites for scrolling and zooming
         SKSpriteNode *greenTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor greenColor]
         size:(CGSize){.width = size.width,
         .height = size.height*.25}];
         [greenTestSprite setName:@"greenTestSprite"];
         [greenTestSprite setAnchorPoint:(CGPoint){0,0}];
         [spriteForScrollingGeometry addChild:greenTestSprite];
         
         SKSpriteNode *blueTestSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor]
         size:(CGSize){.width = size.width*.25,
         .height = size.height*.25}];
         [blueTestSprite setName:@"blueTestSprite"];
         [blueTestSprite setAnchorPoint:(CGPoint){0,0}];
         [blueTestSprite setPosition:(CGPoint){.x = size.width * .25, .y = size.height *.65}];
         [spriteForScrollingGeometry addChild:blueTestSprite];
         
         //Test sprites for stationary sprites
         SKLabelNode *stationaryLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue"];
         [stationaryLabel setText:@"I'm not gonna move, nope, nope."];
         [stationaryLabel setFontSize:14.0];
         [stationaryLabel setFontColor:[SKColor darkGrayColor]];
         [stationaryLabel setPosition:(CGPoint){.x = 60.0, .y = 60.0}];
         [stationaryLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
         [spriteForStaticGeometry addChild:stationaryLabel];*/
        
        //Set properties
        
        
        
        _contentSize = size;
        _spriteToScroll = spriteToScroll;
        _spriteForScrollingGeometry = spriteForScrollingGeometry;
        _spriteForStaticGeometry = spriteForStaticGeometry;
        _spriteToHostHorizontalAndVerticalScrolling = spriteToHostHorizontalAndVerticalScrolling;
        _spriteForVerticalScrolling = spriteForVerticalScrolling;
        _spriteForHorizontalScrolling = spriteForHorizontalScrolling;
        _contentOffset = (CGPoint){0,0};
        
        
        
        [self runXMLParse];
        [self updateNodesInScene];
        
    }
    
    
    
    return self;
}


#pragma mark MyAdditions


/*-(void)postTest{
 NSLog(@"position %@",xPosition);
 NSString *post = [NSString stringWithFormat:@"&user=%@&message=%@&xPosition=%@&yPosition=%@&predxPosition=%@&predyPosition=%@",username,textField.text,xPosition,yPosition,predxPosition,predyPosition];
 NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
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
 }*/


-(void)setUpTextBox{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, -self.size.height/2 +200, self.size.width, 50)];//Bad practice to shove it off the screen
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont systemFontOfSize:4.0];
    _textField.textColor = [UIColor blackColor];
    _textField.autocorrectionType = UITextAutocorrectionTypeYes;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_textField];
}


-(void)updateNodesInScene{
    // NSLog(@"updateNodesInScene Recognized");
    for (NSMutableDictionary *keyValue in NodeList) {
        //   NSLog(@"NodeListNotEmpty");
        //Node
        _end.x = [keyValue[@"xPosition"] intValue];
        _end.y = [keyValue[@"yPosition"] intValue];
        _start.x = [keyValue[@"predxPosition"] intValue];
        _start.y = [keyValue[@"predyPosition"] intValue];
        userUpdate = keyValue[@"user"];
        //Connections
        CGMutablePathRef path = CGPathCreateMutable();//Add Function to generate paths
        CGPathMoveToPoint(path, nil, _start.x, _start.y);
        CGPathAddLineToPoint(path, nil, _end.x, _end.y);
        SKShapeNode *pathVisual = [[SKShapeNode alloc]init];
        pathVisual.path = path;
        pathVisual.strokeColor = [UIColor blackColor];
        pathVisual.zPosition = 1;
        [_spriteForScrollingGeometry addChild:[self userNameLabelGenerator:_end forString:userUpdate]];
        [_spriteForScrollingGeometry addChild:[self nodeGenerator:_end]];// These methods onbly work for when it is stationary
        [_spriteForScrollingGeometry addChild:pathVisual];

    }
}

//Get Labels to pop up
-(SKLabelNode *)userNameLabelGenerator:(CGPoint)location
                             forString:(NSString *)currentUser{
    SKLabelNode *node = [[SKLabelNode alloc] init];
    node.text = currentUser;
    node.position = location;
    node.position = CGPointMake(location.x+50, location.y+40);
    node.zPosition = 8;
    node.fontSize = 8;
    node.fontColor= [UIColor grayColor];
    return node;
}
-(UILabel*)labelGenerator:(CGPoint)labelLocation{//Shift up and to the left, center the text and add the ability to add lines

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelLocation.x, labelLocation.y, labelWidth, labelHeight)];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Times" size:12.0];
    label.backgroundColor =[UIColor clearColor];
    label.text = @"Hello Daniel";
    return label;
}

-(SKSpriteNode *)nodeGenerator:(CGPoint)location{
   // UIImage *spriteImage =[UIImage imageWithContentsOfFile:@"blueBubble.png"];
    SKSpriteNode *node = [[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"blueBubble.png"]];
   // node.texture = [SKTexture textureWithImage:spriteImage];
    //node.xScale=.5;
    //node.yScale=.5;
    node.physicsBody = [[SKPhysicsBody alloc]init];
    node.physicsBody.affectedByGravity = NO;
    node.userInteractionEnabled = NO;
    node.position = location;
    node.name = @"node";
    node.zPosition = 2;
    return node;
}

#pragma mark -
#pragma mark- PHPconnection
-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    
    if ([element isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        item    = [[NSMutableDictionary alloc] init];
        identifier = [[NSMutableString alloc]init];
        userUpdate  = [[NSMutableString alloc] init];
        //messageUpdate  = [[NSMutableString alloc] init];
        xPosition = [[NSMutableString alloc]init];
        yPosition = [[NSMutableString alloc]init];
        predxPosition = [[NSMutableString alloc]init];
        predyPosition = [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    //NSLog(@"Step 1");
    if ([element isEqualToString:@"username"]) {
        [userUpdate appendString:string];
        //NSLog(@"Found User");
        //NSLog(@"title element found – create a new instance of Title class...");
    }
    else if ([element isEqualToString:@"id"]){
        [identifier appendString:string];
    }
    //else if ([element isEqualToString:@"message"]){
    //  [messageUpdate appendString:string];}
    //use to search chars
    else if ([element isEqualToString:@"xPosition"]){
        [ xPosition appendString:string];}
    else if ([element isEqualToString:@"yPosition"]){
        [ yPosition appendString:string];}
    else if ([element isEqualToString:@"predxPosition"]){
        [ predxPosition appendString:string];}
    else if ([element isEqualToString:@"predyPosition"]){
        [ predyPosition appendString:string];}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //NSLog(@"3");
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        [item setObject:identifier forKey:@"id"];
        [item setObject:userUpdate forKey:@"user"];
        // [item setObject:messageUpdate forKey:@"message"];
        [item setObject:xPosition forKey:@"xPosition"];
        [item setObject:yPosition forKey:@"yPosition"];
        [item setObject:predxPosition forKey:@"predxPosition"];
        [item setObject:predyPosition forKey:@"predyPosition"];
        [NodeList addObject:[item copy]];//The problem lies in add objects
        
    }}


-(void)update:(CFTimeInterval)currentTime{
    /* Called before each frame is rendered */
    
    
    
    /* Called before each frame is rendered */
    if (lastUpdateTimeInterval){
        double timeSinceLast = currentTime - lastUpdateTimeInterval;
        timeSinceLastTick += timeSinceLast;
    }
    lastUpdateTimeInterval = currentTime;
    
    if (timeSinceLastTick > 5) { // seconds per tick
        timeSinceLastTick = 0;
        
        [self updateHighestID];//I think this area works
        [self updatedQuery];
        
    }
    
    
    
}


-(void)updateHighestID{
    //counter = 0;
    for (NSMutableDictionary *keyValue in NodeList){
        if ([keyValue[@"id"] intValue] > counter) {
            
            counter = [keyValue[@"id"] intValue];
        }
    }
    
    highestID = counter;
   // NSLog(@"%d",highestID);
}



-(void)updatedQuery{
    
    [NodeList removeAllObjects];
    // im not fixing the position of the string correctly
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    [self updateNodesInScene];
    
}



































//BeenHere

-(void)didChangeSize:(CGSize)oldSize
{
    CGSize size = [self size];
    
    CGPoint lowerLeft = (CGPoint){0, -size.height};
    
    [self.spriteForStaticGeometry setSize:size];
    [self.spriteForStaticGeometry setPosition:lowerLeft];
    
    [self.spriteToHostHorizontalAndVerticalScrolling setSize:size];
    [self.spriteToHostHorizontalAndVerticalScrolling setPosition:lowerLeft];
}

-(void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(contentSize, _contentSize))
    {
        _contentSize = contentSize;
        [self.spriteToScroll setSize:contentSize];
        [self.spriteForScrollingGeometry setSize:contentSize];
        [self.spriteForScrollingGeometry setPosition:(CGPoint){0, -contentSize.height}];//This is where the switch happens
        [self updateConstrainedScrollerSize];
    }
}

-(void)setContentOffset:(CGPoint)contentOffset
{
    _contentOffset = contentOffset;
    contentOffset.x *= -1;
    [self.spriteToScroll setPosition:contentOffset];
    
    
    CGPoint scrollingLowerLeft = [self.spriteForScrollingGeometry convertPoint:(CGPoint){0,0} toNode:self.spriteToHostHorizontalAndVerticalScrolling];
    
    CGPoint horizontalScrollingPosition = [self.spriteForHorizontalScrolling position];
    horizontalScrollingPosition.y = scrollingLowerLeft.y;
    [self.spriteForHorizontalScrolling setPosition:horizontalScrollingPosition];
    
    CGPoint verticalScrollingPosition = [self.spriteForVerticalScrolling position];
    verticalScrollingPosition.x = scrollingLowerLeft.x;
    [self.spriteForVerticalScrolling setPosition:verticalScrollingPosition];
    // NSLog(@"Content Offset: %f",_contentOffset.y);
    
}

-(void)setContentScale:(CGFloat)scale;
{
    [self.spriteToScroll setScale:scale];
    [self updateConstrainedScrollerSize];
}

-(void)updateConstrainedScrollerSize
{
    
    CGSize contentSize = [self contentSize];
    CGSize verticalSpriteSize = [self.spriteForVerticalScrolling size];
    verticalSpriteSize.height = contentSize.height;
    [self.spriteForVerticalScrolling setSize:verticalSpriteSize];
    
    CGSize horizontalSpriteSize = [self.spriteForHorizontalScrolling size];
    horizontalSpriteSize.width = contentSize.width;
    [self.spriteForHorizontalScrolling setSize:horizontalSpriteSize];
    
    CGFloat xScale = [self.spriteToScroll xScale];
    CGFloat yScale = [self.spriteToScroll yScale];
    [self.spriteForVerticalScrolling setYScale:yScale];
    [self.spriteForVerticalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setXScale:xScale];
    [self.spriteForHorizontalScrolling setYScale:yScale];
    CGFloat xScaleReciprocal = 1.0/xScale;
    CGFloat yScaleReciprocal = 1/yScale;
    for (SKNode *node in [self.spriteForVerticalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }
    for (SKNode *node in [self.spriteForHorizontalScrolling children])
    {
        [node setXScale:xScaleReciprocal];
        [node setYScale:yScaleReciprocal];
    }
    
    [self setContentOffset:self.contentOffset];
}










@end
