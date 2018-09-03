//
//  MainViewController.m
//  ImagePickerController
//
//  Created by 吳梓杭 on 14/6/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "MainViewController.h"
#import "WZHImagePickerView.h"
#import <Masonry.h>
#import "AliOSSUpload.h"

#define kUIScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kUIScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

@interface MainViewController ()

@property (nonatomic, strong) WZHImagePickerView *pickerView;

@end

@implementation MainViewController


- (WZHImagePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[WZHImagePickerView alloc] initWithType:WZHImagePickerTypelongPressGestureCollectionView];
        _pickerView.maxCount = 9;
        _pickerView.allowPickingVideo = YES;
        _pickerView.allowPickingGif = YES;
        _pickerView.collectionBlock = ^(NSArray<UIImage *> *collectionPhotos, BOOL isSelectOriginalPhoto) {

        };
        
        [self.view addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(200);
            make.bottom.equalTo(self.view).offset(-30);
            make.left.right.equalTo(self.view);
        }];
    }
    return _pickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.backgroundColor = [UIColor redColor];
    imageBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 80) / 2, 70, 80, 80);
    [imageBtn addTarget:self action:@selector(clickimageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBtn];
    
    [self pickerView];
    
}

- (void)clickimageBtn:(UIButton *)button {
    self.pickerView = [[WZHImagePickerView alloc] initWithType:WZHImagePickerTypeDefault];
    self.pickerView.photographBlock = ^(UIImage *cropImage) {
        [button setImage:cropImage forState:UIControlStateNormal];
    };
    self.pickerView.albumsBlock = ^(NSArray<UIImage *> *photos, BOOL isSelectOriginalPhoto) {
        [button setImage:photos[0] forState:UIControlStateNormal];
    };
    [self.view addSubview:self.pickerView];
}

/**
 [[AliOSSUpload shareInstance] uploadImage:<NSArray<UIImage *> *photos> originalPhoto:isSelectOriginalPhoto success:^(NSString *obj) {
 if ([obj intValue] == -1) {
 NSLog(@"上传失败");
 }else {
 NSLog(@"%@",obj);
 }
 }];
 **/

@end
