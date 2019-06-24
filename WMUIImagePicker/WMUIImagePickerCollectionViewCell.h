//
//  WMUIImagePickerCollectionViewCell.h
//  WMUIKit
//
//  Created by 吳梓杭 on 27/11/2018.
//  Copyright © 2018 吳梓杭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMUIImagePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end
