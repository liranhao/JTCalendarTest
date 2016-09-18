//
//  UIColor(Addition).m
//  CaiYun
//
//  Created by penghanbin on 12-12-17.
//
//

#import "UIColor(Addition).h"

@implementation UIColor(Addition)

+ (UIColor *)colorWithHex:(unsigned int)rgbValue
{
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}

+ (UIColor*)colorRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha {
    return [UIColor colorWithRed:(CGFloat)red/255 green:(CGFloat)green/255 blue:(CGFloat)blue/255 alpha:(CGFloat)alpha/255];
}

@end
