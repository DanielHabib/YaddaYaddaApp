//
//  MyScene.h
//  Node
//

//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//#import "Globals.h"
@interface MyScene : SKScene <UITextFieldDelegate>
@property (strong,nonatomic) SKNode *world;
@property CGPoint start;
@property CGPoint end;
@property SKLabelNode *currentLabel;
@property SKLabelNode *predeccesor;
@property NSString *user;
@property NSString *userName;
@property UILabel *labeledNode;

@end
