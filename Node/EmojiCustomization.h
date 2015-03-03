//
//  EmojiCustomization.h
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiCustomization : UIViewController<UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property UIImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UILabel *HeaderLabel;

@end
