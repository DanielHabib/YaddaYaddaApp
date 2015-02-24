//
//  YaddaYaddaViewController.h
//  BubbleChat
//
//  Created by Daniel Habib on 9/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface YaddaYaddaViewController : UIViewController<UIScrollViewDelegate>

@property CGPoint start;
@property CGPoint end;
@property(strong,nonatomic) NSString *topic;
@property(strong, nonatomic) NSString *userName;
@property (strong, nonatomic) IBOutlet UINavigationItem *naviBar;

@end
