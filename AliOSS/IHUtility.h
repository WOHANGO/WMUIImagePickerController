//
//  IHUtility.h
//  YJJSApp
//
//  Created by DT on 2018/3/21.
//  Copyright © 2018年 dt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface IHUtility : NSObject
+(UIImage *)rotateAndScaleImage:(UIImage *)image maxResolution:(NSInteger)maxResolution;
//随机数
+ (NSString*)getTransactionID;
//获取当前时间戳  （以毫秒为单位）
+(NSString *)getNowTimeTimestamp;
//获取时间（刚刚）
+(NSString *)createdTimeStr:(NSString *)time;
+(float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+(NSString*)stringFromDate:(NSDate *)date;
+ (BOOL)checkPhoneValidate:(NSString*)str;
//宽度
+(CGSize)withText:(NSString *)text font:(CGFloat)font;
+(void)blurEffect:(UIView *)view;
+(CGSize)GetSizeByText:(NSString *)text sizeOfFont:(CGFloat)sizeOfFont width:(int)width;
//高度
+(CGFloat)withText:(NSString *)text font:(CGFloat)font width:(CGFloat)width;

+(BOOL)judgePassWordLegal:(NSString *)pass;
+ (NSString*)MD5Encode:(NSString*)input;
+(void)saveDicUserDefaluts:(NSDictionary *)dic  key:(NSString *)key;
+(NSDictionary*)getUserDefalutDic:(NSString *)key;
//判断非空
+ (BOOL) isBlankString:(NSString *)string;
@end
