//
//  Node.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 9/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject
@property int tier;
@property BOOL hasChild;
@property int likes;
@property int secondTierChildren;
@property NSString *text;
@property NSString *user;
@property int unit;
@property CGPoint location;
@property NSString *side;
@property CGPoint center;
@property int numberOfComments;
@property int ID;
@property UIColor *color;
@property UIColor *pathColor;
@property NSString *pathStyle;
@end
