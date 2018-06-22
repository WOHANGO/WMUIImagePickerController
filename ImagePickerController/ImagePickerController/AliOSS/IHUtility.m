//
//  IHUtility.m
//  YJJSApp
//
//  Created by DT on 2018/3/21.
//  Copyright © 2018年 dt. All rights reserved.
//

#import "IHUtility.h"
#import <CommonCrypto/CommonDigest.h>
@implementation IHUtility

//表示常用方法，弹框，提示
+(UIImage *)rotateAndScaleImage:(UIImage *)image maxResolution:(NSInteger)maxResolution {
    
    int kMaxResolution;
    if (maxResolution <= 0)
        kMaxResolution = 640;
    else
        kMaxResolution = (int)maxResolution;
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//随机数
+ (NSString*)getTransactionID
{
    NSDate* date = [NSDate date];
    NSMutableString* strDate = [NSMutableString stringWithFormat:@"%@", date];
    NSString *s1=[strDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *s2= [s1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *s3= [s2 stringByReplacingOccurrencesOfString:@":" withString:@""];
    int n = (arc4random() % 9000) + 1000;
    NSMutableString* transactionID = [NSMutableString stringWithString:[s3 substringToIndex:14]];
    [transactionID appendString:[NSString stringWithFormat:@"%d", n]];
    
    [transactionID stringByReplacingOccurrencesOfString:@" " withString:@""];
    return transactionID;
}
//获取当前时间戳
+(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
//获取时间（刚刚）
+(NSString *)createdTimeStr:(NSString *)time{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:time];
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = timeInterval/3600) > 1 && (temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if ((temp = timeInterval/3600) > 24 && (temp = timeInterval/3600) < 48){
        result = [NSString stringWithFormat:@"昨天"];
    }else if ((temp = timeInterval/3600) > 48 && (temp = timeInterval/3600) < 72){
        result = [NSString stringWithFormat:@"前天"];
    }else{
        result = time;
    }
    return result;
}

+(float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height;
    return textHeight;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(NSString*)stringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}
+(CGSize)withText:(NSString *)text font:(CGFloat)font{
      CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    return tmpRect.size;
}
+(void)blurEffect:(UIView *)view{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectVIew = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectVIew.frame = view.bounds;
    [view addSubview:effectVIew];
}
//高度
+(CGFloat)withText:(NSString *)text font:(CGFloat)font width:(CGFloat)width{
    
    CGRect tmpRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height;
}

+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 6){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^[A-Za-z0-9]{6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}
+ (NSString*)MD5Encode:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
//验证手机号码
+ (BOOL)checkPhoneValidate:(NSString*)str
{
    if (str == nil || [str length] == 0 ) {
        //[YJTipView showBottomWithText:@"手机号码不能为空" bottomOffset:300 duration:1.5];
        return NO;
    }
    if([str length]!=11)
    {
      //  [YJTipView showBottomWithText:@"请输入正确的手机号码" bottomOffset:300 duration:1.5];
        return NO;
    }
    return YES;
}


+(CGSize)GetSizeByText:(NSString *)text sizeOfFont:(CGFloat)sizeOfFont width:(int)width{
    CGSize size;
    if (text==nil || [text length]==0) {
        size=CGSizeMake(320, 20);
        return size;
    }
    UIFont *font;
    if (sizeOfFont<=0) {
        font=[UIFont systemFontOfSize:12];
    }else {
        font=[UIFont systemFontOfSize:sizeOfFont];
    }
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:sizeOfFont]};
    size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:\
            NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:attribute context:nil].size;
    return size;
}
+(void)saveDicUserDefaluts:(NSDictionary *)dic  key:(NSString *)key{
    NSUserDefaults *userDefaluts=[NSUserDefaults standardUserDefaults];
    [userDefaluts setObject:dic forKey:key];
    [userDefaluts synchronize];
}

+(NSDictionary*)getUserDefalutDic:(NSString *)key{
    NSUserDefaults *userDefaluts=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[userDefaluts objectForKey:key];
    return dic;
}
//判断非空
+ (BOOL) isBlankString:(NSString *)string {
    if (string ==nil || string ==NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}
@end
