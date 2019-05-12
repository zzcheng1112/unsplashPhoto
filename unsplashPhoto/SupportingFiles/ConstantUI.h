//
//  Header.h
//  MyHouseKeeper
//
//  Created by System Administrator on 16/5/7.
//  Copyright © 2016年 llf-iphone. All rights reserved.
//

#ifndef Header_h
#define Header_h

                     
//判断是否是真机状态
#if TARGET_IPHONE_SIMULATOR
#define TRUEPHONE 0
#elif TARGET_OS_IPHONE
#define TRUEPHONE 1
#endif

//根据是否是iPhone X设置高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

//2:定义日志输出，调试状态打印，发布状态，不会打印

#ifdef DEBUG
// 调试状态
#define MyLog(...) NSLog(__VA_ARGS__)
#else
// 发布状态
#define MyLog(...)

#endif

//8:获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#pragma mark - Color define
#define RGBCOLOR(r,g,b)                                     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)                                  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define RGBCOLOR_HEX(h)                                     RGBCOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF))
#define RGBACOLOR_HEX(h,a)                                  RGBACOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF), (a))
#define RGBPureColor(h)                                     RGBCOLOR(h, h, h)
#define HSVCOLOR(h,s,v)                                     [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a)                                  [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]
#define RGBA(r,g,b,a)                                       (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)



// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//导航栏背景色
#define COLOR_COMMON_BLUE [UIColor colorWithRed:42/255.0 green:45/255.0 blue:82/255.0 alpha:1]

#define GLOBLE_BLUE [UIColor colorWithHexString:@"#008cee"]

//分割线使用颜色
#define SEPERATE_GRAY [UIColor colorWithHexString:@"#dcdcdc"]

//随机色
#define RGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RandColor RGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))         

//全局默认红色
#define GLOBLE_RED @"#178CFE"

#pragma mark - Screen Size define

//1:屏幕宽高
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
//4:全局字段
#define   SIZEWIDTH  [[UIScreen mainScreen] bounds].size.width  //宽
#define   SIZEHEIGHT  [[UIScreen mainScreen] bounds].size.height  //高

//5:适配
#define IPHONE5 ([[UIScreen mainScreen] bounds].size.height>520&&[UIScreen mainScreen] bounds].size.height<650)?YES:NO
#define IPHONE6 ([[UIScreen mainScreen] bounds].size.height>650&&[UIScreen mainScreen] bounds].size.height<730)?YES:NO
#define IPHONE6P [[UIScreen mainScreen] bounds].size.height>730?YES:NO
#define IPHONE4 [[UIScreen mainScreen] bounds].size.height<520?YES:NO

#define LEFTEDGE SIZEWIDTH/15
#define TOPEDGE SIZEHEIGHT/26.6

//iPhone X
// iPhone X
#define  LL_iPhoneX (SIZEWIDTH == 375.f && SIZEHEIGHT == 812.f ? YES : NO)
//判断iPHoneXr
#define LL_iPhoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs
#define LL_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhoneXs Max
#define LL_iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

// Status bar height.
#define  LL_StatusBarHeight      ((LL_iPhoneX||LL_iPhoneXr||LL_iPhoneXs||LL_iPhoneXs_Max) ? 44.f : 20.f)

// Navigation bar height.
#define  LL_NavigationBarHeight  44.f

// Tabbar height.
#define  LL_TabbarHeight         ((LL_iPhoneX||LL_iPhoneXr||LL_iPhoneXs||LL_iPhoneXs_Max) ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  LL_TabbarSafeBottomMargin         ((LL_iPhoneX||LL_iPhoneXr||LL_iPhoneXs||LL_iPhoneXs_Max) ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  LL_StatusBarAndNavigationBarHeight  ((LL_iPhoneX||LL_iPhoneXr||LL_iPhoneXs||LL_iPhoneXs_Max) ? 88.f : 64.f)
#define LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})


// 7.常用的对象
#define YTFNotificationCenter [NSNotificationCenter defaultCenter]

// 1.判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
// 2.判断是否为iOS8
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
// 3.判断是否为iOS9
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
// 4.判断是否为iOS10
#define iOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
// 5.判断是否为iOS11
#define iOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)


// 字数最大限制
#define KEYOFFSETY   100

// 通用背景色
#define BackGroundColor @"#F7F7F7"

#define GLOBLE_BACK @"@#F4F5F7"

#define GlobleBlue @"#4EA6FF"


// 像素点适配
#define WIDHT    SIZEWIDTH /750.0
#define HEIGHT   ((LL_iPhoneX||LL_iPhoneXr||LL_iPhoneXs||LL_iPhoneXs_Max)?(SIZEHEIGHT/1624.0):(SIZEHEIGHT/1334.0))

// 字体适配
#define MyFont ((WIDHT<0.5)?(WIDHT*2):1)

#endif /* Header_h */

