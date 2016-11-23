//
//  WMPubilcPCH.h
//  WMSelectAreasDemo
//
//  Created by 冯文秀 on 16/11/23.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#ifndef WMPubilcPCH_h
#define WMPubilcPCH_h

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWScale (KScreenWidth / 375.f)
#define KScreenHScale (KScreenHeight / 667.f)

#define ColorRGB(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]
// 背景色
#define WMShopBg ColorRGB(240, 243, 245, 1)
#define WMLineColor ColorRGB(195, 198, 198, 1)
#define WMNavBgColor ColorRGB(249, 249, 249, 1)
#define WMBlueColor ColorRGB(16, 169, 235, 1)

// 文本颜色
#define WMContent1Color ColorRGB(10, 28, 28, 1)
#define WMContent2Color ColorRGB(83, 89, 89, 1)
#define WMContent3Color ColorRGB(140, 144, 145, 1)
#define WMHPDark ColorRGB(55, 59, 64, 1)

// 字体
#define WMS1Font [UIFont fontWithName:@"PingFangSC-Light"size:14]
#define WMH5MFont [UIFont fontWithName:@"PingFangSC-Medium"size:14]

#endif /* WMPubilcPCH_h */
