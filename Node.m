//
//  Node.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 9/22/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.text = [[NSString alloc]init];
        self.user = [[NSString alloc]init];
        self.tier = 0;
        self.unit = 0;
        self.hasChild = NO;
        self.secondTierChildren = 0;
        self.likes = 0;
        self.tier = 1;
        self.location = CGPointMake(0, 0);
        self.center = CGPointMake(0, 0);
        self.numberOfComments = 0;
        self.ID = 0;
        self.pathColor = [UIColor blackColor];
        self.pathStyle = @"straight";
    }
    return self;
}
@end
