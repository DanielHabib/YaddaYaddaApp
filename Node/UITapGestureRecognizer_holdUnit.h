//
//  UITapGestureRecognizer_holdUnit.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/15/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITapGestureRecognizer :UITapGestureRecognizer


@property (nonatomic, strong) NSString *data;

@end


// MYTapGestureRecognizer.m

@implementation UITapGestureRecognizer

@end


// =====================


MYTapGestureRecognizer *singleTap = [[MYTapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];

singleTap.data = @"Hello";



// ====================

-(void)tapDetected:(UITapGestureRecognizer *)tapRecognizer {
    
    MYTapGestureRecognizer *tap = (MYTapGestureRecognizer *)tapRecognizer;
    
    NSLog(@"data : %@", tap.data);
    
}
@end
