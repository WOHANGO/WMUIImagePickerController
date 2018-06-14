//
//  WZHImageMacro.h
//  ImagePickerController
//
//  Created by 吳梓杭 on 14/6/18.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#ifndef WZHImageMacro_h
#define WZHImageMacro_h

//-> 系统库
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Masonry.h>
#import <TZImagePickerController.h>
#import <TZImagePickerController/UIView+Layout.h>




#define kUIScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
#define kUIScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)



#endif /* WZHImageMacro_h */
