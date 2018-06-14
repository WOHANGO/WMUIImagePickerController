//
//  MainViewController.m
//  ImagePickerController
//
//  Created by 吳梓杭 on 14/6/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "MainViewController.h"
#import "WZHImagePickerController.h"


@interface MainViewController ()

@property (nonatomic, strong) WZHImagePickerController *pickerView;

@end

@implementation MainViewController


- (WZHImagePickerController *)pickerView {
    if (!_pickerView) {
        _pickerView = [[WZHImagePickerController alloc] initWithType:WZHImagePickerTypeCollectionView];
        _pickerView.maxCount = 9;
        _pickerView.allowPickingVideo = YES;
        _pickerView.allowPickingGif = YES;
        
        _pickerView.collectionBlock = ^(NSArray<UIImage *> *collectionPhotos) {
            NSLog(@"%@",collectionPhotos);
        };
        [self.view addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(200);
            make.bottom.equalTo(self.view).offset(-0);
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
    imageBtn.frame = CGRectMake((kUIScreenWidth - 80) / 2, 70, 80, 80);
    [imageBtn addTarget:self action:@selector(clickimageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageBtn];
    
    [self pickerView];
    
}

- (void)clickimageBtn:(UIButton *)button {
    self.pickerView = [[WZHImagePickerController alloc] initWithType:WZHImagePickerTypeTakePhoto];
    self.pickerView.photographBlock = ^(UIImage *cropImage) {
        [button setImage:cropImage forState:UIControlStateNormal];
    };
    self.pickerView.albumsBlock = ^(NSArray<UIImage *> *photos) {
        [button setImage:photos[0] forState:UIControlStateNormal];
    };
    [self.view addSubview:self.pickerView];
}



@end
