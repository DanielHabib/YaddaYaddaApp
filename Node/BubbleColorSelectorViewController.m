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
    self.greenButton.layer.cornerRadius = self.greenButton.frame.size.width/2;
    self.greenButton.layer.masksToBounds=YES;
    
    self.redButton.layer.cornerRadius = self.greenButton.frame.size.width/2;
    self.redButton.layer.masksToBounds=YES;
    
    self.orangeButton.layer.cornerRadius = self.greenButton.frame.size.width/2;
    self.orangeButton.layer.masksToBounds=YES;
    
    self.blueButton.layer.cornerRadius = self.greenButton.frame.size.width/2;
    self.blueButton.layer.masksToBounds=YES;
    
    self.greyButton.layer.cornerRadius = self.greenButton.frame.size.width/2;
    self.greyButton.layer.masksToBounds=YES;
    
    
    self.purpleButton.layer.cornerRadius = self.greenButton.frame.size.width/2;
    self.purpleButton.layer.masksToBounds=YES;
    
  
    self.greyBackground.layer.cornerRadius = self.greyBackground.frame.size.width/2;
    self.greyBackground.layer.masksToBounds=YES;
    
    self.currentBubbleColor.layer.cornerRadius = self.currentBubbleColor.frame.size.width/2;
    self.currentBubbleColor.layer.masksToBounds=YES;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    colorHex = [defaults objectForKey:@"bubbleColor"];
    
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];
    
    
    
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
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];

    
}

- (IBAction)orange:(id)sender {
    colorHex = [NSMutableString stringWithString:@"ff7226"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];

}

- (IBAction)green:(id)sender {
    colorHex = [NSMutableString stringWithString:@"83ff17"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];

    
}

- (IBAction)Blue:(id)sender {
    colorHex = [NSMutableString stringWithString:@"51ffee"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];
    
    
}

- (IBAction)Gray:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        colorHex = [NSMutableString stringWithString:@"b5aaa4"];

    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];
    
}

- (IBAction)Purple:(id)sender {
    colorHex = [NSMutableString stringWithString:@"d676d0"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:@"bubbleColor"];
    
    self.currentBubbleColor.backgroundColor = [self colorWithHexString:colorHex];
    
}

-(UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned int hex;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}





@end
