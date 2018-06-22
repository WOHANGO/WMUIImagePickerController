
//
//  WZHImagePickerController.m
//  TZImagePickerController
//
//  Created by 吳梓杭 on 4/5/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "WZHImagePickerController.h"
#import "LxGridViewFlowLayout.h"
#import "WZHImagePickerCollectionViewCell.h"
#import "WZHImageMacro.h"


@interface WZHImagePickerController ()
<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL collectionBool;                //不是collectionView:NO
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LxGridViewFlowLayout *layout;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) BOOL longPressGestureBool;    //是否取消长按手势

@end

static NSString *const WZHImagePickerCollectionViewCellID = @"WZHImagePickerCollectionViewCell";
@implementation WZHImagePickerController

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        if (type == WZHImagePickerTypeDefault) {
            [self creationAlertController];
            self.collectionBool = NO;
        }
        if (type == WZHImagePickerTypeTakePhoto) {
            [self takePhoto];
            self.collectionBool = NO;
        }
        if (type == WZHImagePickerTypeAlbum) {
            [self pushTZImagePickerController];
            self.collectionBool = NO;
        }
        if (type == WZHImagePickerTypeCollectionView) {
            [self collectionView];
            self.collectionBool = YES;
        }
        if (type == WZHImagePickerTypelongPressGestureCollectionView) {
            self.longPressGestureBool = YES;
            [self collectionView];
            self.collectionBool = YES;
        }
        [self initializeVariable];
    }
    return self;
}

#pragma mark ---- 初始化变量
- (void)initializeVariable {
    self.backgroundColor = [UIColor clearColor];
    [self imagePickerVC];
    [self selectedPhotos];
    [self selectedAssets];
    self.maxCount = 1;
    self.allowCrop = NO;
    self.needCircleCrop = NO;
    self.insideTakeVideo = NO;
    self.insideTakePhoto = NO;
    self.sortAscending = YES;
    self.allowPickingVideo = NO;
    self.allowPickingImage = YES;
    self.allowPickingGif = NO;
    self.allowPickingOriginalPhoto = YES;
    self.allowPickingMuitlpleGifOrVideo = YES;
    self.diameter = kUIScreenWidth;
}

- (UIImagePickerController *)imagePickerVC {
    if (!_imagePickerVC) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        _imagePickerVC.delegate = self;
        //改变相册选择页的导航栏外观
        _imagePickerVC.navigationBar.tintColor = self.viewController.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            if (@available(iOS 9.0, *)) {
                tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            } else {
                // Fallback on earlier versions
            }
            if (@available(iOS 9.0, *)) {
                BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
            } else {
                // Fallback on earlier versions
            }
        }else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVC;
}
- (NSMutableArray *)selectedPhotos {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray arrayWithCapacity:1];
    }
    return _selectedPhotos;
}
- (NSMutableArray *)selectedAssets {
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray arrayWithCapacity:1];
    }
    return _selectedAssets;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[LxGridViewFlowLayout alloc] init];
        _layout.longPressGestureBool = self.longPressGestureBool;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:_layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[WZHImagePickerCollectionViewCell class] forCellWithReuseIdentifier:WZHImagePickerCollectionViewCellID];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedPhotos.count + 1;
}
- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZHImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WZHImagePickerCollectionViewCellID forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == self.selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"add_btn"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    }else {
        cell.imageView.image = self.selectedPhotos[indexPath.row];
        cell.asset = self.selectedAssets[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    if (!self.allowPickingGif) {
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.f, 12.f, 0.f, 12.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8.f;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kUIScreenWidth - 50) / 4, (kUIScreenWidth - 50) / 4);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedPhotos.count) {
        [self creationAlertController];
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] tz_containsString:@"GIF"] && self.allowPickingGif && !self.allowPickingMuitlpleGifOrVideo) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController presentViewController:vc animated:YES completion:nil];
            });
        } else if (isVideo && !self.allowPickingMuitlpleGifOrVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController presentViewController:vc animated:YES completion:nil];
            });
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.selectedAssets selectedPhotos:self.selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = self.maxCount;
            imagePickerVc.allowPickingGif = self.allowPickingGif;
            imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleGifOrVideo;
            imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
                self.selectedAssets = [NSMutableArray arrayWithArray:assets];
                self.isSelectOriginalPhoto = isSelectOriginalPhoto;
                [self.collectionView reloadData];
                if (self.collectionBool) {
                    self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
            });
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.selectedPhotos.count && destinationIndexPath.item < self.selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.selectedPhotos[sourceIndexPath.item];
    [self.selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = self.selectedAssets[sourceIndexPath.item];
    [self.selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [self.selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [self.collectionView reloadData];
    if (self.collectionBool) {
        self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (self.maxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    
    if (self.maxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    }
    
    imagePickerVc.allowTakePicture = self.insideTakePhoto;  // 在相册内能否拍摄照片
    imagePickerVc.allowTakeVideo = self.insideTakeVideo;    // 在相册内能否拍摄视频
    
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideo;   //视频
    imagePickerVc.allowPickingImage = self.allowPickingImage;   //图片
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;   //原图，若allowPickingImage为No，值无效
    imagePickerVc.allowPickingGif = self.allowPickingGif;     //GIF
    imagePickerVc.allowPickingMultipleVideo =self.allowPickingMuitlpleGifOrVideo; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = self.sortAscending;
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCrop;
    imagePickerVc.needCircleCrop = self.needCircleCrop;
    // 设置竖屏下的裁剪尺寸
    imagePickerVc.cropRect = CGRectMake((kUIScreenWidth - self.diameter) / 2, (kUIScreenHeight - self.diameter) / 2, self.diameter, self.diameter);
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (!self.collectionBool) {
            self.albumsBlock(photos, self.isSelectOriginalPhoto);
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
    });
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = sourceType;
        if(iOS8Later) {
            self.imagePickerVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.viewController presentViewController:self.imagePickerVC animated:YES completion:nil];
        });
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        //按修改时间升序
        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscending;
        
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (self.allowCrop) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                                if (!self.collectionBool) {
                                    self.photographBlock(cropImage);
                                }
                            }];
                            imagePicker.needCircleCrop = self.needCircleCrop;    //圆形裁剪
                            imagePicker.cropRect = CGRectMake((kUIScreenWidth - self.diameter) / 2, (kUIScreenHeight - self.diameter) / 2, self.diameter, self.diameter);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.viewController presentViewController:imagePicker animated:YES completion:nil];
                            });
                        } else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                            if (!self.collectionBool) {
                                self.photographBlock(image);
                            }
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [self.selectedAssets addObject:asset];
    [self.selectedPhotos addObject:image];
    [self.collectionView reloadData];
    if (self.collectionBool) {
        self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
    }
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIAlertController

- (void)creationAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    });
}


#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    if (self.collectionBool) {
        self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
    }
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    self.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [self.collectionView reloadData];
    if (self.collectionBool) {
        self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
    }
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    self.selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    self.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [self.collectionView reloadData];
    if (self.collectionBool) {
        self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
    }
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    [self.selectedAssets removeObjectAtIndex:sender.tag];
    
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
        if (self.collectionBool) {
            self.collectionBlock(self.selectedPhotos, self.isSelectOriginalPhoto);
        }
    }];
}



#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        // NSLog(@"图片名字:%@",fileName);
    }
}


#pragma mark - YYKit中的UIViewController处理
- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
