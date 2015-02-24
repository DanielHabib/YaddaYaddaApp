//
//  UpVoteEditorViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/12/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "UpVoteEditorViewController.h"

@interface UpVoteEditorViewController ()

@end

@implementation UpVoteEditorViewController{
    NSUserDefaults *defaults;
    NSData *imageData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ThumbsUp:(id)sender {
    
    [defaults setObject:imageData forKey:@"LikeAnimation"];
}

- (IBAction)plusOne:(id)sender {
    
    imageData = [NSData dataWithContentsOfFile:@"plus1.png"];
    [defaults setObject:imageData forKey:@"LikeAnimation"];

}

- (IBAction)Sweet:(id)sender {
    
    [defaults setObject:imageData forKey:@"LikeAnimation"];

}

- (IBAction)emoji:(id)sender {
    
    [defaults setObject:imageData forKey:@"LikeAnimation"];

}

- (IBAction)upArrow:(id)sender {
    imageData = [NSData dataWithContentsOfFile:@"upvote-downvote.png"];
    [defaults setObject:imageData forKey:@"LikeAnimation"];

}
@end
