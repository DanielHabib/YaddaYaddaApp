//
//  ViewController.m
//  Node
//
//  Created by Daniel Habib on 8/26/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
//ScrollViewAdditionStart
@interface ViewController  ()
@property(nonatomic, weak)UIView *clearContentView;

@property(nonatomic, weak)MyScene *scene;
@end

//ScrollViewAdditionEnd



@implementation ViewController

- (void)viewDidLoad
{
    _userName = self.userName;
    //NSLog(@"%@",_userName);
    [super viewDidLoad];

    
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    MyScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.userName = _userName;
    NSLog(@"tested username:%@",scene.userName);
    // Present the scene.
    [skView presentScene:scene];
    //ScrollView Addition Start
    //_scene = scene;
    
    
    
    //ScrollViewAddition End
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
