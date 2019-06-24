//
//  WMUIOSSAuthCredentialProvider.m
//  ImagePickerController
//
//  Created by 吳梓杭 on 2018/6/21.
//  Copyright © 2018年 吳梓杭. All rights reserved.
//

#import "WMUIOSSAuthCredentialProvider.h"

@implementation WMUIOSSAuthCredentialProvider

- (instancetype)initWithAuthServerUrl:(NSString *)authServerUrl {
    return [self initWithAuthServerUrl:authServerUrl responseDecoder:nil];
}

- (instancetype)initWithAuthServerUrl:(NSString *)authServerUrl responseDecoder:(nullable OSSResponseDecoderBlock)decoder {
    
    self = [super initWithFederationTokenGetter:^OSSFederationToken * {
        NSURL * url = [NSURL URLWithString:authServerUrl];
        //        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        //添加请求头
        [urlRequest setValue:@"" forHTTPHeaderField:@""];
        
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:urlRequest
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [tcs setError:error];
                                                            return;
                                                        }
                                                        [tcs setResult:data];
                                                    }];
        [sessionTask resume];
        [tcs.task waitUntilFinished];
        if (tcs.task.error) {
            return nil;
        } else {
            NSData* data = tcs.task.result;
            if(decoder){
                data = decoder(data);
            }
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:nil];
            int statusCode = [[object objectForKey:@"errorCode"] intValue];
            if (statusCode == 00) {
                OSSFederationToken * token = [OSSFederationToken new];
                // All the entries below are mandatory.
                NSDictionary *credentialsDict = [[object objectForKey:@"data"] objectForKey:@"credentials"];
                token.tAccessKey = [credentialsDict objectForKey:@"accessKeyId"];
                token.tSecretKey = [credentialsDict objectForKey:@"accessKeySecret"];
                token.tToken = [credentialsDict objectForKey:@"securityToken"];
                token.expirationTimeInGMTFormat = [credentialsDict objectForKey:@"expiration"];
                OSSLogDebug(@"token: %@ %@ %@ %@", token.tAccessKey, token.tSecretKey, token.tToken, [object objectForKey:@"Expiration"]);
                return token;
            }else{
                return nil;
            }
            
        }
    }];
    return self;
}


@end
