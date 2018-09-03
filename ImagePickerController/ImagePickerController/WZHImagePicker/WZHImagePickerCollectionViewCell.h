//
//  WZHImagePickerCollectionViewCell.h
//  TZImagePickerController
//
//  Created by 吳梓杭 on 4/5/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZHImagePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end
