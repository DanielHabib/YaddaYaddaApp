//
//  EmojiCustomization.m
//  Yadda Yadda
//
//  Created by Daniel Habib on 12/20/14.
//  Copyright (c) 2014 d.g.habib7@gmail.com. All rights reserved.
//

#import "EmojiCustomization.h"
#import "CoreDataAPI.h"
#import <dispatch/dispatch.h>
@implementation EmojiCustomization{
    
    //currentSelection
    UIImageView *currentImageView;
    NSInteger currentIndex;
    NSString *currentEmoji;
    NSString *currentEmojiString;
    NSMutableDictionary *cellList;
    NSMutableArray *emojiStringList;
    NSMutableArray *emojiList;
    NSMutableArray *photoList;
    NSString*email;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    
    _HeaderLabel.layer.cornerRadius = _HeaderLabel.frame.size.width/2;
    _HeaderLabel.layer.masksToBounds = YES;
    
    
    email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    
    
    emojiList = [[NSMutableArray alloc]init];
    [emojiList addObject:@"😴"];
    [emojiList addObject:@"😀"];
    [emojiList addObject:@"😇"];
    
    emojiStringList=[[NSMutableArray alloc]init];
    
    [emojiStringList addObject:@"sleepy"];
    [emojiStringList addObject:@"happy"];
    [emojiStringList addObject:@"angel"];
    photoList = [[NSMutableArray alloc]init];
    __block NSData *happyImageData;
    __block NSData *angelImageData;
    __block NSData *sleepyImageData;
    [photoList addObject:[UIImage imageNamed:@"profilePic.jpg.gif"]];
    [photoList addObject:[UIImage imageNamed:@"profilePic.jpg.gif"]];
    [photoList addObject:[UIImage imageNamed:@"profilePic.jpg.gif"]];
    
    NSArray *EntitySet = [CoreDataAPI fetchAllEmojiPhotos];
    
    if ([EntitySet count]==[emojiList count]) {
        
        
        
    }else{
        
        
    dispatch_queue_t queue;
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"%@",email);
        
        
        happyImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/happy/emojiPicture.jpg",email]]];
        
        angelImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/angel/emojiPicture.jpg",email]]];
        
        sleepyImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/sleepy/emojiPicture.jpg",email]]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (happyImageData) {
                [photoList replaceObjectAtIndex:1 withObject:[UIImage imageWithData: happyImageData]];
            }
            if (sleepyImageData) {
                [photoList replaceObjectAtIndex:0 withObject:[UIImage imageWithData: sleepyImageData]];
            }
            if (angelImageData) {
                [photoList replaceObjectAtIndex:2 withObject:[UIImage imageWithData: angelImageData]];
            }
            
            [self.collectionView reloadData];
        });
        
        
    
    });
    }

    cellList = [[NSMutableDictionary alloc]init];
  for (id a in emojiList) {
        NSMutableDictionary *holder=  [[NSMutableDictionary alloc]init];
        [holder setObject:a forKey:@"emoji"];
        [holder setObject:[emojiStringList objectAtIndex:[emojiList indexOfObject:a]] forKey:@"emojiString"];
        [holder setObject:[photoList objectAtIndex:[emojiList indexOfObject:a]] forKey:@"photo"];
        [cellList setObject:holder forKey:[NSString stringWithFormat:@"%lu",(unsigned long)[emojiList indexOfObject:a]]];
    }
    
    
}

static NSString * const reuseIdentifier = @"Cell";

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [emojiList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    
    UILabel *label = (UILabel *) [cell viewWithTag:2];
    label.text = [emojiList objectAtIndex:indexPath.row];
    UIImageView *pic = (UIImageView *)[cell viewWithTag:1];
    pic.image = [photoList objectAtIndex:indexPath.row];
    pic.layer.cornerRadius = pic.frame.size.width/2;
    pic.layer.borderColor = [[UIColor grayColor]CGColor];
    pic.layer.borderWidth = 4.0;
    pic.layer.masksToBounds = YES;
    return cell;
}
//
//UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//picker.delegate = self;
//picker.allowsEditing = YES;
//picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//
//[self presentViewController:picker animated:YES completion:NULL];


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [photoList setObject:chosenImage atIndexedSubscript:currentIndex];
    [_collectionView reloadData];
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, .8);
    
    
    currentEmojiString = [emojiStringList objectAtIndex:currentIndex];
    currentEmoji = [emojiList objectAtIndex:currentIndex];
    
    [CoreDataAPI newEmojiPhotoWithEmojiString:currentEmojiString emoji:currentEmoji emojiPhoto:imageData];
    [self AFPost:imageData];
   [picker dismissViewControllerAnimated:YES completion:NULL];

    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    currentIndex = indexPath.row;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}

-(void)AFPost:(NSData *)imageData{
    

        NSLog(@"image Data exists");
        NSString *emojiTyped = [emojiStringList objectAtIndex:currentIndex];
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/%@",email,emojiTyped]]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.5);
        NSDictionary *parameters = @{@"message": @"test"};
        AFHTTPRequestOperation *op = [manager POST:@"uploadEmojiPicture.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //do not put image inside parameters dictionary as I did, but append it!
            [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"emojiPicture.jpg"] mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        [op start];
        
    }

//-(void)AFPost{
//
//    if(imageData){
//        NSLog(@"image Data exists");
//        
//        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://104.131.53.146/users/%@/emojis/%@",email,currentEmoji]]];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        //NSData *imageData = UIImageJPEGRepresentation(pickedImage, 0.5);
//        NSDictionary *parameters = @{@"message": @"test"};
//        AFHTTPRequestOperation *op = [manager POST:@"uploadEmojiPicture.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//            //do not put image inside parameters dictionary as I did, but append it!
//            [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"emojiPicture.jpg"] mimeType:@"image/jpeg"];
//        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//        }];
//        [op start];
//        
//    }}



@end
