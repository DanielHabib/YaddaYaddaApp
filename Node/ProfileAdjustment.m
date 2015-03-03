//
//  ProfileAdjustment.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 1/6/15.
//  Copyright (c) 2015 d.g.habib7@gmail.com. All rights reserved.
//

#import "ProfileAdjustment.h"

@implementation ProfileAdjustment






- (IBAction)buttonPressed:(id)sender {
    [self setValue:self.phoneInputTextField.text forKey:@"phoneNumber" ];
    
}
@end
