//
//  BubbleChatViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@interface BubbleChatViewController : UIViewController<UIScrollViewDelegate>
//@property UIScrollView *scrollView;
-(void)updateScene;
@property CGPoint start;
@property CGPoint end;
@property(strong,nonatomic) NSString *topic;
@property(strong, nonatomic) NSString *userName;
@end
