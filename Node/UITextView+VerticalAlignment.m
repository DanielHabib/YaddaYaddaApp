//
//  UITextView+VerticalAlignment.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/14/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "UITextView+VerticalAlignment.h"

@implementation UITextView (VerticalAlignment)



- (void)alignToTop {
    // Get a message whenever the content size changes
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // When content size change, make sure the content is positioned at the top of the scroll view.
    self.contentOffset = CGPointMake(0.0f, 0.0f);
}

- (void)disableAlginment {
    [self removeObserver:self forKeyPath:@"contentSize"];
}







@end
