//
//  AliOSSUpload.h
//  ImagePickerController
//
//  Created by 吳梓杭 on 2018/6/21.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};

@interface AliOSSUpload : NSObject

@property (nonatomic, assign) BOOL printBool;    //是否打印,默认NO

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

@end
