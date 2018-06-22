//
//  WZHImagePickerController.h
//  TZImagePickerController
//
//  Created by 吳梓杭 on 4/5/18.
//  Copyright © 2018年 吳梓杭QQ:905640505. All rights reserved.
//
/**
 
 话说在前，此demo使用https://github.com/banchichen/TZImagePickerController进行优化封装
 如谭真同志想弄我，那就弄吧😂😂😂😂
 
 作者谭真代码修改部分如下：
 "LxGridViewFlowLayout.h"      18-21行
 "LxGridViewFlowLayout.m"      80-96行
 
 此封装含有Masonry，请自行修改
 
 */

#import <UIKit/UIKit.h>

/**
 ImagePicker类型
 
 - WZHImagePickerTypeDefault: 默认样式，不创建列表
 - WZHImagePickerTypeTakePhoto: 相机
 - WZHImagePickerTypeAlbum: 相册
 - WZHImagePickerTypeCollectionView: collcetionView样式
 - WZHImagePickerTypelongPressGestureCollectionView: collcetionView样式,含有长按
 */
typedef NS_ENUM(NSInteger, WZHImagePickerType) {
    WZHImagePickerTypeDefault,
    WZHImagePickerTypeTakePhoto,
    WZHImagePickerTypeAlbum,
    WZHImagePickerTypeCollectionView,
    WZHImagePickerTypelongPressGestureCollectionView,
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

@interface WZHImagePickerController : UIView

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
 是否多选GIF或视频，默认YES
 */
@property (nonatomic, assign) BOOL allowPickingMuitlpleGifOrVideo;
/**
 是否允许裁剪，默认NO
 */
@property (nonatomic, assign) BOOL allowCrop;
/**
 是否圆形裁剪，默认NO
 */
@property (nonatomic, assign) BOOL needCircleCrop;
/**
 裁剪直径，默认[UIScreen mainScreen].bounds.size.width
 */
@property (nonatomic, assign) float diameter;


- (instancetype)initWithType:(NSInteger)type;

@end
