//
//  BubbleColorSelectorViewController.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 10/10/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "BubbleColorSelectorViewController.h"

@interface BubbleColorSelectorViewController (){
    NSMutableString *colorHex;
}

@end

@implementation BubbleColorSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)red:(id)sender {
    colorHex = [NSMutableString stringWithString:@"ff206a"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    
}

- (IBAction)orange:(id)sender {
    colorHex = [NSMutableString stringWithString:@"ff7226"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
}

- (IBAction)green:(id)sender {
    colorHex = [NSMutableString stringWithString:@"83ff17"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    
}

- (IBAction)Blue:(id)sender {
    colorHex = [NSMutableString stringWithString:@"51ffee"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    
}

- (IBAction)Gray:(id)sender {
    colorHex = [NSMutableString stringWithString:@"b5aaa4"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    
}

- (IBAction)Purple:(id)sender {
    colorHex = [NSMutableString stringWithString:@"d676d0"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    
}






@end
