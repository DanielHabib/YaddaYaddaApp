//
//  BubbleChatViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BubbleChatViewController.h"
#import "BubbleChatScene.h"

static NSString * kViewTransformChanged = @"view transform changed";
@interface BubbleChatViewController ()

@property(nonatomic, weak)BubbleChatScene *scene;
@property(nonatomic, weak)UIView *clearContentView;
@end






@implementation BubbleChatViewController{
    NSMutableString *xPosition;
    NSMutableString *yPosition;
    NSMutableString *predxPosition;
    NSMutableString *predyPosition;
    //NSMutableString *username;
    UILabel *uILabel;
    UILabel *backButton;
    UITextField *textField;
    CGSize contentSize;
    UIScrollView *scrollView;
    int labelWidth;
    int labelHeight;
    int highestID;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *NodeList;
    NSMutableArray *labelList;
    NSMutableArray *tempList;
    NSMutableString *userUpdate;
    NSMutableString *messageUpdate;
    NSMutableString *identifier;
    NSString *element;
    int counter;
    CFTimeInterval lastUpdateTimeInterval;
    double timeSinceLastTick;
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    counter = 0;
    timeSinceLastTick = 0;
    highestID = 0;
    labelHeight = 100;
    labelWidth = 100;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, -100, 400, 50)];//Bad practice to shove it off the screen
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:4.0];
    textField.textColor = [UIColor blackColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.userInteractionEnabled = YES;
    textField.delegate = self;
    textField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textField];
    self.view.userInteractionEnabled = YES;
    backButton = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, 50, 20)];
    backButton.text = @"Back";
    backButton.textColor = [UIColor blueColor];
    
    labelList = [[NSMutableArray alloc]init];
    NodeList = [[NSMutableArray alloc]init];
    
    uILabel = [[UILabel alloc]init];
    //uILabel.backgroundColor = [UIColor whiteColor];
    //[self resignFirstResponder];
    
    
    //[textField resignFirstResponder];
    //Attempting to use defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_topic forKey:@"currentTopic"];
    NSString *username = [defaults objectForKey:@"username"];
    [defaults synchronize];
    _userName = username;
    
    //NSString *username = [NSMutableString stringWithString:@"Dan"];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    
    // Create and configure the scene.
    BubbleChatScene *scene = [BubbleChatScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    scene.topic = _topic;

    // Present the scene.
    [skView presentScene:scene];
    _scene = scene;
    
    //Increase the content size
    contentSize = skView.frame.size;
    contentSize.height *= 3;
    contentSize.width *= 2;
    [scene setContentSize:contentSize];
    
    scrollView = [[UIScrollView alloc] initWithFrame:skView.frame];
    [scrollView setContentSize:contentSize];
    
    scrollView.delegate = self;
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:3.0];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    UIView *clearContentView = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = contentSize}];
    [clearContentView setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:clearContentView];
    [scrollView addSubview:backButton];
    _clearContentView = clearContentView;
    
    [clearContentView addObserver:self
                       forKeyPath:@"transform"
                          options:NSKeyValueObservingOptionNew
                          context:&kViewTransformChanged];
    
    
    
    //addition
 
    uILabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.cancelsTouchesInView = NO;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
    [scrollView addGestureRecognizer:singleTap];
    [skView addSubview:scrollView];
    //[scrollView addSubview:uILabel];
    
    [self updateHighestID];//I think this area works
    [self updatedQuery];
    
    
}


-(void)detectSingleTap:(UIGestureRecognizer *)tapRec{
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];
    [self TapIsInBackButton:touchLoc];
    NSLog(@"detectSingleTap recognixed");
}

-(void)detectTap:(UITapGestureRecognizer *)tapRec{
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];
    [self updateHighestID];
    [self updatedQuery];
    _start = touchLoc;
    
    if ([self TapIsInLabel:CGPointMake(touchLoc.x,touchLoc.y)]){
        if([self TapIsInLabel:CGPointMake(touchLoc.x, touchLoc.y + labelHeight*1.5)]){
            NSLog(@"center child filled");
            if([self TapIsInLabel:CGPointMake(touchLoc.x + labelWidth*1.2,touchLoc.y + labelHeight*1.5)]){
                NSLog(@"right child filled");
                if ([self TapIsInLabel:CGPointMake(touchLoc.x - labelWidth*1.2, touchLoc.y +labelHeight*1.5)]){
                    NSLog(@"left child filled");
                }
                else{
                    [self postToScene:CGPointMake(touchLoc.x - labelWidth*1.2, touchLoc.y +labelHeight*1.5)];
                }
            }
            else{
                [self postToScene:CGPointMake(touchLoc.x+labelWidth*1.2, touchLoc.y + labelHeight*1.5)];
            }
        }
        else{
            [self postToScene:CGPointMake(touchLoc.x, touchLoc.y + labelHeight*1.5)];
        }
    }
    else{
        [self postToScene:touchLoc];
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

}

-(void)postToScene:(CGPoint)location{
    CGPoint positionHolder;
    self.scene.contentOffset;
    
    positionHolder.x =  location.x;
    positionHolder.y = (-self.scene.spriteForScrollingGeometry.position.y) - location.y;

    _start.y = (-self.scene.spriteForScrollingGeometry.position.y) - _start.y;
    
    UILabel *labelNode = [self LabelGenerator:location];
    uILabel = labelNode;
    [scrollView addSubview:uILabel];
    predxPosition = [NSMutableString stringWithFormat:@"%f",_start.x];
    predyPosition = [NSMutableString stringWithFormat:@"%f", _start.y];
    
    xPosition = [NSMutableString stringWithFormat:@"%f",positionHolder.x];
    yPosition = [NSMutableString stringWithFormat:@"%f", positionHolder.y];

    [textField becomeFirstResponder];
}

-(void)updatedQuery{
    
    [NodeList removeAllObjects];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    [self updateNodesInScene];
    
}
-(void)updateNodesInScene{
    for (NSMutableDictionary *keyValue in NodeList) {

        _end.x = [keyValue[@"xPosition"] intValue];
        _end.y = [keyValue[@"yPosition"] intValue];
        _start.x = [keyValue[@"predxPosition"] intValue];
        _start.y = [keyValue[@"predyPosition"] intValue];

        CGPoint positionHolder;
        
        positionHolder.x = _end.x;
        positionHolder.y = (-self.scene.spriteForScrollingGeometry.position.y - _end.y);
        
        UILabel *_labeledNode = [self LabelGenerator:CGPointMake(positionHolder.x, positionHolder.y)];//-(cameraEndY-cameraStartY)
        _labeledNode.text = keyValue[@"message"];
        uILabel = _labeledNode;
        uILabel.userInteractionEnabled = YES;
        [scrollView addSubview:uILabel];
        [scrollView bringSubviewToFront:uILabel];
        [labelList addObject:uILabel];
    }
}


-(UILabel *)LabelGenerator:(CGPoint)location{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(location.x - labelWidth/2, location.y-labelHeight/2, labelWidth, labelHeight)];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Times" size:12.0];
    label.backgroundColor =[UIColor clearColor];
    
    return label;
}

-(void)postTest{

    NSString *post = [NSString stringWithFormat:@"&user=%@&message=%@&xPosition=%@&yPosition=%@&predxPosition=%@&predyPosition=%@&topic=%@",_userName,textField.text,xPosition,yPosition,predxPosition,predyPosition,_topic];
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

-(void)adjustContent:(UIScrollView *)scrolledView
{
    CGFloat zoomScale = [scrolledView zoomScale];
    [self.scene setContentScale:zoomScale];
    CGPoint contentOffset = [scrolledView contentOffset];
    [self.scene setContentOffset:contentOffset];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrolledView
{
    [self adjustContent:scrolledView];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.clearContentView;
}

-(void)scrollViewDidTransform:(UIScrollView *)scrolledView
{
    [self adjustContent:scrolledView];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrolledView withView:(UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum.
{
    [self adjustContent:scrolledView];
}
#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if (context == &kViewTransformChanged)
    {
        [self scrollViewDidTransform:(id)[(UIView *)object superview]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark TextBox


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

#pragma mark -
#pragma mark Helpers
-(void)processReturn{
    
 
    
    [self updateHighestID];
    //[self fixPositionTypeToStrings];
    [self postTest];
    [self.scene.labelList addObject:uILabel];
    [uILabel removeFromSuperview];
    uILabel.text = textField.text;
    textField.text = @"";
    //[myWorld removeChildrenInArray:@[createdNode]];
    //uILabel.text = @"";
    //[self updatedQuery];
    [textField resignFirstResponder];//hides the keyboard
    [self updateHighestID];//I think this area works
    [self updatedQuery];
}

-(BOOL)isCorrectTypeOfString:(NSString *)stringPlacement{
    
    
    NSCharacterSet* notletters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    if ([stringPlacement rangeOfCharacterFromSet:notletters].location == NSNotFound){
        return YES;
    }
    
    return NO;
}

//--------------------------------------------------------------------------------
-(void)updateScene{
    [self runXMLParse];
}


















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
    if ([elementName isEqualToString:[NSString stringWithFormat:@"%@",_topic]]) {
        [item setObject:identifier forKey:@"id"];
        [item setObject:userUpdate forKey:@"user"];
        [item setObject:messageUpdate forKey:@"message"];
        [item setObject:xPosition forKey:@"xPosition"];
        [item setObject:yPosition forKey:@"yPosition"];
        [item setObject:predxPosition forKey:@"predxPosition"];
        [item setObject:predyPosition forKey:@"predyPosition"];
        [NodeList addObject:[item copy]];//The problem lies in add objects
        
    }}


-(void)TapIsInBackButton:(CGPoint)location{
    CGPoint labelCenter;
    double maxDistance = labelWidth/2;
    double actualDistance;
 
        labelCenter = CGPointMake(backButton.frame.origin.x+labelWidth/2, backButton.frame.origin.y+labelHeight/2);
        //Apply distance formula
        actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y - labelCenter.y)*(location.y - labelCenter.y));
        if (maxDistance>actualDistance){
            [self performSegueWithIdentifier:@"backButton" sender:self];
        }
    
}


-(void)setUpBackButton{
    UIButton * backUIButton = [[UIButton alloc]initWithFrame:backButton.frame];
    [backUIButton setImage:[UIImage imageNamed:@"blueBubble.png"] forState:UIControlStateNormal];
    [scrollView addSubview:backUIButton];
}
-(BOOL)TapIsInLabel:(CGPoint)location{
    CGPoint labelCenter;
    double maxDistance = labelWidth/2;
    double actualDistance;
    for (UILabel *label in labelList) {
         labelCenter = CGPointMake(label.frame.origin.x+labelWidth/2, label.frame.origin.y+labelHeight/2);
        //Apply distance formula
        actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y - labelCenter.y)*(location.y - labelCenter.y));
        if (maxDistance>actualDistance){
            return true;
            
        }
    }
    return false;
}



- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}












-(BOOL)shouldAutorotate{
    return NO;
}




-(void)dealloc
{
    @try {
        [self.clearContentView removeObserver:self forKeyPath:@"transform"];
    }
    @catch (NSException *exception) {    }
    @finally {    }
}







@end
