//
//  MyScene.m
//  Node
//
//  Created by Daniel Habib on 8/26/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "MyScene.h"
#import "JSONDictionaryExtensions.h"
@interface MyScene ()

@end


@implementation MyScene{
    //Private Globals
    UITextField *textField;
    UILabel *uILabel;
    UILabel *updateLabel;
    CGPoint nodeLocation;
    SKSpriteNode *createdNode;
    CGPoint animStart;
    CGPoint animEnd;
    int labelWidth;
    int labelHeight;
    SKNode *camera;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *NodeList;
    NSMutableArray *labelList;
    NSMutableArray *tempList;
    NSMutableString *userUpdate;
    NSMutableString *messageUpdate;
    NSMutableString *xPosition;
    NSMutableString *yPosition;
    NSMutableString *predxPosition;
    NSMutableString *predyPosition;
    NSMutableString *identifier;
    NSString *element;
    SKShapeNode *myWorld;
    CGPoint previousTouchLoc;
    int cameraStartY;
    int cameraEndY;
    int highestID;
    int counter;
    
    
    
    CFTimeInterval lastUpdateTimeInterval;
    double timeSinceLastTick;
}

-(id)initWithSize:(CGSize)size{
    counter = 0;
    timeSinceLastTick = 0;
    labelHeight = 100;
    labelWidth = 100;
    
    if (self = [super initWithSize:size]){
        
        self.anchorPoint = CGPointMake (0.5,0.5);
        myWorld = [SKShapeNode node];
        [myWorld setPath:CGPathCreateWithRect(CGRectMake(-self.size.width/2, -1700, self.size.width, 2000),nil)];
        myWorld.fillColor = myWorld.strokeColor = [UIColor clearColor];
        myWorld.name = @"myWorld";
        
        [self addChild:myWorld];
        
        camera = [SKSpriteNode node];
        camera.position = CGPointMake(0, 0);
        
        camera.name=@"camera";
        [myWorld addChild:camera];
        cameraStartY = camera.position.y;
        cameraEndY = cameraStartY;
        //myWorld.size = CGSizeMake(self.size.width, 2000);
        
        
        
        
        /* Setup your scene here */
        self.name = @"background";
        self.backgroundColor = [SKColor whiteColor];
        //self.anchorPoint = CGPointMake(1, 1);
        //self.zPosition=2;
        labelList = [[NSMutableArray alloc]init];
        NodeList = [[NSMutableArray alloc]init];//neccesary because you can't add to something that doesnt exist. This is confusing because You'd think it would exist because of the fact that its a member variable and it has been declared. Arrays act strangely
        [self runXMLParse];
        //counter = previousCounter = [NodeList count];
        
        //NSLog(@"%@",NodeList);
        
        //[self addChild:[self nodeGenerator:CGPointMake(self.size.width/2, self.size.height-50)]];
    }
    return self;
}


-(void)didMoveToView:(SKView *)view{
    
    
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, -self.size.height/2 +200, self.size.width, 50)];//Bad practice to shove it off the screen
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:4.0];
    textField.textColor = [UIColor blackColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textField];
    
    
    [self updateNodesInScene];//LEAVE IT THEREEEREREER EMOTHERE GUCKCKKKCKKKKERERRR
}


#pragma mark-
#pragma mark Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self processReturn];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textedField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textedField.text stringByReplacingCharactersInRange:range withString:string];
    uILabel.text = newString;
    if([self isCorrectTypeOfString:string]){
        return YES;
    }
    return YES;
}

#pragma mark- Helpers
#pragma mark Helpers
-(void)processReturn{
    
    
    
    [self updateHighestID];
    [self fixPositionTypeToStrings];
    [self postTest];
    [labelList addObject:uILabel];
    
    
    [uILabel removeFromSuperview];
    uILabel.text = textField.text;
    textField.text = @"";
    [myWorld removeChildrenInArray:@[createdNode]];
    uILabel.text = @"";
    
    [self updatedQuery];
    [textField resignFirstResponder];//hides the keyboard

    //[myWorld removeChildrenInArray:@[createdNode]];
    

}

-(BOOL)isCorrectTypeOfString:(NSString *)stringPlacement{
    
    
    NSCharacterSet* notletters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if ([stringPlacement rangeOfCharacterFromSet:notletters].location == NSNotFound){
        return YES;
    }
    return NO;
}
#pragma -
#pragma mark Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched");
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectTap:)];
    tapRecognizer.numberOfTapsRequired = 2;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:panRecognizer];
    NSLog(@"%@",[self nodeAtPoint:positionInScene]);
    [self selectNodeForTouch:positionInScene];
}

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

- (void)selectNodeForTouch:(CGPoint)touchLocation{
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    animStart = touchedNode.position;
    
    if ([touchedNode.name isEqualToString:@"root"]){
        //SKAction *highlight = [SKAction resizeByWidth:20 height:20 duration:1];//replace this by implementing a larger texture
        //SKAction *center = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2) duration:1];
        //[touchedNode runAction:[SKAction repeatActionForever:action]];
        //[touchedNode runAction:highlight];
        //[touchedNode runAction:center];
    }
    else if ([touchedNode.name isEqualToString:@"node"]){
        
    }
        
        
        
    }

-(SKSpriteNode *)nodeGenerator:(CGPoint)location{
    SKSpriteNode *node = [[SKSpriteNode alloc]initWithImageNamed:@"blueBubble"];
    node.texture = [SKTexture textureWithImageNamed:@"blueBubble"];
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
-(void)fixPositionTypeToStrings{
    
    xPosition = [[NSMutableString alloc] initWithFormat:[NSString stringWithFormat:@"%f",_end.x]];
    yPosition = [[NSMutableString alloc] initWithFormat:[NSString stringWithFormat:@"%f",(_end.y+cameraEndY)]];
    predxPosition = [[NSMutableString alloc] initWithFormat:[NSString stringWithFormat:@"%f",_start.x]];
    predyPosition = [[NSMutableString alloc] initWithFormat:[NSString stringWithFormat:@"%f",(_start.y+cameraEndY)]];
}


#pragma mark - GestureRecognizers
-(void)detectTap:(UITapGestureRecognizer *)tapRec{//should enable the ability to change the text when
    CGPoint touchLoc = [self convertPointFromView:[tapRec locationInView:tapRec.view]];

    
    
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLoc];
    if([touchedNode.name isEqualToString:@"node"]){
        
    }
    else if (touchedNode){
        
            createdNode =[self nodeGenerator:[self pointConvertor:touchLoc]];
            //[myWorld addChild:[self userNameLabelGenerator:[self pointConvertor:_end] forString:userName]];
            [myWorld addChild:createdNode];
            _end = touchLoc;
            _start = touchLoc;
            UILabel *labelNode = [self labelGenerator:_end];
            uILabel = labelNode;
            [self.view addSubview:uILabel];
            [textField becomeFirstResponder];
    }
    
}

- (void) detectPan:(UIPanGestureRecognizer *) panRec{// the function that is called if a pan gesture is recognized
    CGPoint touchLoc = [self convertPointFromView:[panRec locationInView:panRec.view]];
    if(panRec.state == UIGestureRecognizerStateBegan){
        _start = touchLoc;
        previousTouchLoc=_start;
        
    }
    else if(panRec.state== UIGestureRecognizerStateChanged){
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:_start];
        if ([touchedNode.name isEqualToString:@"myWorld"]){
            if(touchLoc.x != previousTouchLoc.x){
                previousTouchLoc = touchLoc;
            }
            if(touchLoc.y != previousTouchLoc.y){
                int diff = touchLoc.y - previousTouchLoc.y;
                camera.position = CGPointMake(camera.position.x, camera.position.y - diff) ;
                previousTouchLoc = touchLoc;
                cameraEndY = cameraEndY - diff;
                for (UILabel *label in labelList) {
                    NSLog(@"%@",label);
                    label.frame = CGRectMake(label.frame.origin.x,label.frame.origin.y - diff, labelWidth, labelHeight);//Adjusts the labels.
                    [self.view addSubview:label];
                }
            }
        }
        else if (!touchedNode.name){

            if(touchLoc.x != previousTouchLoc.x){
                previousTouchLoc = touchLoc;
            }
            if(touchLoc.y != previousTouchLoc.y){
                int diff = touchLoc.y - previousTouchLoc.y;
                camera.position = CGPointMake(camera.position.x, camera.position.y - diff) ;
                previousTouchLoc = touchLoc;
                cameraEndY = cameraEndY - diff;
                for (UILabel *label in labelList) {
                    NSLog(@"%@",label);
                    label.frame = CGRectMake(label.frame.origin.x,label.frame.origin.y - diff, labelWidth, labelHeight);//Adjusts the labels.
                    [self.view addSubview:label];
                }
            }
 
        }
    }
    else if (panRec.state == UIGestureRecognizerStateRecognized){
       
        //NSLog(@"Recognized");
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:_start];
        if ([touchedNode.name isEqualToString:@"myWorld"]){
            
        }

    }
     if (panRec.state == UIGestureRecognizerStateEnded){//When selecting a node, the area of selection is too small
        _end = touchLoc;
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:_start];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, _start.x, _start.y+cameraEndY);
        CGPathAddLineToPoint(path, nil, _end.x, _end.y+cameraEndY);
        SKShapeNode *pathVisual = [[SKShapeNode alloc]init];
        pathVisual.path = path;
        pathVisual.strokeColor = [UIColor blackColor];
        pathVisual.zPosition = 1;
        
        if([touchedNode.name isEqualToString:@"node"]){
            createdNode = [self nodeGenerator:[self pointConvertor:_end]];
            //textField.text=@"";
            [myWorld addChild:createdNode];
            [myWorld addChild:pathVisual];
            UILabel *labelNode = [self labelGenerator:_end];
            uILabel = labelNode;
            [self.view addSubview:uILabel];
            [textField becomeFirstResponder];

            
        }
    }
    
}
-(UILabel*)labelGenerator:(CGPoint)labelLocation{//Shift up and to the left, center the text and add the ability to add lines
    CGPoint convertedCoordinates = [self convertPointToView:CGPointMake(labelLocation.x-labelWidth/2, labelLocation.y+labelHeight/2)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(convertedCoordinates.x, convertedCoordinates.y, labelWidth, labelHeight)];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Times" size:12.0];
    label.backgroundColor =[UIColor clearColor];
    return label;
}

#pragma mark - 
#pragma mark- PHPconnection
-(void)runXMLParse{
    //runs the parse
    NSURL *url = [NSURL URLWithString:@"http://104.131.53.146/xmlScript.php"];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    
    if ([element isEqualToString:@"chatitems"]) {
         item    = [[NSMutableDictionary alloc] init];
        identifier = [[NSMutableString alloc]init];
         userUpdate  = [[NSMutableString alloc] init];
         messageUpdate  = [[NSMutableString alloc] init];
        xPosition = [[NSMutableString alloc]init];
        yPosition = [[NSMutableString alloc]init];
        predxPosition = [[NSMutableString alloc]init];
        predyPosition = [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    //NSLog(@"Step 1");
    if ([element isEqualToString:@"user"]) {
        [userUpdate appendString:string];
        //NSLog(@"Found User");
        //NSLog(@"title element found – create a new instance of Title class...");
    }
    else if ([element isEqualToString:@"id"]){
        [identifier appendString:string];
    }
    else if ([element isEqualToString:@"message"]){
        [messageUpdate appendString:string];}
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
    if ([elementName isEqualToString:@"chatitems"]) {
        [item setObject:identifier forKey:@"id"];
        [item setObject:userUpdate forKey:@"user"];
        [item setObject:messageUpdate forKey:@"message"];
        [item setObject:xPosition forKey:@"xPosition"];
        [item setObject:yPosition forKey:@"yPosition"];
        [item setObject:predxPosition forKey:@"predxPosition"];
        [item setObject:predyPosition forKey:@"predyPosition"];
        [NodeList addObject:[item copy]];//The problem lies in add objects

    }}
-(void)postTest{
    NSLog(@"position %@",xPosition);
    NSString *post = [NSString stringWithFormat:@"&user=%@&message=%@&xPosition=%@&yPosition=%@&predxPosition=%@&predyPosition=%@",_userName,textField.text,xPosition,yPosition,predxPosition,predyPosition];
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
    }
-(void)updateNodesInScene{
    for (NSMutableDictionary *keyValue in NodeList) {
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
        
        [myWorld addChild:[self userNameLabelGenerator:_end forString:userUpdate]];
        [myWorld addChild:[self nodeGenerator:_end]];// These methods onbly work for when it is stationary
        [myWorld addChild:pathVisual];
        _labeledNode = [self labelGenerator:CGPointMake(_end.x, _end.y-(cameraEndY-cameraStartY))];//
        _labeledNode.text = keyValue[@"message"];
        [self.view addSubview:_labeledNode];
        [labelList addObject:_labeledNode];
    }
}

-(SKLabelNode *)userNameLabelGenerator:(CGPoint)location
                                      forString:(NSString *)currentUser{
    SKLabelNode *node = [[SKLabelNode alloc] init];
    node.text = currentUser;
    node.position = location;
    node.position = CGPointMake(location.x+50, location.y+40);
    node.zPosition = 4;
    node.fontSize = 8;
    node.fontColor= [UIColor grayColor];
    return node;
    
}
-(void)addNewNodesToScene{
    
    for ( NSMutableDictionary *keyValue in NodeList) {
    
        if ([keyValue[@"id"] intValue] > highestID){
        
            NSLog(@"We in there");
            NSLog(@"Object is not contained now we add");
            //[tempList addObject:keyValue];
            //I need a way to filter out any nodes that have already been added to the scene
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
        
        [myWorld addChild:[self userNameLabelGenerator:_end forString:userUpdate]];
        [myWorld addChild:[self nodeGenerator:_end]];
        [myWorld addChild:pathVisual];
        _labeledNode = [self labelGenerator:_end];
        _labeledNode.text = keyValue[@"message"];
        [self.view addSubview:_labeledNode];
        [labelList addObject:_labeledNode];
    //    previousCounter = previousCounter + 1;
        }
    }
}
#pragma MARK - CAMERA
- (void)didSimulatePhysics
{
    [self centerOnNode: [self childNodeWithName: @"//camera"]];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,node.parent.position.y - cameraPositionInScene.y);
    
}

-(CGPoint)pointConvertor:(CGPoint)inputLoc{
    
    return CGPointMake(inputLoc.x, inputLoc.y + cameraEndY);
    
}


//Whats left is to make the camera move when panning



#pragma mark - Update current Node list
-(void)updateTempList{
    for (NSMutableDictionary *tempHolder in NodeList) {
        [tempList addObject:tempHolder];
    }
}





-(void)NameChanger{
    SKLabelNode *label = [[SKLabelNode alloc]init];
    label.name = @"nameLabel";
    label.text = @"Pick a Name";
    label.position = CGPointMake(self.size.width/2, self.size.height/2);
    label.zPosition = 4;
    label.fontColor = [UIColor blackColor];
    
    [myWorld addChild:label];
    
}




-(void)updateHighestID{
    //counter = 0;
    for (NSMutableDictionary *keyValue in NodeList){
        if ([keyValue[@"id"] intValue] > counter) {
            
            counter = [keyValue[@"id"] intValue];
        }
    }
    
    highestID = counter;
    NSLog(@"%d",highestID);
}



-(void)updatedQuery{

    [NodeList removeAllObjects];
    // im not fixing the position of the string correctly
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d",highestID]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];

    [self updateNodesInScene];

}




-(void)adjustStringsPosition{
    //By subtracting camera end from camerastartwe have the position that has been shifted
    //We dont want to tweak this in the database, instead we want to adjust the info when it retu
}





@end
