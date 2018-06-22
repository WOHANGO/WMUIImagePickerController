//
//  WZHOSSAuthCredentialProvider.h
//  ImagePickerController
//
//  Created by 吳梓杭 on 2018/6/21.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

@interface WZHOSSAuthCredentialProvider : OSSFederationCredentialProvider

- (instancetype _Nullable )initWithAuthServerUrl:(NSString *_Nullable)authServerUrl;
- (instancetype _Nullable )initWithAuthServerUrl:(NSString *_Nullable)authServerUrl responseDecoder:(nullable OSSResponseDecoderBlock)decoder;

@end
