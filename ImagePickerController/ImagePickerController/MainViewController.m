//
//  MainViewController.m
//  ImagePickerController
//
//  Created by 吳梓杭 on 14/6/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "MainViewController.h"
#import "WMUIImagePickerView.h"
#import <Masonry.h>
#import "AliOSSUpload.h"

#define kUIScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kUIScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)

@interface MainViewController ()

//- WMUIImagePickerTypeCollectionView: collcetionView样式
//- WMUIImagePickerTypelongPressGestureCollectionView: collcetionView样式,含有长按
//- WMUIImagePickerTypeHorizontalCollectionView: collcetionView横向滚动样式
//- WMUIImagePickerTypelongPressGestureHorizontalCollectionView: collcetionView横向滚动样式,含有长按

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) WMUIImagePickerView *collectionPickerView;                              //collcetionView样式
@property (nonatomic, strong) WMUIImagePickerView *longPressGestureCollectionView;                    //collcetionView样式,含有长按
@property (nonatomic, strong) WMUIImagePickerView *horizontalCollectionPickerView;                    //collcetionView横向滚动样式
@property (nonatomic, strong) WMUIImagePickerView *longPressGestureHorizontalCollectionPickerView;    //collcetionView横向滚动样式,含有长按

@end

@implementation MainViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
        _scrollView.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _scrollView;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"- WMUIImagePickerTypeCollectionView: collcetionView样式\n\n- WMUIImagePickerTypelongPressGestureCollectionView: collcetionView样式,含有长按\n\n- WMUIImagePickerTypeHorizontalCollectionView: collcetionView横向滚动样式\n\n- WMUIImagePickerTypelongPressGestureHorizontalCollectionView: collcetionView横向滚动样式,含有长按";
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:14];
        [self.scrollView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top).offset(120);
            make.left.right.equalTo(self.view);
        }];
    }
    return _label;
}

- (WMUIImagePickerView *)collectionPickerView {
    if (!_collectionPickerView) {
        _collectionPickerView = [[WMUIImagePickerView alloc] initWithType:WMUIImagePickerTypeCollectionView];
        _collectionPickerView.maxCount = 9;
        _collectionPickerView.allowPickingVideo = YES;
        _collectionPickerView.allowPickingGif = YES;
        _collectionPickerView.collectionBlock = ^(NSArray<UIImage *> *collectionPhotos, BOOL isSelectOriginalPhoto) {

        };
        
        [self.scrollView addSubview:_collectionPickerView];
        [_collectionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.label.mas_bottom).offset(50);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo([[UIScreen mainScreen] bounds].size.width *2 / 3 + 40);
        }];
    }
    return _collectionPickerView;
}

- (WMUIImagePickerView *)longPressGestureCollectionView {
    if (!_longPressGestureCollectionView) {
        _longPressGestureCollectionView = [[WMUIImagePickerView alloc] initWithType:WMUIImagePickerTypelongPressGestureCollectionView];
        _longPressGestureCollectionView.maxCount = 9;
        _longPressGestureCollectionView.allowPickingVideo = YES;
        _longPressGestureCollectionView.allowPickingGif = YES;
        _longPressGestureCollectionView.collectionBlock = ^(NSArray<UIImage *> *collectionPhotos, BOOL isSelectOriginalPhoto) {
            
        };
        
        [self.scrollView addSubview:_longPressGestureCollectionView];
        [_longPressGestureCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionPickerView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo([[UIScreen mainScreen] bounds].size.width *2 / 3 + 40);
        }];
    }
    return _longPressGestureCollectionView;
}

- (WMUIImagePickerView *)horizontalCollectionPickerView {
    if (!_horizontalCollectionPickerView) {
        _horizontalCollectionPickerView = [[WMUIImagePickerView alloc] initWithType:WMUIImagePickerTypeHorizontalCollectionView];
        _horizontalCollectionPickerView.maxCount = 9;
        _horizontalCollectionPickerView.allowPickingVideo = YES;
        _horizontalCollectionPickerView.allowPickingGif = YES;
        _horizontalCollectionPickerView.collectionBlock = ^(NSArray<UIImage *> *collectionPhotos, BOOL isSelectOriginalPhoto) {
            
        };
        
        [self.scrollView addSubview:_horizontalCollectionPickerView];
        [_horizontalCollectionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.longPressGestureCollectionView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 4);
        }];
    }
    return _horizontalCollectionPickerView;
}
- (WMUIImagePickerView *)longPressGestureHorizontalCollectionPickerView {
    if (!_longPressGestureHorizontalCollectionPickerView) {
        _longPressGestureHorizontalCollectionPickerView = [[WMUIImagePickerView alloc] initWithType:WMUIImagePickerTypelongPressGestureHorizontalCollectionView];
        _longPressGestureHorizontalCollectionPickerView.maxCount = 9;
        _longPressGestureHorizontalCollectionPickerView.allowPickingVideo = YES;
        _longPressGestureHorizontalCollectionPickerView.allowPickingGif = YES;
        _longPressGestureHorizontalCollectionPickerView.collectionBlock = ^(NSArray<UIImage *> *collectionPhotos, BOOL isSelectOriginalPhoto) {
            
        };
        
        [self.scrollView addSubview:_longPressGestureHorizontalCollectionPickerView];
        [_longPressGestureHorizontalCollectionPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.horizontalCollectionPickerView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo([[UIScreen mainScreen] bounds].size.width / 4);
        }];
    }
    return _longPressGestureHorizontalCollectionPickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self scrollView];
    [self label];
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.backgroundColor = [UIColor redColor];
    imageBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 80) / 2, 10, 80, 80);
    [imageBtn addTarget:self action:@selector(clickimageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:imageBtn];
    
    [self collectionPickerView];
    [self longPressGestureCollectionView];
    [self horizontalCollectionPickerView];
    [self longPressGestureHorizontalCollectionPickerView];
    
}

- (void)clickimageBtn:(UIButton *)button {
    WMUIImagePickerView *pickerView = [[WMUIImagePickerView alloc] initWithType:WMUIImagePickerTypeDefault];
    pickerView.photographBlock = ^(UIImage *cropImage) {
        [button setImage:cropImage forState:UIControlStateNormal];
    };
    pickerView.albumsBlock = ^(NSArray<UIImage *> *photos, BOOL isSelectOriginalPhoto) {
        [button setImage:photos[0] forState:UIControlStateNormal];
    };
    [self.view addSubview:pickerView];
}

@end
