//
//  UIColor(Addition).h
//  CaiYun
//
//  Created by penghanbin on 12-12-17.
//
//

#import <UIKit/UIKit.h>

#define UIColorWithRGB(r, g, b) [UIColor colorWithRed:(CGFloat)(r)/255 green:(CGFloat)(g)/255 blue:(CGFloat)(b)/255 alpha:1]
#define UIColorWithPure(c) UIColorWithRGB(c, c, c)
#define kDefaultColorForBlackText UIColorWithPure(60)
#define kDefaultColorSystemHighlight UIColorWithPure(217)

@interface UIColor(Addition)

+ (UIColor *)colorWithHex:(unsigned int)rgbValue;
+ (UIColor *)colorWithHexString:(NSString *)hexColor;
+ (UIColor *)colorRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

@end
