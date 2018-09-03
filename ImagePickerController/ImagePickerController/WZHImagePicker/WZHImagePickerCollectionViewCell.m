
//
//  WZHImagePickerCollectionViewCell.m
//  TZImagePickerController
//
//  Created by 吳梓杭 on 4/5/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "WZHImagePickerCollectionViewCell.h"
#import "WZHImageMacro.h"

@implementation WZHImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self videoImageView];
        [self deleteBtn];
        [self gifLable];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView= [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 4.f;
        _imageView.layer.borderWidth = 1.5f;
        _imageView.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3].CGColor;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(7);
            make.right.equalTo(self).offset(-7);
            make.left.bottom.equalTo(self);
        }];
    }
    return _imageView;
}
- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.hidden = YES;
        [self addSubview:_videoImageView];
        [_videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    return _videoImageView;
}
- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"To_choose"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-17, 0, 0, -17);
        _deleteBtn.alpha = 0.6;
        [self addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
    }
    return _deleteBtn;
}
- (UILabel *)gifLable {
    if (!_gifLable) {
        [self layoutIfNeeded];
        _gifLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 14, self.imageView.frame.size.width, 14)];
        _gifLable.text = @"GIF";
        _gifLable.textColor = [UIColor whiteColor];
        _gifLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _gifLable.textAlignment = NSTextAlignmentCenter;
        _gifLable.font = [UIFont systemFontOfSize:10];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_gifLable.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _gifLable.bounds;
        maskLayer.path = maskPath.CGPath;
        _gifLable.layer.mask  = maskLayer;
        [self addSubview:_gifLable];
        
    }
    return _gifLable;
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        _videoImageView.hidden = phAsset.mediaType != PHAssetMediaTypeVideo;
        _gifLable.hidden = ![[phAsset valueForKey:@"filename"] containsString:@"GIF"];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        _videoImageView.hidden = ![[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        _gifLable.hidden = YES;
    }
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    UIView *cellSnapshotView = nil;
    
    CGSize size = CGSizeMake((kUIScreenWidth - 50) / 4, (kUIScreenWidth - 50) / 4);
    UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];

    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.layer.cornerRadius = 4.f;
    cellSnapshotView.layer.masksToBounds = YES;
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}


@end
