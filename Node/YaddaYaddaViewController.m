//
//  YaddaYaddaViewController.m
//  BubbleChat
//
//  Created by Daniel Habib on 9/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>//
#import "GCDAsyncSocket.h"
#import "Node.h"
#import "YaddaYaddaViewController.h"
static NSString * kViewTransformChanged = @"view transform changed";
@interface YaddaYaddaViewController ()
@property(nonatomic, weak)UIView *clearContentView;

@end

@implementation YaddaYaddaViewController{
    
    BOOL live;
    
    SystemSoundID playSoundID;

    UIVisualEffectView *visualEffectView;

    UIVisualEffect *blurEffect;

    CGPoint startCreation;
    CGPoint endCreation;
    NSMutableString *xPosition;
    NSMutableString *yPosition;
    NSMutableString *predxPosition;
    NSMutableString *predyPosition;
    //NSMutableString *username;
    UILabel *uILabel;
    UITextView *uITextView;
    UITextView *commentTextView;
    UITextView *uITextViewUNIS;
    UITextView *pollOption1;
    UITextView *pollOption2;
    UILabel *backButton;
    UITextView *textField;
    CGSize contentSize;
    CGFloat contentOff;
    CGFloat updatingContentHeight;
    CGFloat adjustedContentSize;
    UIScrollView *scrollView;
    int type ;
    int labelWidth;
    int labelHeight;
    int highestID;
    int tierValue;
    int tierCreation;
    int unitCreation;
    int thrownUnitForCommentPageSelection;
    int commentUpdateInt;
    int firstUnitSetup;
    int unit;
    int previousUnit;
    int counter;
    
    BOOL initialOffsetFlag;
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSString *element;
    
    __block NSMutableArray *PollList;
    __block NSMutableArray *PollClassList;
    __block NSMutableArray *commentSegueList;
    __block NSMutableArray *likeList;
    __block NSMutableArray *CommentList;
    __block NSMutableArray *CommentClassList;
    __block NSMutableArray *CommentCheckingForSegueList;
    __block NSMutableArray *tempList;
    
    __block NSMutableArray *NodeList;
    __block NSMutableArray *NodeClassList;
    __block NSMutableArray *NodedClassList;
    
    __block NSMutableString *unitUpdate;
    __block NSMutableString *userUpdate;
    __block NSMutableString *messageUpdate;
    __block NSMutableString *colorUpdate;
    __block NSMutableString *identifier;
    __block NSMutableString *pathColor;
    __block NSMutableString *pathStyle;
    __block NSMutableString *contentHeightUpdate;
    __block NSMutableString *phoneNumberUpdate;
    __block NSMutableString *phoneNumberForProfileCreation;
    __block NSMutableString *option1Update;
    __block NSMutableString *option2Update;
    CGRect initialTextfieldFrame;
     dispatch_source_t timer;
    UITextView *textContentSizeCalculator;
    UIColor *colorReset;
    UIColor *colorHolder;
    UIColor *colorHolderCreation;

    NSMutableString * Comments;
    NSMutableString * Likes;
    NSMutableString * tier;
    SystemSoundID audioEffect;
    Node *currentNode;
    Node *creatingNode;
    BOOL chosenState;
    BOOL chosenState2;
    BOOL singleThreadedUpdateRunningAtATime;
    BOOL AdjustmentFlag;
    CGFloat AdjustmentInitialFactor;
    
    NSMutableString *bubbleColor;
    
    CGFloat positionShift;
    
    dispatch_queue_t queue;
    
    NSTimer *uiTimer;
    
    
    NSInteger instanceKey;
    GCDAsyncSocket *socket;
    NSMutableArray *CellClassList;
    
    //UITextView * textViewHolder;
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self threadedUpdate];
   // [self threadedUpdate];
    [self someMethodWhereYouSetUpYourObserver];
    
   // [UIView beginAnimations:nil context:nil];
    //[UIView setAnimationDuration:1];
    uITextView.text = textField.text;
    textField.text = @"";
    [textField resignFirstResponder];//hides the keyboard
   // timer = [NSTimer scheduledTimerWithTimeInterval:4
   //                                          target:self
   //                                        selector:@selector(initialAdjustOffset)
   //                                        userInfo:nil
   //                                         repeats:NO];
    //[UIView commitAnimations];

    //live = true;
    NSLog(@"View did appear");
}
-(void)initialAdjustOffset{
    //[scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height- self.view.frame.size.height) animated:YES];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [uiTimer invalidate];
   // dispatch_source_cancel(timer);
}
- (void)viewDidLoad {
    AdjustmentFlag=true;
    singleThreadedUpdateRunningAtATime=true;
    positionShift = 100000000;
    tierCreation=1;
    [self setUpTimer];
    [super viewDidLoad];
    live = false;
    unitCreation=1;
    commentSegueList=[[NSMutableArray alloc]init];
    
    NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bubble1" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SoundURL, &playSoundID);
    
    
        tierValue =1;

    chosenState2 = false;
    unit  = 0;
    counter = 0;
    highestID = 0;
    labelHeight = 100;
    labelWidth = 100;

    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    self.view.userInteractionEnabled = YES;
    CellClassList = [[NSMutableArray alloc]init];
    NodeList = [[NSMutableArray alloc]init];
    uILabel = [[UILabel alloc]init];
    NodeClassList = [[NSMutableArray alloc]init];
    CommentClassList = [[NSMutableArray alloc]init];
    likeList = [[NSMutableArray alloc]init];
    uITextView = [[UITextView alloc]init];
    CommentList=[[NSMutableArray alloc]init];
    NodedClassList = [[NSMutableArray alloc]init];
    CommentCheckingForSegueList=[[NSMutableArray alloc]init];
    PollList =[[NSMutableArray alloc]init];
    PollClassList =[[NSMutableArray alloc]init];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_topic forKey:@"currentTopic"];
    bubbleColor = [defaults objectForKey:@"bubbleColor"];
    colorReset=colorHolder = [self colorWithHexString:bubbleColor];
    NSString *username = [defaults objectForKey:@"username"];
    [defaults synchronize];
    _userName = username;
    ;

    contentSize = self.view.frame.size;
    contentSize.height *= 1;
    contentSize.width *= 1;
    
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
    uITextView.userInteractionEnabled = NO;
    uILabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(detectHold:)];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detectSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTap:)];
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.numberOfTapsRequired = 2;
    hold.minimumPressDuration = .6;
    
    [scrollView addGestureRecognizer:doubleTap];
    [scrollView addGestureRecognizer:singleTap];
    [scrollView addGestureRecognizer:hold];
    [self.view addSubview:scrollView];

    [self adjustDynamicScrollViewContent];
    contentSize = self.view.frame.size;
    //contentSize.height =  [self unitNumberToLocation:unit].y ;
    contentSize.width *= 1;
    //[scrollView setContentSize:contentSize];
    
    
    textField = [[UITextView alloc] initWithFrame:CGRectMake(0, -200 , 10 , 10)];
    textField.font = [UIFont systemFontOfSize:12.0];
    textField.textColor = [UIColor blackColor];
    textField.autocorrectionType = UITextAutocorrectionTypeYes;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.userInteractionEnabled = NO;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.backgroundColor = [UIColor whiteColor];
    textField.backgroundColor =[self colorWithHexString: bubbleColor];
    textField.layer.cornerRadius = labelWidth/2;
    textField.layer.masksToBounds = YES;
    [self.view addSubview:textField];
    

    
    
    self.RegularChatBubbleDesc.alpha=0;
    self.RegularChatBubbleDesc.userInteractionEnabled=NO;
    [self.view bringSubviewToFront:self.RegularChatBubbleDesc];
    
    
    self.purpleVoteBubble.alpha = 0;
    self.purpleVoteBubble.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:self.purpleVoteBubble];
    
    self.GreenBubble.alpha = 0;
    self.GreenBubble.userInteractionEnabled = NO;
    [self.view bringSubviewToFront:self.GreenBubble];
    [self.view bringSubviewToFront:self.BlueBubble];
    
    self.naviBar.title =[self.topic stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    textContentSizeCalculator = [[UITextView alloc]init];

    [textField addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];

    initialTextfieldFrame = textField.frame;
    
    
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
//    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
//    [parser setDelegate:self];
//    [parser setShouldResolveExternalEntities:NO];
//    [parser parse];
//    [self updateNodesInScene];
//    [self updateCommentsInScene];
//    
    
 
}
-(void)buttonMethod{
    [self shouldPerformSegueWithIdentifier:@"backButton" sender:self];
}
#pragma mark - GESTURE RECOGNIZERS

-(void)detectSingleTap:(UIGestureRecognizer *)tapRec{
    __block CGPoint location =[tapRec locationInView:tapRec.view];
    if(tierCreation==3){
        [pollOption1 removeFromSuperview];
        [pollOption2 removeFromSuperview];
    }
    
    tierValue = 1;
    NSLog(@"singletap");
    [textField resignFirstResponder];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        CGPoint labelCenter;
        double maxDistance = labelWidth/5;
        double actualDistance;
        for(NSString * comment in commentSegueList){
            
            int uniTT = [comment intValue];
            //UILabel * commentSegue = comment[@""];
            CGFloat xLoc;
            CGFloat yLoc;
            
            if(uniTT%2){
                xLoc = self.view.frame.size.width-labelWidth+labelWidth/5+labelWidth/4;
                yLoc = [self unitNumberToLocation:uniTT].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8+labelWidth/3;
            }
            else{
                xLoc = 3*labelWidth/7+25;
                yLoc = [self unitNumberToLocation:uniTT].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8 +labelWidth/3 ;
            }
            CGPoint position;//
            //position=CGPointMake(commentSegue.frame.origin.x+commentSegue.frame.size.width/2, commentSegue.frame.origin.y-commentSegue.frame.size.height/2);
//            if ([comment[@"Comments"] intValue]<4){
//                if([comment[@"unit"]intValue] % 2){
//                    position=CGPointMake(contentSize.width - 110, [self unitNumberToLocation:[comment[@"unit"] intValue]].y - 90 + ([comment[@"Comments"] intValue]-1)*40 + 15*[comment[@"Comments"] intValue]- AdjustmentInitialFactor);
//                }
//                else{
//                    position=CGPointMake(10, [self unitNumberToLocation:[comment[@"unit"] intValue] ].y - 90 + ([comment[@"Comments"] intValue]-1)*40 + 15*[comment[@"Comments"] intValue] - AdjustmentInitialFactor);
//                }
//            }
            
           // position = CGPointMake(self.view.frame.size.width-labelWidth+labelWidth/5 + 5, [self unitNumberToLocation:[comment[@"unit"] intValue]].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8);
            position = CGPointMake(xLoc, yLoc);
            
                //CGPoint position = [self unitNumberToLocation:comment[@"unit"]] ;
                labelCenter = CGPointMake(position.x, position.y);
                
                actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y - labelCenter.y)*(location.y - labelCenter.y));
            
            
            NSLog(@"actual:::%f",actualDistance);
            NSLog(@"max ::: %f",maxDistance);
            
                if (maxDistance>actualDistance){
                    
                    NSLog(@"SINGLE TAP IS IN NODE");
                    
                    thrownUnitForCommentPageSelection=[comment intValue];
                 ;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"taking care of businneeeessssssss");
                        [self performSegueWithIdentifier:@"ToTheCommentPage" sender:self];
                        
                    });
                    break;
                }
            
        }
    
        
    });
    
    
    
    //[self.textFieldfromView resignFirstResponder];
    //[self TapIsInBackButton:touchLoc];
}
-(void)detectHold:(UIGestureRecognizer *)tapRec{
    if (tapRec.state == UIGestureRecognizerStateBegan){
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];
        startCreation=touchLoc;
        [self HoldIsInNode:touchLoc];
        
    }
    
    
}
-(void)detectTap:(UITapGestureRecognizer *)tapRec{
    CGPoint touchLoc =[tapRec locationInView:tapRec.view];

    _start = touchLoc;
    [self TapsIsInNode:touchLoc];



}
-(void)HoldIsInNode:(CGPoint)location{
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
            CGPoint labelCenter;
    double maxDistance = labelWidth/2+10;
    double actualDistance;
    for(Node* node in NodeClassList){
        if(node.tier == 1){
        
        CGPoint position = node.location;
        labelCenter = CGPointMake(position.x, position.y);
        
        actualDistance = sqrt((location.x - labelCenter.x)*(location.x - labelCenter.x) + (location.y - labelCenter.y)*(location.y - labelCenter.y));
        if (maxDistance>actualDistance){
            
            NSLog(@"HoldIsInNode");
            
            creatingNode = node;
            startCreation = location;
            tierCreation = 2;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                tierCreation = 2;
                [textField becomeFirstResponder];
                
            });
            
            
            
            
            
            
        }
        }
    }
        }
            
            );

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
    //for (Node *node in NodeClassList){
       // if (node.unit > unit){
       //     unit = node.unit;
        //}
//        if (highestID == 2147483647) {
//            NSLog(@"error somewhere in code with highest int");
//            highestID=0;


}
-(void)updateHighestID{
//    //counter = 0;
//    //int counted= 0;
//    if ([NodeList count]>0) {
//        
//    
//    for (NSMutableDictionary *keyValue in NodeList){
//        if ([keyValue[@"id"] intValue] > counter) {
//            
//            counter = [keyValue[@"id"] intValue];
//        }
//    }
//}x
//    highestID = counter;
}

-(void)postToScene:(CGPoint)location{
    CGPoint positionHolder;
    

    //self.scene.contentOffset;
    chosenState = true;
    positionHolder.x =  location.x;
    positionHolder.y = location.y;
    UITextView *labelNode = [self LabelGenerator:location];
    uITextView = labelNode;
    //CGRect frame = uILabel.frame;
    uITextView.frame = CGRectMake(uITextView.frame.origin.x, uITextView.frame.origin.y, 0, 0);
    
 
    
    unitUpdate = [NSMutableString stringWithFormat:@"%d",unit];
    predxPosition = [NSMutableString stringWithFormat:@"%f",_start.x];
    predyPosition = [NSMutableString stringWithFormat:@"%f", _start.y];
    xPosition = [NSMutableString stringWithFormat:@"%f",_end.x];
    yPosition = [NSMutableString stringWithFormat:@"%f", _end.y];
    Comments = [NSMutableString stringWithFormat:@"0"];
    Likes = [NSMutableString stringWithFormat:@"0"];
    tier = [NSMutableString stringWithFormat:@"%d",tierValue];
    //[textField becomeFirstResponder];
}

-(void)adjustDynamicScrollViewContent{
    
    [scrollView setContentSize:contentSize];
    
}


-(void)threadedUpdate{
    //live = true;
    if (singleThreadedUpdateRunningAtATime) {
        singleThreadedUpdateRunningAtATime=false;
    
        
        if ([NodeList count]>0) {
            [NodeList removeAllObjects];
        }
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        //NSLog(@"Highest ID :%d",highestID);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
        parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        //[self updateHighestInt];
        
        
        
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self updateNodesInScene];
                [self updateCommentsInScene];
                //[self updatePollsInScene];
                if (initialOffsetFlag) {
                    
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:.5];
                    scrollView.contentOffset = CGPointMake(0,[self unitNumberToLocation:unit+1].y - self.view.frame.size.height - AdjustmentInitialFactor);
                    [UIView commitAnimations];
                    initialOffsetFlag = false;
                }
            });
        colorHolder = colorReset;
        live = true;
    });
    
    
    
    
        singleThreadedUpdateRunningAtATime=true;
    }
    
}
-(void)threadCommentsPreparation{
    
}

-(void)updatedQuery{
    
    [NodeList removeAllObjects];
   // NSLog(@"HighestID::%d",highestID);
   // NSLog(@"topid::%@",_topic);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/update.php?past=%d&topic=%@",highestID,_topic]];
    parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    [self updateHighestID];
    [self updateHighestInt];
    [self updateNodesInScene];
   // [self adjustDynamicScrollViewContent];
    colorHolder = colorReset;
    
}
-(void)updateNodesInScene{

        contentSize = self.view.frame.size;
        contentSize.height =  [self unitNumberToLocation:unit].y+labelHeight*2 - AdjustmentInitialFactor;
        contentSize.width *= 1;
        [scrollView setContentSize:contentSize];
    
    for (NSMutableDictionary *keyValue in NodeList) {
        if (!previousUnit) {
            previousUnit=0;
        }
        if (previousUnit != [keyValue[@"unit"]intValue]) {
            
            
            //AudioServicesPlaySystemSound(playSoundID);

            if (AdjustmentFlag) {
                AdjustmentInitialFactor =[keyValue[@"yPosition"] intValue]-labelHeight;
                firstUnitSetup = [keyValue[@"unit"] intValue];
                initialOffsetFlag = true;
                AdjustmentFlag=false;
               // NSLog(@"first unit setup %d",firstUnitSetup);
            }
        
        _end.x = [keyValue[@"xPosition"] intValue];
        _end.y = [keyValue[@"yPosition"] intValue]- AdjustmentInitialFactor;
        _start.x = [keyValue[@"predxPosition"] intValue];
        _start.y = [keyValue[@"predyPosition"] intValue]- AdjustmentInitialFactor;
            if ([keyValue[@"unit"] intValue]==1) {
                _start = [self unitNumberToLocation:[keyValue[@"unit"]intValue]];
                _start.y = _start.y-AdjustmentInitialFactor;
            }
            else{
                _start = [self unitNumberToLocation:[keyValue[@"unit"] intValue]-1];
                _start.y=_start.y-AdjustmentInitialFactor;

            }
            
        __block NSString * newText = keyValue[@"message"];
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_sync(queue, ^{
                
        newText = [newText stringByReplacingOccurrencesOfString:@":smile:" withString:@"😄"];
        newText = [newText stringByReplacingOccurrencesOfString:@":angel:" withString:@"👼"];
        newText = [newText stringByReplacingOccurrencesOfString:@":sleepy:" withString:@"😴"];
            });

        
        int heightAdjust;
        
        messageUpdate = [NSMutableString stringWithFormat:@"%@",newText];
        userUpdate = keyValue[@"username"];
        Node *node = [[Node alloc]init];
        node.user = userUpdate;
        phoneNumberForProfileCreation = keyValue[@"phoneNumber"];
        node.tier = [keyValue[@"tier"] intValue];
        node.text = newText;
        node.numberOfComments = [keyValue[@"Comments"]intValue];
        node.likes = [keyValue[@"Likes"]intValue];
        previousUnit = node.unit = [keyValue[@"unit"] intValue];
        node.ID = [keyValue[@"id"] intValue];
            node.location = CGPointMake([self unitNumberToLocation:node.unit].x, [self unitNumberToLocation:node.unit].y-AdjustmentInitialFactor);
        node.color = [self colorWithHexString:keyValue[@"color"]];
        node.pathColor = [self colorWithHexString:keyValue[@"pathColor"]];
        node.pathStyle = keyValue[@"pathStyle"];
        colorHolder = [self colorWithHexString:keyValue[@"color"]];
        heightAdjust =updatingContentHeight = [keyValue[@"contentHeight"] integerValue];
        unit = node.unit;
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
       
        /// -----------------Conditional----------------------------------------------------------------------------------///////
        
        
        if(heightAdjust<labelHeight){
           heightAdjust=labelHeight;
        }
        
        
        
        
        if (node.tier==1){

            
            uITextViewUNIS = [self LabelGenerator:node.location];
            [uITextViewUNIS setFrame:CGRectMake(uITextViewUNIS.frame.origin.x, uITextViewUNIS.frame.origin.y-(-uITextViewUNIS.frame.size.height+heightAdjust)/2, uITextViewUNIS.frame.size.width, heightAdjust)];
            uITextViewUNIS.text = newText;
            uITextViewUNIS.layer.cornerRadius = labelWidth/(2);
            uITextViewUNIS.editable = NO;

            uITextViewUNIS.userInteractionEnabled = NO;
    
            [self addProfilePhoto:node.location heightAdjustment:(uITextViewUNIS.frame.size.height-labelHeight)/2 unit:node.unit];
            [self pathGenerator:node.pathColor style:node.pathStyle];
            if(live){
                CGRect frame = uITextViewUNIS.frame;
                uITextView.frame = CGRectMake(uITextViewUNIS.frame.origin.x+labelWidth/2, uITextViewUNIS.frame.origin.y-labelHeight/2, 0, 0);
                uITextViewUNIS.alpha = 0;
                [scrollView addSubview:uITextViewUNIS];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                uITextViewUNIS.alpha = 1;
                uITextViewUNIS.frame = frame;
                [UIView commitAnimations];
                [NSTimer timerWithTimeInterval:.5 target:self selector:@selector(playAudio) userInfo:nil repeats:NO];
                //[self playAudio];

            }
            else{
                [scrollView addSubview:uITextViewUNIS];
            }
          
            
            //AudioServicesPlaySystemSound(playSoundID);
            NSAttributedString *aString = [[ NSAttributedString alloc]initWithString:uITextViewUNIS.text];
            
            if (uITextViewUNIS.frame.size.height == labelHeight) {
                                uITextViewUNIS.contentOffset = CGPointMake(0,[self textViewHeightForAttributedText:aString andWidth:(labelWidth*1.0)]);
                CGFloat topoffset = ([uITextViewUNIS bounds].size.height - [uITextViewUNIS contentSize].height * [uITextViewUNIS zoomScale])/2.0;
                topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );

                if([self textViewHeightForAttributedText:aString andWidth:(labelWidth*1.0)]==30){
                            uITextViewUNIS.contentInset = UIEdgeInsetsMake([self textViewHeightForAttributedText:aString andWidth:(labelWidth*1.0)], 0.0, 0.0, 0.0);
                }
                else{
                    uITextViewUNIS.contentInset = UIEdgeInsetsMake(80-[self textViewHeightForAttributedText:aString andWidth:(labelWidth*1.0)], 0.0, 0.0, 0.0);
                }
            }
            else {
               // uITextViewUNIS.contentInset = UIEdgeInsetsZero;
                uITextViewUNIS.layer.cornerRadius = 10;
            }
//            if (uITextViewUNIS.contentSize.height > uITextViewUNIS.font.lineHeight*3 && uITextViewUNIS.contentSize.height<40) {
//               uITextViewUNIS.layer.cornerRadius = labelWidth/3;
//            }
            [scrollView addSubview:[self userNameLabelGenerator:_end forString:userUpdate adjustmentFactor:(uITextViewUNIS.frame.size.height-labelHeight)/2]];
            [NodeClassList addObject:node];
        

        }
        else if(node.tier==3){
            

            }
        }
        
    }
}


-(void)updateCommentsInScene{
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
   // dispatch_sync(queue, ^{
    
    
//somewhere i haveto update the NodedClassList comments i have noidea where this is happening rn, has to be in here
    
    
    if (!live) {
        //live=true;
        
        NSLog(@"********NOT LIVE UPLOAD**********");
       // for(__block NSMutableDictionary *Noded in NodedClassList){
        scrollView.userInteractionEnabled=YES;
        if ([NodedClassList count] > 0) {
            
            NSMutableDictionary *Noded = [NodedClassList objectAtIndex:0];
            firstUnitSetup = [Noded[@"unit"] intValue];

            NSInteger unitHolder = firstUnitSetup;
            NSInteger numberOfComments = [[Noded objectForKey:@"Comments"]integerValue];
            //Noded objectForKey:
           // NSLog(@" numberOfComments:%ld For Unit:%ld",(long)numberOfComments,unitHolder);
            NSString *topic = self.topic;
            
            if (numberOfComments<4) {
                
            //Noded is used to help reparse the list and not conflict with NodeClassList in threads
                dispatch_sync(queue, ^{
                    
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateComments.php?unit=%ld&topic=%@&numberOfComments=%ld",(long)unitHolder,topic,(long)numberOfComments]];
                        parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
                        [parser setDelegate:self];
                        [parser setShouldResolveExternalEntities:NO];
                        [parser parse];
                
                                });

                
        
    // First Check if they are getting added to the CommentList correctly
    //If they are then come here and go line by line and figure this shit out
                
                for (__block NSMutableDictionary *Comment in CommentList) {
                   
                    __block int unitHeld = [Comment[@"unit"] intValue];
                    __block NSInteger numberComment = [Comment[@"Comments"] integerValue];
                    __block NSString * newText = Comment[@"message"];
                    __block BOOL newCommentVerification=true;
                    
                    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_sync(queue, ^{
                        
                   
                    if(unitHolder == unitHeld){
                                [Noded setObject:[NSString stringWithFormat:@"%ld",numberOfComments+1] forKey:@"Comments"];
                        
                    }
                    

                    
//                    for (NSMutableDictionary *commentClass in CommentClassList) {
//                       if ([commentClass[@"unit"] intValue]==unitHeld) {
//                           if ([commentClass[@"Comments"] isEqualToString:Comment[@"Comments"]]){
//                               newCommentVerification=false;
//                           }
//                           // [newCommentCheckingArray addObject:commentClass];
//                       }
//                    }
                     });
                    newCommentVerification = true;
                    if (newCommentVerification) {
                        
                    
//                    NSLog(@"unit:%d",unitHeld);
//                    NSLog(@"numberComment:%ld",(long)numberComment);
                        dispatch_sync(queue, ^{
                            
                       
                        
                    newText = [newText stringByReplacingOccurrencesOfString:@":smile:" withString:@"😄"];
                    newText = [newText stringByReplacingOccurrencesOfString:@":angel:" withString:@"👼"];
                    newText = [newText stringByReplacingOccurrencesOfString:@":sleepy:" withString:@"😴"];
                         });
                        if ([newText length]>30) {
                            newText=[newText substringWithRange:NSMakeRange(0, 30)];
                            newText=[newText stringByAppendingString:@"...."];
                        }
                    
                    if (numberComment<4){
                        if(unitHeld % 2){
                         commentTextView=   [[UITextView alloc]initWithFrame:CGRectMake(contentSize.width - 110, [self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
                        }
                        else{
                          commentTextView=  [[UITextView alloc]initWithFrame:CGRectMake( 10, [self unitNumberToLocation:unitHeld ].y-AdjustmentInitialFactor - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
                        }
                    }

                    UITextView *label = commentTextView;
                    label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
                    label.text = newText;
                    label.userInteractionEnabled=NO;
                    label.editable=NO;
                    label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
                    label.layer.cornerRadius=10;
                    label.layer.masksToBounds=YES;
                    label.textAlignment = NSTextAlignmentCenter;
                    
                    if (numberComment == 1) {
                        //Adding Brackets Appropriately
                        if(unitHeld % 2){
                            UILabel *enclosingBracket = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth,[self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor - labelHeight/4, 20, 50)];
                            enclosingBracket.text = @"{";
                            enclosingBracket.font = [UIFont fontWithName:@"NexaLight" size:28];
                            enclosingBracket.textColor = [UIColor orangeColor];
                            [scrollView addSubview:enclosingBracket];
                        }
                        else{
                            UILabel *enclosingBracket = [[UILabel alloc]initWithFrame:CGRectMake(contentSize.width - labelWidth - 13,[self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor - labelHeight/4, 20, 50)];
                            enclosingBracket.text = @"}";
                            enclosingBracket.textColor = [UIColor orangeColor];
                            enclosingBracket.font = [UIFont fontWithName:@"NexaLight" size:28];
                            [scrollView addSubview:enclosingBracket];
                        }
                        
                    }
                    else if (numberComment == 3){
                        if(unitHeld %2){
                            UILabel *commentSegueButton = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-labelWidth+labelWidth/5 , [self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8, 50, 20)];
                            commentSegueButton.text = @"...";
                            commentSegueButton.font =[UIFont fontWithName:@"NexaBold" size:40];
                            commentSegueButton.textColor = [UIColor grayColor];
                            commentSegueButton.textAlignment = NSTextAlignmentCenter;
                            [scrollView addSubview:commentSegueButton];

                            [commentSegueList addObject:[NSString stringWithFormat:@"%d",unitHeld]];
                    
                        }else{
                            UILabel *commentSegueButton = [[UILabel alloc]initWithFrame:CGRectMake(3*labelWidth/7-5, [self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8, 50, 20)];
                            commentSegueButton.text = @"...";
                            commentSegueButton.font =[UIFont fontWithName:@"NexaBold" size:40];
                            commentSegueButton.textColor = [UIColor grayColor];
                            commentSegueButton.textAlignment = NSTextAlignmentCenter;
                            [scrollView addSubview:commentSegueButton];
                            
                            [commentSegueList addObject:[NSString stringWithFormat:@"%d",unitHeld]];

                        }
                        
                        
                        }
                    
                    
                    
                    
                        CGRect frame = label.frame;
                        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 0, 0);
                        
                        
      //                 dispatch_sync(dispatch_get_main_queue(), ^{
                            
                            
                            

                        label.alpha = 0;
                        [scrollView addSubview:label];
                        //Add Animations
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:.5];
                        label.alpha = 1;
                        label.frame = frame;
                        
                        
                        [UIView commitAnimations];
                        [scrollView addSubview:  [self userNameLabelGenerator:CGPointMake( label.frame.origin.x,label.frame.origin.y) forString:Comment[@"username"] adjustmentFactor:-labelHeight/2]];
                    
                    
                        [CommentClassList addObject:Comment];
                    
////                    for (Node *nodeHolder in NodeClassList){
////                        if (nodeHolder.unit == unitHeld){
////                            if (nodeHolder.numberOfComments<numberComment) {
////                                    nodeHolder.numberOfComments =  numberComment;
////
////                            }
////                        }
//                    }
       //                                     });
                }
    }
//});
     //       }
            }
            if ([CommentList count]>0) {
                
            
                [CommentList removeAllObjects];
            }
        }

    }
    else{
        
        __block NSString *topic = self.topic;

        NSLog(@"******** LIVE UPLOAD**********");

        dispatch_sync(queue, ^{
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updateCommentsMidscene.php?highestInt=%ld&topic=%@",(long)commentUpdateInt,topic]];
            parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];
            
        });
        
        
        
        // First Check if they are getting added to the CommentList correctly
        //If they are then come here and go line by line and figure this shit out
        
        for (__block NSMutableDictionary *Comment in CommentList) {
            
            __block int unitHeld = [Comment[@"unit"] intValue];
            __block int commentID = [Comment[@"identifier"] intValue];
            __block NSInteger numberComment = [Comment[@"Comments"] integerValue];
            __block NSString * newText = Comment[@"message"];
            __block BOOL newCommentVerification=true;
            if (commentID>commentUpdateInt){
                commentUpdateInt = commentID;
            }
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_sync(queue, ^{
                
                

                
                
                
                for (NSMutableDictionary *commentClass in CommentClassList) {
                    if ([commentClass[@"unit"] intValue]==unitHeld) {
                        if ([commentClass[@"Comments"] isEqualToString:Comment[@"Comments"]]){
                            newCommentVerification=false;
                        }
                        // [newCommentCheckingArray addObject:commentClass];
                    }
                }
            });
            if (newCommentVerification) {
                
                
//                NSLog(@"unit:%d",unitHeld);
//                NSLog(@"numberComment:%ld",(long)numberComment);
                dispatch_sync(queue, ^{
                    
                    
                    
                    newText = [newText stringByReplacingOccurrencesOfString:@":smile:" withString:@"😄"];
                    newText = [newText stringByReplacingOccurrencesOfString:@":angel:" withString:@"👼"];
                    newText = [newText stringByReplacingOccurrencesOfString:@":sleepy:" withString:@"😴"];
                    
                    
                    
                });
                if ([newText length]>30) {
                    newText=[newText substringWithRange:NSMakeRange(0, 30)];
                    newText=[newText stringByAppendingString:@"...."];
                }
                
                if (numberComment<4){
                    if(unitHeld % 2){
                        commentTextView=   [[UITextView alloc]initWithFrame:CGRectMake(contentSize.width - 110, [self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
                    }
                    else{
                        commentTextView=  [[UITextView alloc]initWithFrame:CGRectMake( 10, [self unitNumberToLocation:unitHeld ].y-AdjustmentInitialFactor - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
                    }
                }
                
                UITextView *label = commentTextView;
                label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
                label.text = newText;
                label.userInteractionEnabled=NO;
                label.editable=NO;
                label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
                label.layer.cornerRadius=10;
                label.layer.masksToBounds=YES;
                label.textAlignment = NSTextAlignmentCenter;
                
                if (numberComment == 1) {
                    //Adding Brackets Appropriately
                    if(unitHeld % 2){
                        UILabel *enclosingBracket = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth,[self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor - labelHeight/4, 20, 50)];
                        enclosingBracket.text = @"{";
                        enclosingBracket.font = [UIFont fontWithName:@"NexaLight" size:28];
                        enclosingBracket.textColor = [UIColor orangeColor];
                        [scrollView addSubview:enclosingBracket];
                    }
                    else{
                        UILabel *enclosingBracket = [[UILabel alloc]initWithFrame:CGRectMake(contentSize.width - labelWidth - 13,[self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor - labelHeight/4, 20, 50)];
                        enclosingBracket.text = @"}";
                        enclosingBracket.textColor = [UIColor orangeColor];
                        enclosingBracket.font = [UIFont fontWithName:@"NexaLight" size:28];
                        [scrollView addSubview:enclosingBracket];
                    }
                    
                }
                else if (numberComment == 3){
                    if(unitHeld %2){
                        UILabel *commentSegueButton = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-labelWidth+labelWidth/5 , [self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8, 50, 20)];
                        commentSegueButton.text = @"...";
                        commentSegueButton.font =[UIFont fontWithName:@"NexaBold" size:40];
                        commentSegueButton.textColor = [UIColor grayColor];
                        commentSegueButton.textAlignment = NSTextAlignmentCenter;
                        [scrollView addSubview:commentSegueButton];
                        
                        [commentSegueList addObject:[NSString stringWithFormat:@"%d",unitHeld]];
                        
                    }else{
                        UILabel *commentSegueButton = [[UILabel alloc]initWithFrame:CGRectMake(3*labelWidth/7-5, [self unitNumberToLocation:unitHeld].y - AdjustmentInitialFactor+labelHeight-labelHeight/5-labelHeight/8, 50, 20)];
                        commentSegueButton.text = @"...";
                        commentSegueButton.font =[UIFont fontWithName:@"NexaBold" size:40];
                        commentSegueButton.textColor = [UIColor grayColor];
                        commentSegueButton.textAlignment = NSTextAlignmentCenter;
                        [scrollView addSubview:commentSegueButton];
                        
                        [commentSegueList addObject:[NSString stringWithFormat:@"%d",unitHeld]];
                        
                    }
                    
                    
                }
                
                
                
                
                CGRect frame = label.frame;
                label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 0, 0);
                
                
                //                 dispatch_sync(dispatch_get_main_queue(), ^{
                
                
                
                
                label.alpha = 0;
                [scrollView addSubview:label];
                //Add Animations
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:.5];
                label.alpha = 1;
                label.frame = frame;
                
                
                [UIView commitAnimations];
                [scrollView addSubview:  [self userNameLabelGenerator:CGPointMake( label.frame.origin.x,label.frame.origin.y) forString:Comment[@"username"] adjustmentFactor:-labelHeight/2]];
                
                
                [CommentClassList addObject:Comment];
                
                for (Node *nodeHolder in NodeClassList){
                    if (nodeHolder.unit == unitHeld){
                        if (nodeHolder.numberOfComments<numberComment) {
                            nodeHolder.numberOfComments =  numberComment;
                            
                        }
                    }
                }
                
                //                                     });
                
            }
            
            
        }
        
        
        
        
        
    }
    
    
    }

-(void)updatePollsInScene{
    
    if(1>5){
        NSLog(@"*************** POLL LIVE UPLOAD ***************");
     for (NSMutableDictionary *poll in PollList){
         int pollUnit = [poll[@"unit"] intValue];
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updatePollMidScene.php?topic=%@&unit=%d",self.topic,pollUnit]];
        parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        
    });
    
    
    
           NSString *pollQuestion;
        NSString *option1;
        NSString *option2;
        UIButton *poLLOption1 = [[UIButton alloc]init];
        UIButton *poLLOption2 = [[UIButton alloc] init];
        pollQuestion = poll[@"Message"];
        option1 = poll[@"option1"];
        option2 = poll[@"option2"];         
         
         
        [poLLOption1 setTitle:option1 forState:UIControlStateNormal];
        [poLLOption2 setTitle:option2 forState:UIControlStateNormal];

       // int pollUnit = [poll[@"unit"]intValue];
        [poLLOption1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [poLLOption2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        poLLOption2.backgroundColor=poLLOption1.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:153.0/255.0 blue:139.0/255.0 alpha:1];
        //poLLOption1.textAlignment = poLLOption2.textAlignment = NSTextAlignmentCenter;
        [poLLOption1 setFrame:CGRectMake(self.view.frame.size.width/4, [self unitNumberToLocation:pollUnit].y - AdjustmentInitialFactor - labelHeight, labelWidth/1.3, labelHeight/1.3)];
        [poLLOption2 setFrame:CGRectMake(self.view.frame.size.width/2, [self unitNumberToLocation:pollUnit].y - AdjustmentInitialFactor - labelHeight, labelWidth/1.3, labelHeight/1.3)];
        poLLOption1.alpha=poLLOption2.alpha=0;
        
         poLLOption1.layer.cornerRadius=poLLOption2.layer.cornerRadius = 20;
         poLLOption2.layer.masksToBounds = poLLOption1.layer.masksToBounds=YES;
       // poLLOption2.layer.cornerRadius = poLLOption1.layer.cornerRadius = pollOption1.frame.size.width/2;
         
         
         
        [scrollView addSubview:poLLOption1];
        [scrollView addSubview:poLLOption2];
         
         
         
         poLLOption2.userInteractionEnabled = poLLOption1.userInteractionEnabled = YES;
         [scrollView bringSubviewToFront:poLLOption1];
         [scrollView bringSubviewToFront:poLLOption2];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        //[textField setFrame:CGRectMake(self.view.frame.size.width/2 - labelWidth, self.view.frame.size.height/7, labelWidth*2, labelHeight/1.5)];
        //textField.layer.cornerRadius = 10;
        poLLOption1.alpha=poLLOption2.alpha=1;
        
        [UIView commitAnimations];
        
        
    }
    
        
        
        
        
    }
    else{
        NSLog(@"*************** POLL DEAD UPLOAD ***************");

        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(queue, ^{
           // int pollUnit=unit;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/updatePoll.php?topic=%@&unit=%d",self.topic,firstUnitSetup]];
            parser=[[NSXMLParser alloc] initWithContentsOfURL:url];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:NO];
            [parser parse];
            NSLog(@"Poll Query is being run");
        });
        
        for (NSMutableDictionary *poll in PollList) {
            
        
        
        NSString *pollQuestion;
        NSString *option1;
        NSString *option2;
        UIButton *poLLOption1 = [[UIButton alloc]init];
        UIButton *poLLOption2 = [[UIButton alloc] init];
        pollQuestion = poll[@"Message"];
        option1 = poll[@"option1"];
        option2 = poll[@"option2"];            
        int pollUnit = [poll[@"unit"]intValue];

        
        [poLLOption1 setTitle:option1 forState:UIControlStateNormal];
        [poLLOption2 setTitle:option2 forState:UIControlStateNormal];
            UITextView *pollQuestionTextView = [[UITextView alloc]init];
            pollQuestionTextView = [self LabelGenerator:[self unitNumberToLocation:pollUnit]];
            pollQuestionTextView.backgroundColor = [UIColor greenColor];
            pollQuestionTextView.text = pollQuestion;
            pollQuestionTextView.font = [UIFont fontWithName:@"Nexa Light" size:12];
           // pollQuestionTextView = [self unitNumberToLocation:pollUnit];
            
            

        [poLLOption1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [poLLOption2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        poLLOption2.backgroundColor=poLLOption1.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:153.0/255.0 blue:139.0/255.0 alpha:1];
        //poLLOption1.textAlignment = poLLOption2.textAlignment = NSTextAlignmentCenter;
        [poLLOption1 setFrame:CGRectMake(self.view.frame.size.width/4, [self unitNumberToLocation:pollUnit].y - AdjustmentInitialFactor - labelHeight, labelWidth/1.3, labelHeight/1.3)];
        [poLLOption2 setFrame:CGRectMake(self.view.frame.size.width/2, [self unitNumberToLocation:pollUnit].y - AdjustmentInitialFactor - labelHeight, labelWidth/1.3, labelHeight/1.3)];
        poLLOption1.alpha=poLLOption2.alpha=1;
        poLLOption1.layer.cornerRadius=poLLOption2.layer.cornerRadius = 20;
        poLLOption2.layer.masksToBounds = poLLOption1.layer.masksToBounds=YES;
            poLLOption2.userInteractionEnabled = poLLOption1.userInteractionEnabled = YES;
            
        [scrollView addSubview:poLLOption1];
        [scrollView addSubview:poLLOption2]; 
        [scrollView addSubview:pollQuestionTextView];
        [scrollView bringSubviewToFront:poLLOption1];
        [scrollView bringSubviewToFront:poLLOption2];
        
        //poLLOption2.layer.cornerRadius = poLLOption1.layer.cornerRadius = pollOption1.frame.size.width/2;


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
-(UITextView *)LabelGenerator:(CGPoint)location{
    UITextView *label = [[UITextView alloc]initWithFrame:CGRectMake(location.x - labelWidth/2, location.y-labelHeight/2, labelWidth, labelHeight)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = colorHolder;
    //label.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
    //label.numberOfLines = 0;
    
    //tweaked
    label.editable = NO;
    label.layer.cornerRadius = labelWidth/2;
    label.layer.masksToBounds = YES;
    //label.lineBreakMode = NSLineBreakByWordWrapping;
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
                             forString:(NSString *)currentUser
                  adjustmentFactor:(CGFloat)adjustmentFactor{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(location.x-10 , location.y - labelHeight/2 - 15-adjustmentFactor, 100, 10)];
    label.text = currentUser;
    label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
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
        pathAnimation.duration = 1.0f;
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
            pathAnimation.duration = 2.0f;
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
-(UITextView *)createComment:(CGPoint)location{
    UITextView * label = [[UITextView alloc]initWithFrame:CGRectMake(location.x, location.y , 100, 40)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
    //label.backgroundColor = [UIColor colorWithRed:115.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
    //label.numberOfLines = 0;
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
   // label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
    return  label;
}
-(void)commentGenerator:(CGPoint)location
                        commentNumber:(int)numberComment{
   // if (numberComment<4){
    if(currentNode.unit % 2){
        UITextView * label = [[UITextView alloc]initWithFrame:CGRectMake(contentSize.width - 110, creatingNode.location.y - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];
        uITextView = label;
        unitCreation = creatingNode.unit;
        endCreation = label.frame.origin;
    }
    else{
        UITextView * label = [[UITextView alloc]initWithFrame:CGRectMake( 10, creatingNode.location.y - 90 + (numberComment-1)*40 + 15*numberComment, 100, 40)];

        label.font = [UIFont fontWithName:@"NexaLight" size:12.0];
        uITextView = label;
        unitCreation = creatingNode.unit;
        endCreation = label.frame.origin;
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
    
    NSString *contentString = [NSString stringWithFormat:@"%f",adjustedContentSize];
    NSLog(@"");
    
    
    
    NSString *post = [NSString stringWithFormat:@"&user=%@&message=%@&xPosition=%@&yPosition=%@&predxPosition=%@&predyPosition=%@&topic=%@&unit=%@&numberOfComments=%@&numberOfLikes=%@&tier=%@&color=%@&pathColor=%@&pathStyle=%@&contentHeight=%@",_userName,newText,xPosition,yPosition,predxPosition,predyPosition,_topic,unitUpdate,Comments,Likes,tier,bubbleColor,pathColor,pathStyle,contentString];
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
-(void)createPoll:(NSString *)pollQuestion
        optionUno:(NSString *)option1
       optionDeux:(NSString *)option2{
    
    
    
    // all attributes assigned prior to posttest being called
    
    NSString * newText = [NSString stringWithString:textField.text];
    newText = [newText stringByReplacingOccurrencesOfString:@"😀" withString:@":smile:"];
    newText = [newText stringByReplacingOccurrencesOfString:@"👼" withString:@":angel:"];
    newText = [newText stringByReplacingOccurrencesOfString:@"😴" withString:@":sleepy:"];
    
    
    NSUserDefaults* defaults =[NSUserDefaults standardUserDefaults];
    pathColor = [defaults objectForKey:@"pathColor"];
    pathStyle = [defaults objectForKey:@"pathStyle"];
    
    //FINISH BY ADJUSTING THE PATH ATTTRIBUTES
    
    NSString *contentString = [NSString stringWithFormat:@"%f",adjustedContentSize];
    NSLog(@"");
    
    
    
    NSString *post = [NSString stringWithFormat:@"&user=%@&message=%@&xPosition=%@&yPosition=%@&predxPosition=%@&predyPosition=%@&topic=%@&unit=%@&numberOfComments=%@&numberOfLikes=%@&tier=%@&color=%@&pathColor=%@&pathStyle=%@&contentHeight=%@&poll=%@&option1=%@&option2=%@",_userName,newText,xPosition,yPosition,predxPosition,predyPosition,_topic,unitUpdate,Comments,Likes,tier,bubbleColor,pathColor,pathStyle,contentString,pollQuestion,option1,option2];
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
   // CGFloat zoomScale = [scrolledView zoomScale];
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
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
          UITextView *txtview = object;
    CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
        
        dispatch_async(dispatch_get_main_queue(), ^{
                txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};

            
        });

        
    });
  

}

#pragma mark TextBox


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //[self processReturn];
    return YES;
    
}

-(BOOL)textField:(UITextField *)textedField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    uILabel = [[UILabel alloc]init];
    //uILabel =
    
    
    

    
    
   // NSLog(@"position of the view :%f",self.textFieldView.frame.origin.y);
    //if (self.textFieldView.frame.origin.y != 302) {
        
    
    //self.textFieldView.frame = CGRectMake(self.textFieldView.frame.origin.x, 302, self.textFieldView.frame.size.width, self.textFieldView.frame.size.height);
//}
    
   // uILabel = [[UILabel alloc]init];
    NSString *newString = [textedField.text stringByReplacingCharactersInRange:range withString:string];
    uITextView.text = newString;//edits it live
    
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


#pragma mark TextView helpers
- (void)textViewDidChange:(UITextView *)textView{
    //NSLog(@"%@",textField.text);
    
if (tierCreation==1) {
    if (textField.contentSize.height > textField.font.lineHeight*3 & textField.contentSize.height<textField.frame.size.height) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0 ];
        textField.layer.cornerRadius = labelWidth/3;
        [UIView commitAnimations];
    }
}
       if (textField.contentSize.height>textField.frame.size.height) {
        //CGFloat Addition;
        
        [textField setFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y-(textField.contentSize.height-textField.frame.size.height), textField.frame.size.width, textField.contentSize.height)];
        adjustedContentSize = textField.frame.size.height;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0 ];
        textField.layer.cornerRadius = 10;
        [UIView commitAnimations];
    }
      
        
        

    
   
    
    
    
    

    
    uITextView.text =  textField.text;
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
    //NSLog(@"parser called");
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
        contentHeightUpdate = [[NSMutableString alloc]init];
        phoneNumberUpdate=[[NSMutableString alloc]init];
        option1Update = [[NSMutableString alloc]init];
        option2Update = [[NSMutableString alloc]init];
    }
    
}//define variables to extract info from xml doc
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //search for tags
    //NSLog(@"Step 1");
    if ([element isEqualToString:@"username"]) {
        [userUpdate appendString:string];
       // NSLog(@"username found tier 1");
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
        [item setObject:contentHeightUpdate forKey:@"contentHeight"];
        [item setObject:phoneNumberUpdate forKey:@"phoneNumber"];
        [item setObject:option1Update forKey:@"option1"];
        [item setObject:option2Update forKey:@"option2"];

        if ([tier isEqualToString:@"1"]) {
        // potentially unneccesary
        if (highestID<[identifier intValue]) {
            highestID = [identifier intValue];
        }
            
            
            BOOL test=true;
            for (NSMutableDictionary *nodeholder in NodeList) {
                if (nodeholder[@"unit"] == unitUpdate ) {
                    test=false;
                }
            }
            if(test){
                    [NodeList addObject:[item copy]];//The problem lies in add objects
                 //    NSLog(@"Node Added");
                    [NodedClassList addObject:item];

            }
        }
        else if ([tier isEqualToString:@"2"]){
            if ([Comments intValue] <4){
                [CommentList addObject:item];
                [CommentCheckingForSegueList addObject:item];

//            NSLog(@"Comment Added");
            }
        }
        else if ([tier isEqualToString:@"3"]){
            NSLog(@"********** TIER 3 FOUND ***");
            if (option1Update) {
                NSLog(@"OPTION1 update criteria success");
                    [PollList addObject:item];
                    [PollClassList addObject:item];
            }
        }
    }
}











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
    CGPoint location = CGPointMake(holder, uniT*180);
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
           
            
           // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
           // NSData*imageData = [defaults objectForKey:@"LikeAnimation"];//[defaults objectForKey:@"LikeAnimation"];
            //UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue.jpg"]];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(location.x, location.y, 10, 10)];
            label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"upvote_downvote.png"]];
            label.alpha = 1;
            
            label.text = @"+1";
            label.font = [UIFont fontWithName:@"NexaLight" size:12];
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
    [[NSBundle mainBundle] pathForResource:@"bubble1" ofType:@"wav"];
    [self playSound:@"bubble1" :@"wav"];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self.clearContentView removeObserver:self forKeyPath:@"transform"];
    }
    @catch (NSException *exception) {    }
    @finally {    }
}


-(void)addProfilePhoto:(CGPoint)Location
      heightAdjustment:(CGFloat)heightAdjustmentFactor
                  unit:(int)unitT{

    
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSData *imageData;
    if (!([messageUpdate rangeOfString:@"😄"].location == NSNotFound  )) {
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/happy/emojiPicture.jpg",phoneNumberForProfileCreation]]];

    }
    else if (!([messageUpdate rangeOfString:@"👼"].location == NSNotFound)){
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/angel/emojiPicture.jpg",phoneNumberForProfileCreation]]];

    }
    else if(!([messageUpdate rangeOfString:@"😴"].location == NSNotFound)){
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/sleepy/emojiPicture.jpg",phoneNumberForProfileCreation]]];

    }
    else{
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/profilePic.jpg",phoneNumberForProfileCreation]]];

    }
        
        
        
        if (unitT %2) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Location.x -labelWidth/2, Location.y - labelWidth/2 -30-heightAdjustmentFactor, 40, 40)];
                
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
                    [UIView setAnimationDuration:.75];
                    imageView.alpha = 1;
                    imageView.frame = frame;
                    
                    [UIView commitAnimations];
            
                }
                else{
                    [scrollView addSubview:imageView];
                }
            });
        
        
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(Location.x + labelWidth/2 - 40, Location.y - labelWidth/2-30-heightAdjustmentFactor, 40, 40)];
                
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
            });

            
        }
        
        
    });
 
    

    
    
    
    
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


#pragma mark - XMPP SETUP





-(void)connectToXMPP{
    

}



-(void)setUpTimer{

    // Update the UI 5 times per second on the main queue
//    // Keep a strong reference to _timer in ARC
//    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, (3) * NSEC_PER_SEC, 0.25 * NSEC_PER_SEC);
//    
//    dispatch_source_set_event_handler(timer, ^{
//    });
//    
//    // Start the timer
//    dispatch_resume(timer);
    
//    uiTimer = [NSTimer timerWithTimeInterval:(1/5) target:self selector:@selector(threadedUpdate) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:uiTimer forMode:NSRunLoopCommonModes];
//
    
    

    NSTimer * uTimer = [NSTimer timerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(threadedUpdate)
                                    userInfo:nil
                                            repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:uTimer forMode:NSRunLoopCommonModes];
    
        uiTimer = [NSTimer timerWithTimeInterval:5
                                      target:self
                                    selector:@selector(threadedUpdate)
                                    userInfo:nil
                                     repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:uiTimer forMode:NSRunLoopCommonModes];
    
    
    
    
    
//
    
//        
//    timer = [NSTimer scheduledTimerWithTimeInterval:10.0
//                                     target:self
//                                   selector:@selector(threadedUpdate)
//                                   userInfo:nil
//                                    repeats:YES];      
    

}

















- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"customize"])
    {
      
        
        
        customizeGroup *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",self.topic];

        
    }
    else if ([[segue identifier] isEqualToString:@"ToTheCommentPage"])
    {
        
        
        
        CommentPageTableViewController *vc = [segue destinationViewController];
        //Fix this to go to the table view
        vc.topic = [NSString stringWithFormat:@"%@",self.topic];
        vc.unit = thrownUnitForCommentPageSelection;
        
    }
    
}
- (void)someMethodWhereYouSetUpYourObserver
{
    // This could be in an init method.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationMethod:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardLeft:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSLog(@"Kerboard did show");
    singleThreadedUpdateRunningAtATime=false;

    //textField = [[UITextView alloc]init];
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];

    textField.frame = CGRectMake(self.view.frame.size.width/2 ,self.view.frame.size.height/2, textField.frame.size.width, textField.frame.size.height);
    self.GreenBubble.alpha = 1;
    self.GreenBubble.userInteractionEnabled=YES;
    //uILabel = [self LabelGenerator:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    //[self.view addSubview:uILabel];
    
    
    //UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = self.view.bounds;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.5];
    scrollView.alpha = .3;
    
    
    //[self.view addSubview:visualEffectView];
    //[self.view bringSubviewToFront:visualEffectView];
    
    
    [UIView commitAnimations];
    
    if (tierCreation==1) {
        
        
        
        self.RegularChatBubbleDesc.alpha=1;
        self.RegularChatBubbleDesc.userInteractionEnabled=YES;
        
        self.purpleVoteBubble.alpha = 1;
        self.purpleVoteBubble.userInteractionEnabled = YES;
        
        textField.backgroundColor=[self colorWithHexString:bubbleColor];
        textField.layer.cornerRadius = labelWidth/2;
        textField.font = [UIFont fontWithName:@"Nexa Light" size:12];
        
        [textField setFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:.5];
        [textField setFrame:CGRectMake(self.view.frame.size.width/2-labelWidth/2, self.view.frame.size.height/2-labelHeight, labelWidth, labelHeight)];
        [UIView commitAnimations];
        
    
    
    }
    else if (tierCreation==2){
        
        textField.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
        textField.layer.cornerRadius = 10;
        [textField setFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:.5];
        [textField setFrame:CGRectMake(self.view.frame.size.width/2-labelWidth/2, self.view.frame.size.height/2-labelHeight/2, labelWidth, labelHeight/2)];
        [UIView commitAnimations];
        
        
        
    }


    uITextView = [[UITextView alloc]init];
    
    
    //[UIView commitAnimations];
    
    
    
}
-(void)keyboardLeft:(NSNotification *)notification{
    NSLog(@"keyboardleft");
    


    singleThreadedUpdateRunningAtATime=true;

    self.purpleVoteBubble.userInteractionEnabled=NO;
    self.RegularChatBubbleDesc.userInteractionEnabled=NO;
    self.GreenBubble.userInteractionEnabled = NO;
    textField.frame = initialTextfieldFrame;
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:.2];
    scrollView.alpha = 1;
   // [visualEffectView removeFromSuperview];
    self.purpleVoteBubble.alpha = 0;
    self.RegularChatBubbleDesc.alpha=0;
    self.GreenBubble.alpha = 0;
    [UIView commitAnimations];
    
    tierCreation = 1;
    
}















-(void)createTextfieldView{
    
    
    /*UIView *textFieldView = [[UIView alloc]init];//]WithFrame:CGRectMake(0, self.view.frame.size.height-200, 25, 25)];
    //textFieldView.bounds =CGRectMake(0, self.view.frame.size.height-200, 25, 25);
    //textFieldView.bounds.size = CGSizeMake(self.view.frame.size.width, 100);
    [textFieldView setFrame:CGRectMake(0, self.view.frame.size.height-200, 25, 25)];
    textField.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 100);
    [self.view addSubview:textFieldView];
    [textFieldView addSubview:textField];*/
    
    
    
    
    
    
    
    
}




- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING RECIEVED");
    // Dispose of any resources that can be recreated.
}



- (IBAction)SendTheMessage:(UIButton *)sender {
    singleThreadedUpdateRunningAtATime=true;
    NSLog(@"%d tiercreation value",tierCreation);
    uITextView = [[UITextView alloc]init];
    
    self.GreenBubble.alpha = 0;
    self.GreenBubble.userInteractionEnabled = NO;
    
    
    self.purpleVoteBubble.alpha = 0;
    self.RegularChatBubbleDesc.alpha=0;
    self.purpleVoteBubble.userInteractionEnabled=NO;
    self.RegularChatBubbleDesc.userInteractionEnabled=NO;
    if (adjustedContentSize<textField.frame.size.height){
        adjustedContentSize = labelHeight;
    }
    
    
    
    //textField.frame = initialTextfieldFrame;
    
    
    
    
    if(textField.text){
        
        colorHolderCreation = [self colorWithHexString:bubbleColor];
        startCreation = [self unitNumberToLocation:unit];
        // unit += 1;
        
        
        
        if([NodeClassList count]==0){
            unitCreation = 1;
            startCreation = endCreation = [self unitNumberToLocation:unitCreation];
            
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.5];
            //uILabel.alpha = 1;
            //uILabel.frame = frame;
            
            textField.frame = CGRectMake(self.view.frame.size.width/2 , self.view.frame.size.height/2, 1, 1);
            [UIView commitAnimations];
            //textField.frame = initialTextfieldFrame;
            
            
            
            
            
            //  NSLog(@"first node formed");
            //[self threadedUpdate];
            
            
            
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                
                  _end = [self unitNumberToLocation:unitCreation];
            unitUpdate = [NSMutableString stringWithFormat:@"%d",unitCreation];
            predxPosition = [NSMutableString stringWithFormat:@"%f",startCreation.x];
            predyPosition = [NSMutableString stringWithFormat:@"%f", startCreation.y];
            xPosition = [NSMutableString stringWithFormat:@"%f",endCreation.x];
            yPosition = [NSMutableString stringWithFormat:@"%f", endCreation.y];
            Comments = [NSMutableString stringWithFormat:@"0"];
            Likes = [NSMutableString stringWithFormat:@"0"];
            tier = [NSMutableString stringWithFormat:@"%d",tierCreation];
            
            [self postTest];
                
            
          
            
            
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
            uITextView.text = textField.text;
            textField.text = @"";
            [textField resignFirstResponder];//hides the keyboard
            uiTimer = [NSTimer scheduledTimerWithTimeInterval:.5
                                                     target:self
                                                   selector:@selector(threadedUpdate)
                                                   userInfo:nil
                                                    repeats:NO];
                    
                    
                });
   
            
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                       // scrollView.contentOffset = CGPointMake(0,[self unitNumberToLocation:unit+1].y - self.view.frame.size.height + 300);

                    
                });
            
            
           });
        }
        
        
        
        
        
        
        
        
        
        else if(tierCreation == 1){
            //[self updateHighestID];
            //[self updateHighestInt];
            unit+=1;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.5];

            
            textField.frame = CGRectMake(self.view.frame.size.width/2 , self.view.frame.size.height/2, 1, 1);
            [UIView commitAnimations];
            
            
            
            
           queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                
            endCreation = [self unitNumberToLocation:unit];
            unitUpdate = [NSMutableString stringWithFormat:@"%d",unit];
            predxPosition = [NSMutableString stringWithFormat:@"%f",startCreation.x];
            predyPosition = [NSMutableString stringWithFormat:@"%f", startCreation.y];
            xPosition = [NSMutableString stringWithFormat:@"%f",endCreation.x];
            yPosition = [NSMutableString stringWithFormat:@"%f", endCreation.y];
            Comments = [NSMutableString stringWithFormat:@"0"];
            Likes = [NSMutableString stringWithFormat:@"0"];
            tier = [NSMutableString stringWithFormat:@"%d",tierCreation];
            
            
            [self postTest];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    
             
            
            
            
                                uITextView.text = textField.text;
                                textField.text = @"";
                                [textField resignFirstResponder];//hides the keyboard
                                uiTimer = [NSTimer scheduledTimerWithTimeInterval:.5
                                                     target:self
                                                   selector:@selector(threadedUpdate)
                                                   userInfo:nil
                                                    repeats:NO];
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:.5];
                    if (unit>3) {
                        
                    
                                scrollView.contentOffset = CGPointMake(0,[self unitNumberToLocation:unit+1].y - self.view.frame.size.height - AdjustmentInitialFactor);
                }
                    [UIView commitAnimations];

                });
            });
    }
        else if (tierCreation == 2){
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.5];
            //uILabel.alpha = 1;
            //uILabel.frame = frame;
            
            textField.frame = CGRectMake(self.view.frame.size.width/2 , self.view.frame.size.height/2, 1, 1);
            [UIView commitAnimations];
            
            
            
            
            
            
            
            [self commentGenerator:startCreation commentNumber:creatingNode.numberOfComments ];
            
           creatingNode.numberOfComments+=1;
            
            
            
            
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                
                NSLog(@"creationnode.numberofcomments : %d", creatingNode.numberOfComments);

                tierCreation = 2;
            unitUpdate = [NSMutableString stringWithFormat:@"%d",creatingNode.unit];
            predxPosition = [NSMutableString stringWithFormat:@"%f",startCreation.x];
            predyPosition = [NSMutableString stringWithFormat:@"%f", startCreation.x];
            xPosition = [NSMutableString stringWithFormat:@"%f",endCreation.x];
            yPosition = [NSMutableString stringWithFormat:@"%f", endCreation.y];
            Comments = [NSMutableString stringWithFormat:@"%d",creatingNode.numberOfComments];
            Likes = [NSMutableString stringWithFormat:@"0"];
            tier = [NSMutableString stringWithFormat:@"%d",tierCreation];
            //currentNode.numberOfComments +=1;
            
            [self postTest];
                
                
                dispatch_async(dispatch_get_main_queue(),^{
                            uITextView.text = textField.text;
                            textField.text = @"";
                            [textField resignFirstResponder];//hides the keyboard
                            timer = [NSTimer scheduledTimerWithTimeInterval:.5
                                                     target:self
                                                   selector:@selector(threadedUpdate)
                                                   userInfo:nil
                                                    repeats:NO];
                });
            });

            
            
            

            //[self updateHighestID];
            //[self updateHighestInt];
            
        }
        else if (tierCreation==3){
            
            NSString *pollQuestion = textField.text;
            NSString *option1 = pollOption1.text;
            NSString *option2 = pollOption2.text;
            NSLog(@"****************poll option 1 ********************");
            [pollOption1 removeFromSuperview];
            [pollOption2 removeFromSuperview];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.5];
            //uILabel.alpha = 1;
            //uILabel.frame = frame;
            
            textField.frame = CGRectMake(self.view.frame.size.width/2 , self.view.frame.size.height/2, 1, 1);
            [UIView commitAnimations];
            
            
            
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                tierCreation = 3;
                unitUpdate = [NSMutableString stringWithFormat:@"%d",creatingNode.unit];
                predxPosition = [NSMutableString stringWithFormat:@"%f",startCreation.x];
                predyPosition = [NSMutableString stringWithFormat:@"%f", startCreation.x];
                xPosition = [NSMutableString stringWithFormat:@"%f",endCreation.x];
                yPosition = [NSMutableString stringWithFormat:@"%f", endCreation.y];
                Comments = [NSMutableString stringWithFormat:@"%d",creatingNode.numberOfComments];
                Likes = [NSMutableString stringWithFormat:@"0"];
                tier = [NSMutableString stringWithFormat:@"%d",tierCreation];
                //currentNode.numberOfComments +=1;
                
               // [self postTest];
                [self createPoll:pollQuestion optionUno:option1 optionDeux:option2];
                
                dispatch_async(dispatch_get_main_queue(),^{
                    uITextView.text = textField.text;
                    textField.text = @"";
                    [textField resignFirstResponder];//hides the keyboard
                    timer = [NSTimer scheduledTimerWithTimeInterval:.5
                                                             target:self
                                                           selector:@selector(threadedUpdate)
                                                           userInfo:nil
                                                            repeats:NO];
                    tierCreation=1;
                });
            });
            
        }
        
        
        
        
        
        tierCreation =1 ;
        
    }

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetContentSize) userInfo:nil repeats:NO]; //adjustedContentSize = 0;
    
    
}
-(void)resetContentSize{
    adjustedContentSize = 0;
}

- (IBAction)StartTheMessage:(UIButton *)sender {
    [textField becomeFirstResponder];
}

- (IBAction)voteBubble:(id)sender {
    if(tierCreation==1){
        tierCreation=3;
        
        
        pollOption1 = [[UITextView alloc]init];
        pollOption2 = [[UITextView alloc]init];
        textField.backgroundColor = [UIColor colorWithRed:137.0/255.0 green:232.0/255.0 blue:148.0/255.0 alpha:1];

        
        pollOption2.backgroundColor=pollOption1.backgroundColor = [UIColor colorWithRed:201.0/255.0 green:153.0/255.0 blue:139.0/255.0 alpha:1];
        pollOption1.textAlignment = pollOption2.textAlignment = NSTextAlignmentCenter;
        [pollOption1 setFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/2-labelHeight, labelWidth/1.3, labelHeight/1.3)];
        [pollOption2 setFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2-labelHeight, labelWidth/1.3, labelHeight/1.3)];
        pollOption1.alpha=pollOption2.alpha=0;
        
        pollOption2.layer.cornerRadius = pollOption1.layer.cornerRadius = pollOption1.frame.size.width/2;
        [self.view addSubview:pollOption1];
        [self.view addSubview:pollOption2];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        [textField setFrame:CGRectMake(self.view.frame.size.width/2 - labelWidth, self.view.frame.size.height/7, labelWidth*2, labelHeight/1.5)];
        textField.layer.cornerRadius = 10;
        pollOption1.alpha=pollOption2.alpha=1;
        
        [UIView commitAnimations];
        // textField.textColor = [UIColor whiteColor];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}

- (IBAction)regularChatBubble:(id)sender {
    if (tierCreation==3) {
        tierCreation=1;
        [pollOption1 removeFromSuperview];
        [pollOption2 removeFromSuperview];
        textField.backgroundColor=[self colorWithHexString:bubbleColor];
        textField.layer.cornerRadius = labelWidth/2;
        textField.font = [UIFont fontWithName:@"Nexa Light" size:12];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:.5];
        [textField setFrame:CGRectMake(self.view.frame.size.width/2-labelWidth/2, self.view.frame.size.height/2-labelHeight, labelWidth, labelHeight)];
        [UIView commitAnimations];
        
        
    }
}
@end
