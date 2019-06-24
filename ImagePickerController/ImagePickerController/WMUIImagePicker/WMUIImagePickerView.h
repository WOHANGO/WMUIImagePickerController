//
//  WMUIImagePickerView.h
//  WMUIKit
//
//  Created by 吳梓杭 on 27/11/2018.
//  Copyright © 2018 吳梓杭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 ImagePicker类型
 
 - WMUIImagePickerTypeDefault: 默认样式，不创建列表
 - WMUIImagePickerTypeTakePhoto: 相机
 - WMUIImagePickerTypeAlbum: 相册
 - WMUIImagePickerTypeCollectionView: collcetionView样式
 - WMUIImagePickerTypelongPressGestureCollectionView: collcetionView样式,含有长按
 - WMUIImagePickerTypeHorizontalCollectionView: collcetionView横向滚动样式
 - WMUIImagePickerTypelongPressGestureHorizontalCollectionView: collcetionView横向滚动样式,含有长按
 */
typedef NS_ENUM(NSInteger, WMUIImagePickerType) {
    WMUIImagePickerTypeDefault,
    WMUIImagePickerTypeTakePhoto,
    WMUIImagePickerTypeAlbum,
    WMUIImagePickerTypeCollectionView,
    WMUIImagePickerTypelongPressGestureCollectionView,
    WMUIImagePickerTypeHorizontalCollectionView,
    WMUIImagePickerTypelongPressGestureHorizontalCollectionView,
};

/**
 collectionView选择回调
 
 @param collectionPhotos collectionView选择回调
 */
typedef void(^myCollectionViewPickerBlock)(NSArray<UIImage *> *collectionPhotos, BOOL isSelectOriginalPhoto);

/**
 相册下选择照片回调
 
 @param photos 相册下选择照片回调
 */
typedef void(^myAlbumsPickerBlock)(NSArray<UIImage *> *photos, BOOL isSelectOriginalPhoto);

/**
 拍照回调
 
 @param cropImage 拍照回调
 */
typedef void(^myPhotographBlock)(UIImage *cropImage);

@interface WMUIImagePickerView : UIView

/**
 collectionViewCell的大小,默认 CGSizeMake((WMUIScreenWidth - 50) / 4, (WMUIScreenWidth - 50) / 4)
 */
@property (nonatomic, assign) CGSize cellSize;
/**
 collcetionView下选择回调
 */
@property (nonatomic, strong) myCollectionViewPickerBlock collectionBlock;
/**
 非collectionView相册下选择照片回调
 */
@property (nonatomic, strong) myAlbumsPickerBlock albumsBlock;
/**
 非collectionView拍照回调
 */
@property (nonatomic, strong) myPhotographBlock photographBlock;
/**
 navigationBar颜色
 */
@property (nonatomic, strong) UIColor *navigationBarColor;
/**
 选择角标颜色
 */
@property (nonatomic, strong) UIColor *iconThemeColor;
/**
 相册选择器按钮颜色
 */
@property (nonatomic, strong) UIColor *doneButtonColor;
/**
 数量，默认1张
 */
@property (nonatomic, assign) NSInteger maxCount;
/**
 内部显示拍照按钮，默认NO
 */
@property (nonatomic, assign) BOOL insideTakePhoto;
/**
 内部显示拍视频按钮，默认NO
 */
@property (nonatomic, assign) BOOL insideTakeVideo;
/**
 时间升降序，默认YES
 */
@property (nonatomic, assign) BOOL sortAscending;
/**
 是否允许选择视频，默认NO
 */
@property (nonatomic, assign) BOOL allowPickingVideo;
/**
 是否允许选择图片，默认YES
 */
@property (nonatomic, assign) BOOL allowPickingImage;
/**
 是否允许选择GIF，默认NO
 */
@property (nonatomic, assign) BOOL allowPickingGif;
/**
 是否选择原图，默认YES
 */
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
/**
 是否显示选择顺序，默认YES
 */
@property (nonatomic, assign) BOOL showSelectedIndex;
/**
 是否多选GIF或视频，默认YES
 */
@property (nonatomic, assign) BOOL allowPickingMuitlpleGifOrVideo;
/**
 是否方形裁剪，默认NO
 */
@property (nonatomic, assign) BOOL allowCrop;
/**
 是否圆形裁剪，默认NO
 */
@property (nonatomic, assign) BOOL needCircleCrop;
/**
 裁剪直径，默认self.size.width
 */
@property (nonatomic, assign) float diameter;

/**
 是否只能拍照
 */
@property (nonatomic, assign) BOOL photographOnly;


- (instancetype)initWithType:(NSInteger)type;

@end
