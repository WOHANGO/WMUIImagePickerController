//
//  AliOSSUpload.m
//  ImagePickerController
//
//  Created by 吳梓杭 on 2018/6/21.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "AliOSSUpload.h"
#import <AliyunOSSiOS/OSSService.h>
#import "WMUIOSSAuthCredentialProvider.h"
#import "IHUtility.h"
#import <TZImagePickerController.h>


static NSString *const AccessKey = @"***********";
static NSString *const SecretKey = @"**********************";
static NSString *const BucketName = @"**********";
static NSString *const AliYunHost = @"https://oss-cn-********.aliyuncs.com/";
static NSString *const ImageHeaderUrl = @"https://*******.oss-cn-******.aliyuncs.com/";


OSSClient * client;
@implementation AliOSSUpload

+ (instancetype)shareInstance {
    static AliOSSUpload *_upload = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _upload = [[AliOSSUpload alloc] init];
        //移动终端是一个不受信任的环境，把AccessKeyId和AccessKeySecret直接保存在终端用来加签请求，存在极高的风险。建议只在测试时使用明文设置模式，业务应用推荐使用STS鉴权模式或自签名模式,此demo使用STS鉴权模式
        //STS鉴权模式
        //由于我的鉴权服务器含有请求头，阿里提供的sdk不能用请求头，所以我自己重新写了OSSAuthCredentialProvider，命名为：WMUIOSSAuthCredentialProvider，这鉴权服务器实际情况实际分析
        id<OSSCredentialProvider> credential = [[WMUIOSSAuthCredentialProvider alloc] initWithAuthServerUrl:@"<鉴权服务器url>"];
        client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
        OSSClientConfiguration *conf = [OSSClientConfiguration new];
        conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
        conf.timeoutIntervalForRequest = 15; // 网络请求的超时时间
        conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
        client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential clientConfiguration:conf];
        
        /**
         // 自签名模式
         id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
         // 您需要在这里依照OSS规定的签名算法，实现加签一串字符内容，并把得到的签名传拼接上AccessKeyId后返回
         // 一般实现是，将字符内容post到您的业务服务器，然后返回签名
         // 如果因为某种原因加签失败，描述error信息后，返回nil
         NSString *signature = [OSSUtil calBase64Sha1WithData:contentToSign withSecret:SecretKey]; // 这里是用SDK内的工具函数进行本地加签，建议您通过业务server实现远程加签
         if (signature != nil) {
         *error = nil;
         } else {
         *error = [NSError errorWithDomain:AliYunHost code:-1001 userInfo:@{}];
         return nil;
         }
         return [NSString stringWithFormat:@"OSS %@:%@", AccessKey, signature];
         }];
         client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
         **/
        
        /**
         //直接设置STSToken,阿里云官方不建议使用,会出现警告
         id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AccessKey secretKey:SecretKey];
         client = [[OSSClient alloc] initWithEndpoint:AliYunHost credentialProvider:credential];
         **/
        
    });
    return _upload;
}
- (void)uploadImages:(NSArray<UIImage *> *)images originalPhoto:(BOOL)originalPhoto isAsync:(BOOL)isAsync complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < images.count; i ++) {
        UIImage *image = images[i];
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest *put = [OSSPutObjectRequest new];
                put.contentType=@"image/jpeg";
                put.bucketName = BucketName;
                NSData *data;
                NSData *data1 = UIImageJPEGRepresentation(image, 1);
                float length1 = [data1 length] / 1024;
                if (length1 < 400) {
                    data = UIImageJPEGRepresentation(image, 1);
                }else {
                    if (originalPhoto) {
                        data = UIImageJPEGRepresentation(image, 1);
                    }else {
                        data = UIImageJPEGRepresentation(image, 0.6);
                    }
                }
                NSString *imageName = [NSString stringWithFormat:@"ios/%@%d.jpg",[IHUtility getTransactionID],i];  //加“i”防止数组图片重名
                put.objectKey = imageName;
                [callBackNames addObject:[NSString stringWithFormat:@"%@%@", ImageHeaderUrl, imageName]];
                put.uploadingData = data;
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                if (isAsync) {
                    if (image == images.lastObject) {
                        NSLog(@"upload object finished!");
                        if (complete) {
                            complete([NSArray arrayWithArray:callBackNames] ,UploadImageSuccess);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        if (complete) {
            complete([NSArray arrayWithArray:callBackNames], UploadImageSuccess);
        }
    }
}
+ (void)asyncUploadImage:(UIImage *)image originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSString *name, UploadImageState state))complete {
    [[AliOSSUpload shareInstance] uploadImages:@[image] originalPhoto:originalPhoto isAsync:YES complete:^(NSArray<NSString *> *names, UploadImageState state) {
        if (complete) {
            complete(names[0], state);
        }
    }];
}
+ (void)syncUploadImage:(UIImage *)image originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSString *name, UploadImageState state))complete {
    [[AliOSSUpload shareInstance] uploadImages:@[image] originalPhoto:originalPhoto isAsync:NO complete:^(NSArray<NSString *> *names, UploadImageState state) {
        if (complete) {
            complete(names[0], state);
        }
    }];
}
+ (void)asyncUploadImages:(NSArray<UIImage *> *)images originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete {
    [[AliOSSUpload shareInstance] uploadImages:images originalPhoto:originalPhoto isAsync:YES complete:complete];
}
+ (void)syncUploadImages:(NSArray<UIImage *> *)images originalPhoto:(BOOL)originalPhoto complete:(void(^)(NSArray<NSString *> *names, UploadImageState state))complete {
    [[AliOSSUpload shareInstance] uploadImages:images originalPhoto:originalPhoto isAsync:NO complete:complete];
}
@end
