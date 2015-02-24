//
//  BubbleChatScene.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/18/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@interface BubbleChatScene : SKScene <UITextFieldDelegate>
@property CGPoint start;
@property CGPoint end;
@property SKLabelNode *currentLabel;
@property SKLabelNode *predeccesor;
@property NSString *user;
@property NSString *userName;
@property UILabel *labeledNode;
@property UITextField *textField;
@property NSMutableArray *labelList;
@property NSString *topic;


@property (nonatomic) CGSize contentSize;
@property(nonatomic) CGPoint contentOffset;
@property(nonatomic) SKSpriteNode *spriteForScrollingGeometry;
-(void)setContentScale:(CGFloat)scale;
@end
