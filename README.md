# ImagePickerController

#### 项目介绍
{**这是基于TZImagePickerController封装的相机和相册方法}

#### 软件架构
**话说在前，此demo使用[https://github.com/banchichen/TZImagePickerController](https://github.com/banchichen/TZImagePickerController)进行优化封装**
先对不住咯谭真同志😂😂😂😂

作者谭真代码修改部分如下：
"LxGridViewFlowLayout.h"      18-21行
"LxGridViewFlowLayout.m"      80-96行

此封装含有Masonry，请自行修改


## 使用教程

#### CocoaPods
> pod 'TZImagePickerController'
>pod 'Masonry'
将文档”WZHImagePicker“放入项目中,调用#import "WZHImagePickerController.h"即可实现


##代码解释

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

