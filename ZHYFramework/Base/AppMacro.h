//
//  AppMacro.h
//  YSWB
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

// 16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBA(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define UINavigationBarColor  UIColorFromRGB(0x36A2F3)

#define BoldSystemFont(size)  [UIFont boldSystemFontOfSize:size]
#define SystemFont(size)      [UIFont systemFontOfSize:size]
#define isIOS7                [[UIDevice currentDevice].systemVersion doubleValue]>=7.0?YES:NO
#define SYSTEM_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]

#define STATUSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVBAR_HEIGHT         (44.f + ((SYSTEM_VERSION >= 7) ? STATUSBAR_HEIGHT : 0))
#define TabBar_HEIGHT          49

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define FULL_WIDTH            SCREEN_WIDTH
#define FULL_HEIGHT           (SCREEN_HEIGHT - ((SYSTEM_VERSION >= 7) ? 0 : STATUSBAR_HEIGHT))
#define CONTENT_HEIGHT        (FULL_HEIGHT - NAVBAR_HEIGHT)

// 获取 View 的 frame 的属性
#define GetViewWidth(view)    view.frame.size.width
#define GetViewHeight(view)   view.frame.size.height
#define GetViewX(view)        view.frame.origin.x
#define GetViewY(view)        view.frame.origin.y

//常用变量

#ifdef DEBUG
#define DebugLog(s, ...) NSLog(@"\n  %s(%d): %@\n", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DebugLog(s, ...)
#endif

#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]
#define kKeyWindow [UIApplication sharedApplication].keyWindow


#ifndef zyweakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define zyweakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define zyweakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
    #endif
    #else
        #if __has_feature(objc_arc)
            #define zyweakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define zyweakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef zystrongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define zystrongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define zystrongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define zystrongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define zystrongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#endif /* AppMacro_h */
