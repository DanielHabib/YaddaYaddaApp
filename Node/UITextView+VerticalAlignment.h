//
//  UITextView+VerticalAlignment.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/14/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (VerticalAlignment)
- (void)alignToTop;

/**
 Client should call this to stop KVO.
 */
- (void)disableAlignment;
@end
