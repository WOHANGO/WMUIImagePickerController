# ImagePickerController，适用于头像、剪切头像、相册选择、拍照选择……，已实现上传阿里OSS服务器功能

##如果满意，请献上您的🌟🌟🌟🌟🌟🌟🌟🌟，谢谢
#### 项目介绍
**这是基于TZImagePickerController封装的相机和相册方法**

#### 软件架构
**话说在前，此demo的照片选择器使用[https://github.com/banchichen/TZImagePickerController](https://github.com/banchichen/TZImagePickerController)进行优化封装**


此封装含有Masonry，请自行修改

<img src="https://github.com/WOHANGO/WZHImagePickerController/blob/master/imagepicker.png" width="40%" height="40%">


## 使用教程

#### CocoaPods
```objc
 pod 'Masonry'
 pod 'TZImagePickerController','~> 3.0.9'    //调用相册选择器使用，不调用则不添加
 pod 'AliyunOSSiOS'               //调用阿里OSS使用，不调用则不添加
```
  **如果要实现相册选择器功能，请将文档”WMUIImagePicker“放入项目中,调用#import "WMUIImagePickerView.h"即可实现**

  **如果要实现图片上传阿里云服务器功能，请将文档“AliOSS”放入项目中，调用#import "AliOSSUpload.h"即可实现**


## 代码调用解释
###相册选择器
```objc
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

```

###图片上传阿里云OSS
```objc
/**
异步单张图片上传

@param image 图片
@param originalPhoto 是否原图
@param complete 回调
*/
+ (void)asyncUploadImage:(UIImage *)image originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSString *name, UploadImageState state))complete;

/**
同步单张图片上传

@param image 图片
@param originalPhoto 是否原图
@param complete 回调
*/
+ (void)syncUploadImage:(UIImage *)image originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSString *name, UploadImageState state))complete;

/**
异步多张图片上传

@param images 图片数组
@param originalPhoto 是否原图
@param complete 回调
*/
+ (void)asyncUploadImages:(NSArray<UIImage *> *)images originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

/**
同步多张图片上传

@param images 图片数组
@param originalPhoto 是否原图
@param complete 回调
*/
+ (void)syncUploadImages:(NSArray<UIImage *> *)images originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete;

```

