//
//  YaddaYaddaViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>//
#import "Node.h"
#import "YaddaYaddaViewController.h"
static NSString * kViewTransformChanged = @"view transform changed";
@interface YaddaYaddaViewController ()
@property(nonatomic, weak)UIView *clearContentView;

@end

@implementation YaddaYaddaViewController{
    BOOL live;
    NSMutableString *xPosition;
    NSMutableString *yPosition;
    NSMutableString *predxPosition;
    NSMutableString *predyPosition;
    //NSMutableString *username;
    UILabel *uILabel;
    UILabel *backButton;
    UITextField *textField;
    CGSize contentSize;
    CGFloat contentOff;
    UIScrollView *scrollView;
    int type ;
    int labelWidth;
    int labelHeight;
    int highestID;
    int tierValue;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableArray *NodeList;
    NSMutableArray *likeList;
    NSMutableArray *NodeClassList;
    NSMutableArray *CommentClassList;
    NSMutableArray *tempList;
    NSMutableString *unitUpdate;
    NSMutableString *userUpdate;
    NSMutableString *messageUpdate;
    NSMutableString *colorUpdate;
    NSMutableString *identifier;
    NSMutableString *pathColor;
    NSMutableString *pathStyle;
    NSString *element;
    UIColor *colorHolder;
    int unit;
    NSMutableString * Comments;
    NSMutableString * Likes;
    NSMutableString * tier;
    int counter;
    SystemSoundID audioEffect;
    Node *currentNode;
    BOOL chosenState;
    BOOL chosenState2;
    NSMutableString *bubbleColor;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    live = false;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNodesInScene:)
                                     //           name:UIApplicationDidEnterBackgroundNotification object:nil];
    chosenState2 = false;
    unit  = 0;
    counter = 0;
    highestID = 0;
    labelHeight = 100;
    labelWidth = 100;

    self.view.userInteractionEnabled = YES;
    NodeList = [[NSMutableArray alloc]init];
    uILabel = [[UILabel alloc]init];
    NodeClassList = [[NSMutableArray alloc]init];
    CommentClassList = [[NSMutableArray alloc]init];
    likeList = [[NSMutableArray alloc]init];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_topic forKey:@"currentTopic"];
    bubbleColor = [defaults objectForKey:@"bubbleColor"];
    colorHolder = [self colorWithHexString:bubbleColor];
    NSString *username = [defaults objectForKey:@"username"];
    [defaults synchronize];
    _userName = username;
    ;
    
    // Create and configure the scene.
   // BubbleChatScene *scene = [BubbleChatScene sceneWithSize:skView.bounds.size];
  
    
    // Present the scene.
    //[skView presentScene:scene];
    //_scene = scene;
    chosenState = false;
    //Increase the content size
    contentSize = self.view.frame.size;
    contentSize.height *= 1;
    contentSize.width *= 1;
    
    //[scene setContentSize:contentSize];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    
    
    
    [scrollView setContentSize:contentSize];
    scrollView.delegate = self;
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:3.0];
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    UIView *clearContentView = [[UIView alloc] initWithFrame:(CGRect){.origin = CGPointZero, .size = contentSize}];
    [clearContentView setBackgroundColor:[UIColor clearColor]];

    [scrollView addSubview:clearContentView];
    

    _clearContentView = clearContentView;
    
    [clearContentView addObserver:self
                       forKeyPath:@"transform"
                          options:NSKeyValueObservingOptionNew
                          context:&kViewTransformChanged];
    
       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    uILabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(detectHold:)];
    //UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTap:)];
   //singleTap.numberOfTapsRequired = 1;
    //singleTap.cancelsTouchesInView = NO;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.numberOfTapsRequired = 2;
    hold.minimumPressDuration = .6;
    
    [scrollView addGestureRecognizer:doubleTap];
    //[scrollView addGestureRecognizer:singleTap];
    [scrollView addGestureRecognizer:hold];
    [self.view addSubview:scrollView];
    //self.view.backgroundColor = [UIColor colorWithRed:227.0/256.0 green:227.0/256.0 blue:227.0/256.0 alpha:1];
    
    [self updateHighestInt];
    [self updateHighestID];//I think this area works
    [self updatedQuery];
    //[self setUpTopic];
    [self updateHighestInt];
    [self adjustDynamicScrollViewContent];
    //[self playAudio];
    contentSize = self.view.frame.size;
    contentSize.height =  [self unitNumberToLocation:unit].y+180 ;
    contentSize.width *= 1;
    [scrollView setContentSize:contentSize];

    // Do any additional setup after loading the view.
    //[self updateNumberOfCommentsPerNode];
    self.naviBar.title = _topic;

    textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 400, 50)];//Bad practice to shove it off the screen
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:12.0];
    textField.textColor = [UIColor blackColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.userInteractionEnabled = YES;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.backgroundColor = [UIColor colorWithRed:227.0/256.0 green:227.0/256.0 blue:227.0/256.0 alpha:1];
    [self.view addSubview:textField];
    
    
    live = true;
    
}
-(void)buttonMethod{
    [self shouldPerformSegueWithIdentifier:@"backButton" sender:self];
}
#pragma mark - GESTURE RECOGNIZERS
-(void)detectSingleTap:(UIGestureRecognizer *)tapRec{
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];
    [self TapIsInBackButton:touchLoc];
}
-(void)detectHold:(UIGestureRecognizer *)tapRec{
    chosenState = true;
    if (tapRec.state == UIGestureRecognizerStateBegan){
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];
    _start = touchLoc;
    [self HoldIsInNode:touchLoc];
    //currentNode.numberOfComments += 1;
    }
    
    
}
-(void)detectTap:(UITapGestureRecognizer *)tapRec{
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];
    [self updateHighestID];
    [self updatedQuery];
    _start = touchLoc;
    [self TapsIsInNode:touchLoc];

    /*    if([self TapIsInLabel:CGPointMake(touchLoc.x, touchLoc.y + labelHeight*1.5)]){
     
            if([self TapIsInLabel:CGPointMake(touchLoc.x + labelWidth*1.2,touchLoc.y + labelHeight*1.5)]){
     
                if ([self TapIsInLabel:CGPointMake(touchLoc.x - labelWidth*1.2, touchLoc.y +labelHeight*1.5)]){
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
        }*/

        //If a node isn't touched
       // [self initialNodeSetUp];

}
-(void)HoldIsInNode:(CGPoint)location{
    CGPoint labelCenter;
    double maxDistance = labelWidth/2+10;
    double actualDistance;
    tierValue = 1;
    for(Node* node in NodeClassList){
        if(node.tier == 1){
        
        CGPoint position = node.location;
        labelCenter = CGPointMake(position.x, position.y);
        
        actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y - labelCenter.y)*(location.y - labelCenter.y));
        if (maxDistance>actualDistance){
            //Hold is in label
            //lets work
            
            currentNode = node;
                _start = location;
            [self commentGenerator:currentNode.location commentNumber:currentNode.numberOfComments + 1];

        }
            }
            
        }
        
    }
-(void)postComment:(CGPoint)location{
    [scrollView addSubview:uILabel];
    chosenState2 = true;
    tierValue = 2;
    unitUpdate = [NSMutableString stringWithFormat:@"%d",unit];
    predxPosition = [NSMutableString stringWithFormat:@"%f",_start.x];
    predyPosition = [NSMutableString stringWithFormat:@"%f", _start.y];
    xPosition = [NSMutableString stringWithFormat:@"%f",location.x];
    yPosition = [NSMutableString stringWithFormat:@"%f", location.y];
    Comments = [NSMutableString stringWithFormat:@"%d",currentNode.numberOfComments + 1];
    Likes = [NSMutableString stringWithFormat:@"0"];
    tier = [NSMutableString stringWithFormat:@"%d",tierValue];
    [textField becomeFirstResponder];
}
    
    
    

-(void)initialNodeSetUp{
    if([NodeClassList count] == 0 ){
        CGPoint spot = CGPointMake(50, 180);
        _start = _end = spot;
        unit = 1;
        [self postToScene:spot];
        
    }
}
-(void)updateHighestInt{
    for (Node *node in NodeClassList){
        if (node.unit > unit){
            unit = node.unit;
        }
    }
    //Node *node = [NodeClassList lastObject];
    //unit = node.unit;

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
    

    //self.scene.contentOffset;
    chosenState = true;
    positionHolder.x =  location.x;
    positionHolder.y = location.y;
    UILabel *labelNode = [self LabelGenerator:location];
    uILabel = labelNode;
    CGRect frame = uILabel.frame;
    uILabel.frame = CGRectMake(uILabel.frame.origin.x, uILabel.frame.origin.y, 0, 0);
    
    
    uILabel.alpha = 0;
    [scrollView addSubview:uILabel];
    //Add Animations
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    uILabel.alpha = 1;
    uILabel.frame = frame;
    
    
    [UIView commitAnimations];
    
    
    
    unitUpdate = [NSMutableString stringWithFormat:@"%d",unit];
    predxPosition = [NSMutableString stringWithFormat:@"%f",_start.x];
    predyPosition = [NSMutableString stringWithFormat:@"%f", _start.y];
    xPosition = [NSMutableString stringWithFormat:@"%f",positionHolder.x];
    yPosition = [NSMutableString stringWithFormat:@"%f", positionHolder.y];
    Comments = [NSMutableString stringWithFormat:@"0"];
    Likes = [NSMutableString stringWithFormat:@"0"];
    tier = [NSMutableString stringWithFormat:@"%d",tierValue];
    [textField becomeFirstResponder];
}

-(void)adjustDynamicScrollViewContent{
    
    [scrollView setContentSize:contentSize];
    
}





-(void)updatedQuery{
    
    [NodeList removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    [self updateNodesInScene];
    [self adjustDynamicScrollViewContent];
    
}
-(void)updateNodesInScene{
    if(unit > 3){
        [self updateHighestInt];
        contentSize = self.view.frame.size;
        contentSize.height =  [self unitNumberToLocation:unit].y+350 ;
        contentSize.width *= 1;
        [scrollView setContentSize:contentSize];
        
    }
    for (NSMutableDictionary *keyValue in NodeList) {
        
        _end.x = [keyValue[@"xPosition"] intValue];
        _end.y = [keyValue[@"yPosition"] intValue];
        _start.x = [keyValue[@"predxPosition"] intValue];
        _start.y = [keyValue[@"predyPosition"] intValue];
        
        NSString * newText = keyValue[@"message"];
        newText = [newText stringByReplacingOccurrencesOfString:@":smile:" withString:@"😄"];
        newText = [newText stringByReplacingOccurrencesOfString:@":angel:" withString:@"👼"];
        newText = [newText stringByReplacingOccurrencesOfString:@":sleepy:" withString:@"😴"];
        
        
        
        messageUpdate = [NSMutableString stringWithFormat:@"%@",newText];
        userUpdate = keyValue[@"username"];
        Node *node = [[Node alloc]init];
        node.user = userUpdate;
        node.tier = [keyValue[@"tier"] intValue];
        node.text = newText;
        node.numberOfComments = [keyValue[@"Comments"]intValue];
        node.likes = [keyValue[@"Likes"]intValue];
        node.unit = [keyValue[@"unit"] intValue];
        node.ID = [keyValue[@"id"] intValue];
        node.location = _end;
        node.color = [self colorWithHexString:keyValue[@"color"]];
        node.pathColor = [self colorWithHexString:keyValue[@"pathColor"]];
        node.pathStyle = keyValue[@"pathStyle"];
        colorHolder = [self colorWithHexString:keyValue[@"color"]];
        
        tierValue = node.tier;
        unit = node.unit;
        //node.location = _end;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
       
        /// -----------------Conditional----------------------------------------------------------------------------------///////
        
        if (node.tier==1){
 
        UILabel *_labeledNode = [self LabelGenerator:_end];//-(cameraEndY-cameraStartY)
        //UIImageView *image = [self nodeGenerator:positionHolder];
        _labeledNode.text = newText;
        uILabel = _labeledNode;
        uILabel.userInteractionEnabled = YES;
        //[self playAudio];
        //path
        [self addProfilePhoto];
        [self likeGenerator:node.likes];
        [self pathGenerator:node.pathColor style:node.pathStyle];
        //[scrollView addSubview:image];
        [scrollView addSubview:uILabel];
 
        [scrollView addSubview:[self userNameLabelGenerator:_end forString:userUpdate]];
        [NodeClassList addObject:node];
        
        
        }
        else if (node.tier==2){
            UILabel *_labeledNode = [self createComment:_end];//-(cameraEndY-cameraStartY)

            _labeledNode.text = keyValue[@"message"];
            uILabel = _labeledNode;
            uILabel.userInteractionEnabled = YES;
            //[self playAudio];
            //path
            if (node.numberOfComments == 1) {
              
                
                if(node.unit % 2){
            UILabel *enclosingBracket = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth,[self unitNumberToLocation:node.unit].y - labelHeight/4, 20, 50)];
            enclosingBracket.text = @"{";
            enclosingBracket.font = [UIFont fontWithName:@"NexaLight" size:28];
                    enclosingBracket.textColor = [UIColor orangeColor];
            [scrollView addSubview:enclosingBracket];
            
                }
                else{
                    
                    UILabel *enclosingBracket = [[UILabel alloc]initWithFrame:CGRectMake(contentSize.width - labelWidth - 13,[self unitNumberToLocation:node.unit].y - labelHeight/4, 20, 50)];
                    enclosingBracket.text = @"}";
                    enclosingBracket.textColor = [UIColor orangeColor];
                    enclosingBracket.font = [UIFont fontWithName:@"NexaLight" size:28];
                    [scrollView addSubview:enclosingBracket];
                    
                    
                }
                
                
                
            
            }
            
                // [self addProfilePhoto];
            _end.y = _end.y + 20;
            //[self pathGenerator];
            //[scrollView addSubview:image];
            //[scrollView addSubview:uILabel];
            
            CGRect frame = uILabel.frame;
            uILabel.frame = CGRectMake(uILabel.frame.origin.x, uILabel.frame.origin.y, 0, 0);
            
            
            uILabel.alpha = 0;
            [scrollView addSubview:uILabel];
            //Add Animations
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            uILabel.alpha = 1;
            uILabel.frame = frame;
            
            
            [UIView commitAnimations];
            for (Node *nodeHolder in NodeClassList){
                if (nodeHolder.unit == node.unit){
                    nodeHolder.numberOfComments += 1;
                }
            }
            [scrollView addSubview:[self userNameLabelGenerator:CGPointMake(_end.x,_end.y+30) forString:userUpdate]];
            [CommentClassList addObject:node];
        }
    }
}
-(void)addNewlyParsedNodesToScene:(Node *)node{// implemeetn eventually
    //CGPoint Location = [self unitNumberToLocation:node.unit];
    //[scrollView addSubview:uILabel];
    //[scrollView]
    
}


#pragma mark - Generators


//-----------------------------------------------------------------------------------------|||||||||||||||||||||||
-(UILabel *)LabelGenerator:(CGPoint)location{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(location.x - labelWidth/2, location.y-labelHeight/2, labelWidth, labelHeight)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = colorHolder;
    //label.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
    label.numberOfLines = 0;
    
    //tweaked
    label.layer.cornerRadius = labelWidth/2;
    label.layer.masksToBounds = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Nexa Light" size:12.0];
    //label.backgroundColor =[UIColor clearColor];
    //label.alpha = 0;//Set alpha to 0
    return label;
}
-(UIImageView*)nodeGenerator:(CGPoint)location{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blueBubble.png"]];
    [imageView setFrame:CGRectMake(location.x-labelWidth/2, location.y-labelHeight/2, labelWidth, labelHeight)];
    
    return imageView;

    
}
-(UILabel *)userNameLabelGenerator:(CGPoint)location
                             forString:(NSString *)currentUser{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(location.x-5 , location.y - labelHeight/2 - 15, 100, 10)];
    label.text = currentUser;
    label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
    ///node.position = location;
    //node.position = CGPointMake(location.x+50, location.y+40);
    //node.zPosition = 8;
    
    label.textColor= [UIColor grayColor];
    return label;
}
-(void)pathGenerator:(UIColor*)pathColorH
                   style :(NSString*)pathStyleH{

    
    
    
    if ([pathStyleH isEqualToString:@"straight"]){
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_start];
    [path addLineToPoint:_end];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [pathColorH CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [pathColorH CGColor];
    shapeLayer.zPosition = -4;
    
    if(live){
       // [UIView beginAnimations:nil context:nil];
        //[UIView setAnimationDuration:.5];
        
        
        CABasicAnimation *pathAppear = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAppear.duration = 10.0; // 2 seconds
        pathAppear.fromValue = [NSNumber numberWithDouble:0];
        //pathAppear.fromValue = (__bridge id)_start;
        pathAppear.toValue   = [NSNumber numberWithDouble:400];
        
        
        [shapeLayer addAnimation:pathAppear forKey:@"make the path appear"];
        
        [scrollView.layer addSublayer:shapeLayer];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5f;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        //pathAnimation.repeatCount = 10;
        //pathAnimation.autoreverses = YES;
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
        //[UIView commitAnimations];
    
    
    
    }
    else{
        [scrollView.layer addSublayer:shapeLayer];
    }
    
    
    }
    else if ([pathStyleH isEqualToString:@"dashed"]){
        
        
        CGFloat pattern[2];
        pattern[0] = 10.0;
        pattern[1] = 10.0;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:_start];
        [path addLineToPoint:_end];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        
        CGPathRef pathHolder=CGPathCreateCopyByDashingPath([path CGPath], NULL, 0, pattern, 2) ;
        shapeLayer.path = pathHolder;
        shapeLayer.strokeColor = [pathColorH CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [pathColorH CGColor];
        shapeLayer.zPosition = -4;
        
        if(live){
            // [UIView beginAnimations:nil context:nil];
            //[UIView setAnimationDuration:.5];
            
            
            CABasicAnimation *pathAppear = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAppear.duration = 10.0; // 2 seconds
            pathAppear.fromValue = [NSNumber numberWithDouble:0];
            //pathAppear.fromValue = (__bridge id)_start;
            pathAppear.toValue   = [NSNumber numberWithDouble:400];
            
            
            [shapeLayer addAnimation:pathAppear forKey:@"make the path appear"];
            
            [scrollView.layer addSublayer:shapeLayer];
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.5f;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            //pathAnimation.repeatCount = 10;
            //pathAnimation.autoreverses = YES;
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
            
            //[UIView commitAnimations];
            
            
            
        }
        else{
            [scrollView.layer addSublayer:shapeLayer];
        }
        
        
        
        
    }
    else if (([pathStyleH isEqualToString:@"curved"])){
    
    
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        
        
        
        
        
        
        
        
        [path moveToPoint:_start];
      //  [path addCurveToPoint:<#(CGPoint)#> controlPoint1:<#(CGPoint)#> controlPoint2:<#(CGPoint)#>]
        [path addLineToPoint:_end];
        
        
        
        
        //JIAO HELP
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [pathColorH CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [pathColorH CGColor];
        shapeLayer.zPosition = -4;
        
        if(live){
            // [UIView beginAnimations:nil context:nil];
            //[UIView setAnimationDuration:.5];
            
            
            CABasicAnimation *pathAppear = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAppear.duration = 10.0; // 2 seconds
            pathAppear.fromValue = [NSNumber numberWithDouble:0];
            //pathAppear.fromValue = (__bridge id)_start;
            pathAppear.toValue   = [NSNumber numberWithDouble:400];
            
            
            [shapeLayer addAnimation:pathAppear forKey:@"make the path appear"];
            
            [scrollView.layer addSublayer:shapeLayer];
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.5f;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            //pathAnimation.repeatCount = 10;
            //pathAnimation.autoreverses = YES;
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];

        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    }
    
    
    
    
    else{
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:_start];
        [path addLineToPoint:_end];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [pathColorH CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [pathColorH CGColor];
        shapeLayer.zPosition = -4;
        
        if(live){
            // [UIView beginAnimations:nil context:nil];
            //[UIView setAnimationDuration:.5];
            
            
            CABasicAnimation *pathAppear = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAppear.duration = 10.0; // 2 seconds
            pathAppear.fromValue = [NSNumber numberWithDouble:0];
            //pathAppear.fromValue = (__bridge id)_start;
            pathAppear.toValue   = [NSNumber numberWithDouble:400];
            
            
            [shapeLayer addAnimation:pathAppear forKey:@"make the path appear"];
            
            [scrollView.layer addSublayer:shapeLayer];
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.5f;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
            //pathAnimation.repeatCount = 10;
            //pathAnimation.autoreverses = YES;
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
            
            //[UIView commitAnimations];
    }
    
    
    
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   // [scrollView sendSubviewToBack:<#(UIView *)#> ]
}
-(void)likeGenerator:(int)likes{
    
    //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(location.x, location.y, 100, 40)];
    if(unit % 2){
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_end.x + labelWidth/2 - 25, _end.y + labelWidth/2-15, 30, 30)];
        label.text = [NSString stringWithFormat:@"%d",likes];
        label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
        [scrollView addSubview:label];
        [likeList addObject:label];
    }
    else{
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_end.x - labelWidth/2 + 10, _end.y + labelHeight/2-15, 30, 30)];
        label.text = [NSString stringWithFormat:@"%d",likes];
        label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
        [scrollView addSubview:label];
        [likeList addObject:label];
    }
}
-(UILabel *)createComment:(CGPoint)location{
   
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(location.x, location.y , 100, 40)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
    //label.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
    label.numberOfLines = 0;
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
    return  label;
    
    //unit = 0;

}
-(void)commentGenerator:(CGPoint)location
                        commentNumber:(int)numberComment{
    if (numberComment<4){
    if(currentNode.unit % 2){
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(contentSize.width - 110, currentNode.location.y - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
        //label.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
        label.numberOfLines = 0;
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
        uILabel = label;
        unit = currentNode.unit;
       
        //currentNode.numberOfComments = numberComment ;
        _start = [self unitNumberToLocation:currentNode.unit];

        [self postComment:label.frame.origin];
        
        

    }
    else{
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake( 10, currentNode.location.y - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
        //label.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
        label.numberOfLines = 0;
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = YES;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
        uILabel = label;
        unit = currentNode.unit;
        //currentNode.numberOfComments = numberComment ;
        [self postComment:label.frame.origin];
        
        //ADd children to nodes when the lists are loaded
        
        
        
    }
        
        
        
        }
}




-(void)updateNumberOfCommentsPerNode{
    for (Node *comment in CommentClassList) {
        for (Node *node in NodeClassList) {
            if (comment.unit == node.unit){
                node.numberOfComments += 1;
                break;
            }
        }
            
        
    }
    
}














-(void)postLike:(int)identified{
    // all attributes assigned prior to posttest being called

    NSString *post = [NSString stringWithFormat:@"&topic=%@&id=%d",_topic,identified];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateLikes.php"]]];
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




-(void)postTest{
    // all attributes assigned prior to posttest being called
    
    NSString * newText = [NSString stringWithString:textField.text];
    newText = [newText stringByReplacingOccurrencesOfString:@"😀" withString:@":smile:"];
    newText = [newText stringByReplacingOccurrencesOfString:@"👼" withString:@":angel:"];
    newText = [newText stringByReplacingOccurrencesOfString:@"😴" withString:@":sleepy:"];

    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    pathColor = [defaults objectForKey:@"pathColor"];
    pathStyle = [defaults objectForKey:@"pathStyle"];
    
    //FINISH BY ADJUSTING THE PATH ATTTRIBUTES
    
    NSString *post = [NSString stringWithFormat:@"&user=%@&message=%@&xPosition=%@&yPosition=%@&predxPosition=%@&predyPosition=%@&topic=%@&unit=%@&numberOfComments=%@&numberOfLikes=%@&tier=%@&color=%@&pathColor=%@&pathStyle=%@",_userName,newText,xPosition,yPosition,predxPosition,predyPosition,_topic,unitUpdate,Comments,Likes,tier,bubbleColor,pathColor,pathStyle];
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
   // [self.scene setContentScale:zoomScale];
    CGPoint contentOffset = [scrolledView contentOffset];

    contentOff = contentOffset.y;
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
#pragma mark - scroolllllll

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
    if (!chosenState2) {
        [self updateHighestID];
        [self updatedQuery];
        [self updateHighestInt];
        scrollView.contentOffset = CGPointMake(0,[self unitNumberToLocation:unit+1].y - self.view.frame.size.height + 216*2 + 50);
        
        //[self adjustPositionOfScrollView];
        
       // unit += 1;
        colorHolder = [self colorWithHexString:bubbleColor];
        uILabel = [self LabelGenerator:[self unitNumberToLocation:unit]];
        [self updateHighestID];
        [self updatedQuery];
        [self updateHighestInt];//sends it
        tierValue = 1;
        _start = [self unitNumberToLocation:unit];
        unit += 1;
        if([NodeClassList count]==0){
            _start = _end = [self unitNumberToLocation:unit];
          //  NSLog(@"first node formed");
        }
        [self postToScene:[self unitNumberToLocation:unit]];
        
        
    }
    
    NSString *newString = [textedField.text stringByReplacingCharactersInRange:range withString:string];
    uILabel.text = newString;//edits it live
    chosenState2 = true;
    if([self isCorrectTypeOfString:string]){
        return YES;
        
    }
    return YES;
}

#pragma mark -
#pragma mark Helpers
-(void)processReturn{
    
    if(!chosenState){
    }
    else{
    
        [self updateHighestID];
        //[self fixPositionTypeToStrings];
        [self postTest];
        //[uILabel removeFromSuperview];
        uILabel.text = textField.text;
        textField.text = @"";

        [textField resignFirstResponder];//hides the keyboard
        [self updateHighestID];//I think this area works
        [self updatedQuery];
        chosenState = false;
        chosenState2 = false;
    }
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



//----------------PARSE-------------------//




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
        unitUpdate = [[NSMutableString alloc]init];
        Likes = [[NSMutableString alloc]init];
        Comments = [[NSMutableString alloc]init];
        tier = [[NSMutableString alloc]init];
        colorUpdate = [[NSMutableString alloc]init];
        pathStyle = [[NSMutableString alloc]init];
        pathColor = [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    //NSLog(@"Step 1");
    if ([element isEqualToString:@"username"]) {
        [userUpdate appendString:string];
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
        [Comments appendString:string];}
    else if ([element isEqualToString:@"Likes"]){
        [Likes appendString:string];}
    else if ([element isEqualToString:@"tier"]){
        [tier appendString:string];}
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
        [item setObject:userUpdate forKey:@"username"];
        [item setObject:messageUpdate forKey:@"message"];
        [item setObject:xPosition forKey:@"xPosition"];
        [item setObject:yPosition forKey:@"yPosition"];
        [item setObject:predxPosition forKey:@"predxPosition"];
        [item setObject:predyPosition forKey:@"predyPosition"];
        [item setObject:unitUpdate forKey:@"unit"];
        [item setObject:Comments forKey:@"Comments"];
        [item setObject:Likes forKey:@"Likes"];
        [item setObject:colorUpdate forKey:@"color"];
        [item setObject:tier forKey:@"tier"];
        [item setObject:pathColor forKey:@"pathColor"];
        [item setObject:pathStyle forKey:@"pathStyle"];
        [NodeList addObject:[item copy]];//The problem lies in add objects
        
    }}











-(void)TapIsInBackButton:(CGPoint)location{
    CGPoint labelCenter;
    double maxDistance = labelWidth/2;
    double actualDistance;
   
    labelCenter = CGPointMake(backButton.frame.origin.x+labelWidth/2, backButton.frame.origin.y+labelHeight/2 +contentOff);
    //Apply distance formula
    actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y  - labelCenter.y)*(location.y - labelCenter.y));
    if (maxDistance>actualDistance){
        [self performSegueWithIdentifier:@"backButton" sender:self];
    }
    
}
-(void)setUpBackButton{
    backButton = [[UILabel alloc]init];
    backButton.frame = CGRectMake(10, 20, 60, 20);
    backButton.text = @"Back";
    backButton.textColor = [UIColor blueColor];
    
       //[backUIButton setImage:[UIImage imageNamed:@"blueBubble.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
}
-(void)setUpTopic{
    UILabel *topicLabel =[[UILabel alloc]initWithFrame:CGRectMake(contentSize.width/6, 20, contentSize.width/1.5, 40)];
    topicLabel.text = [_topic stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    topicLabel.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:191.0/255.0 blue:135.0/255.0 alpha:.8];
    topicLabel.layer.cornerRadius = 8;
    topicLabel.layer.masksToBounds = YES;
    topicLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:topicLabel];
    
}
-(CGPoint)unitNumberToLocation:(int)uniT{
    CGFloat holder;
    if (uniT%2) {
        holder = 50;
    }
    else{
        holder = contentSize.width - 50;
    }
    CGPoint location = CGPointMake(holder, unit*180);
    return location;
}
-(void)TapsIsInNode :(CGPoint)location{//sending touchloc
    CGPoint labelCenter;
    double maxDistance = labelWidth/2+10;
    double actualDistance;
    tierValue = 1;
    for(Node* node in NodeClassList){
        
        CGPoint position = node.location;
        

        
        labelCenter = CGPointMake(position.x, position.y);

        actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y - labelCenter.y)*(location.y - labelCenter.y));
        
        

        if (maxDistance>actualDistance){
            NSLog(@"is in node");
           
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSData*imageData = [defaults objectForKey:@"LikeAnimation"];//[defaults objectForKey:@"LikeAnimation"];
            //UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue.jpg"]];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(location.x, location.y, 10, 10)];
            label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"upvote_downvote.png"]];
            label.alpha = 1;
            
            label.text = @"+1";
            label.font = [UIFont fontWithName:@"NexaLight" size:14];
            [scrollView addSubview:label];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
           // [UIView setAnimationRepeatAutoreverses:YES];
            label.alpha = 0;
            
            [UIView commitAnimations];
            
            
            
            
            
            
            
            
            
            //if inside the label was clicked
            /*if (node == [NodeClassList lastObject]) {
                [self updateHighestInt];
                unit += 1;
                //[self postToScene:[self unitNumberToLocation:node.unit+1]];
                //node.hasChild = YES;
                
             //if the node doesn't have a child add a node to the appropriate position
               // Node *newNode = [[Node alloc]init];
                //create new point based on unit number
            }*/
            [self postLike:node.ID];
        }
        
    }
    
    
    //return false;
}

- (void)playAudio {
    [[NSBundle mainBundle] pathForResource:@"bubbleAppear" ofType:@"wav"];
    [self playSound:@"bubbleAppear" :@"wav"];
}

- (void)playSound :(NSString *)fName :(NSString *) ext{
    //SystemSoundID audioEffect;
    
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        NSLog(@"Audio Effect Recognized");
    }
    else {
        NSLog(@"error, file not found: %@", path);
    }
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


-(void)addProfilePhoto{

    
    
    
    
    
    
    
    
    
    if (!([messageUpdate rangeOfString:@"😄"].location == NSNotFound)) {
        if(unit % 2){
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/happy/emojiPicture.jpg",userUpdate]]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x + labelWidth/2 - 25, _end.y - labelWidth/2 -20, 40, 40)];
            
            imageView.image = [[UIImage alloc]initWithData:imageData];
            imageView.layer.cornerRadius =  20;
            imageView.layer.masksToBounds = YES;
            //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(live){
                CGRect frame = imageView.frame;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
                
                
                imageView.alpha = 0;
                [scrollView addSubview:imageView];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                imageView.alpha = 1;
                imageView.frame = frame;

                [UIView commitAnimations];
            }
            else{
            [scrollView addSubview:imageView];
            }
            }
        else{
            
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/happy/emojiPicture.jpg",userUpdate]]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x - labelWidth/2 - 10, _end.y - labelWidth/2-20, 40, 40)];
            
            imageView.image = [[UIImage alloc]initWithData:imageData];
            imageView.layer.cornerRadius =  20;
            imageView.layer.masksToBounds = YES;
            //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(live){
                CGRect frame = imageView.frame;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
                
                
                imageView.alpha = 0;
                [scrollView addSubview:imageView];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                imageView.alpha = 1;
                imageView.frame = frame;
                [UIView commitAnimations];
            }
            else{
                [scrollView addSubview:imageView];
            }
        }

        
    }
    else if(!([messageUpdate rangeOfString:@"👼"].location == NSNotFound) ) {
        if(unit % 2){
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/angel/emojiPicture.jpg",userUpdate]]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x + labelWidth/2 - 25, _end.y - labelWidth/2 -20, 40, 40)];
            
            imageView.image = [[UIImage alloc]initWithData:imageData];
            imageView.layer.cornerRadius =  20;
            imageView.layer.masksToBounds = YES;
            //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(live){
                CGRect frame = imageView.frame;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
                
                
                imageView.alpha = 0;
                [scrollView addSubview:imageView];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                imageView.alpha = 1;
                imageView.frame = frame;
                [UIView commitAnimations];
            }
            else{
                [scrollView addSubview:imageView];
            }        }
        else{
            
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/angel/emojiPicture.jpg",userUpdate]]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x - labelWidth/2 - 10, _end.y - labelWidth/2-20, 40, 40)];
            
            imageView.image = [[UIImage alloc]initWithData:imageData];
            imageView.layer.cornerRadius =  20;
            imageView.layer.masksToBounds = YES;
            //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(live){
                CGRect frame = imageView.frame;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
                
                
                imageView.alpha = 0;
                [scrollView addSubview:imageView];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                imageView.alpha = 1;
                imageView.frame = frame;
                [UIView commitAnimations];
            }
            else{
                [scrollView addSubview:imageView];
            }
        }

        
        
        
        
        
        
    }
    else if (!([messageUpdate rangeOfString:@"😴"].location == NSNotFound)) {
        if(unit % 2){
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/sleepy/emojiPicture.jpg",userUpdate]]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x + labelWidth/2 - 25, _end.y - labelWidth/2 -20, 40, 40)];
            
            imageView.image = [[UIImage alloc]initWithData:imageData];
            imageView.layer.cornerRadius =  20;
            imageView.layer.masksToBounds = YES;
            //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(live){
                CGRect frame = imageView.frame;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
                
                
                imageView.alpha = 0;
                [scrollView addSubview:imageView];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                imageView.alpha = 1;
                imageView.frame = frame;
                [UIView commitAnimations];
            }
            else{
                [scrollView addSubview:imageView];
            }        }
        else{
            
            NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/sleepy/emojiPicture.jpg",userUpdate]]];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x - labelWidth/2 - 10, _end.y - labelWidth/2-20, 40, 40)];
            
            imageView.image = [[UIImage alloc]initWithData:imageData];
            imageView.layer.cornerRadius =  20;
            imageView.layer.masksToBounds = YES;
            //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            if(live){
                CGRect frame = imageView.frame;
                imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
                
                
                imageView.alpha = 0;
                [scrollView addSubview:imageView];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                imageView.alpha = 1;
                imageView.frame = frame;
                [UIView commitAnimations];
            }
            else{
                [scrollView addSubview:imageView];
            }
        }

        
    }
    else{
    
    if(unit % 2){
    NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",userUpdate]]];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x + labelWidth/2 - 25, _end.y - labelWidth/2 -20, 40, 40)];
    
    imageView.image = [[UIImage alloc]initWithData:imageData];
    imageView.layer.cornerRadius =  20;
    imageView.layer.masksToBounds = YES;
    //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
        if(live){
            CGRect frame = imageView.frame;
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
            
            
            imageView.alpha = 0;
            [scrollView addSubview:imageView];
            //Add Animations
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            imageView.alpha = 1;
            imageView.frame = frame;
            [UIView commitAnimations];
        }
        else{
            [scrollView addSubview:imageView];
        }    }
    else{
        
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",userUpdate]]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_end.x - labelWidth/2 - 10, _end.y - labelWidth/2-20, 40, 40)];
        
        imageView.image = [[UIImage alloc]initWithData:imageData];
        imageView.layer.cornerRadius =  20;
        imageView.layer.masksToBounds = YES;
        //imageView.image = [UIImage imageNamed:@"purpleBubbleIcon.png"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if(live){
            CGRect frame = imageView.frame;
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 0, 0);
            
            
            imageView.alpha = 0;
            [scrollView addSubview:imageView];
            //Add Animations
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            imageView.alpha = 1;
            imageView.frame = frame;
            [UIView commitAnimations];
        }
        else{
            [scrollView addSubview:imageView];
        }
        }

    }
}


-(void)adjustPositionOfScrollView{
    
    
    
    if (unit>=4) {
    scrollView.contentOffset = CGPointMake(0,scrollView.contentSize.height - self.view.bounds.size.height);
    }
    
}
-(UIColor *)colorWithHexString:(NSString *)hexString
{
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


#pragma mark -



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
