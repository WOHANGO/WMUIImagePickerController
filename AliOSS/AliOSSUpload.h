//
//  AliOSSUpload.h
//  ImagePickerController
//
//  Created by 吳梓杭 on 2018/6/21.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AliOSSUpload : NSObject

@property (nonatomic, assign) BOOL printBool;    //是否打印,默认NO

+ (instancetype)shareInstance;

/**
 上传图片到阿里OSS

 @param imageArr 图片数组
 @param OriginalPhoto 是否为原图
 @param success 上传成功，返回url，失败返回：-1
 */
- (void)uploadImage:(NSArray<UIImage *> *)imageArr originalPhoto:(BOOL)OriginalPhoto success:(void (^)(NSString *obj))success;

@end
