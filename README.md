# ImagePickerController，适用于头像、剪切头像、相册选择、拍照选择……，已实现上传阿里OSS服务器功能

##如果满意，请献上您的🌟🌟🌟🌟🌟🌟🌟🌟，谢谢
#### 项目介绍
**这是基于TZImagePickerController封装的相机和相册方法**

#### 软件架构
**话说在前，此demo使用[https://github.com/banchichen/TZImagePickerController](https://github.com/banchichen/TZImagePickerController)进行优化封装**

 先对不住咯谭真同志😂😂😂😂  

**作者谭真代码修改部分如下：**
<br>"LxGridViewFlowLayout.h"      18-21行</br>
<br>"LxGridViewFlowLayout.m"      80-96行</br>


此封装含有Masonry，请自行修改

<img src="https://github.com/WOHANGO/WZHImagePickerController/blob/master/imagepicker.png" width="40%" height="40%">


## 使用教程

#### CocoaPods
```objc
 pod 'Masonry'
 pod 'TZImagePickerController','~> 3.0.2'    //调用相册选择器使用，不调用则不添加
 pod 'AliyunOSSiOS'               //调用阿里OSS使用，不调用则不添加
```
  **如果要实现相册选择器功能，请将文档”WZHImagePicker“放入项目中,调用#import "WZHImagePickerController.h"即可实现**

  **如果要实现图片上传阿里云服务器功能，请将文档“AliOSS”放入项目中，调用#import "AliOSSUpload.h"即可实现**


## 代码调用解释
###相册选择器
```objc
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

```

###图片上传阿里云OSS
```objc
/**
上传图片到阿里OSS

@param imageArr 图片数组
@param OriginalPhoto 是否为原图
@param success 上传成功，返回url，失败返回：-1
*/
- (void)uploadImage:(NSArray<UIImage *> *)imageArr originalPhoto:(BOOL)OriginalPhoto success:(void (^)(NSString *obj))success;

```

