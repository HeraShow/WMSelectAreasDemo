//
//  WMAreaSeeTableViewCell.h
//  WMSelectAreasDemo
//
//  Created by 冯文秀 on 16/11/23.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMAreaSeeTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIImageView *enterImgView;
@property (nonatomic, strong) UIView *stripeLine;

- (void)configureAreaLabelWithDic:(NSDictionary *)fareDic;
+ (CGFloat)configureAreaSeeCellHeightWithDic:(NSDictionary *)fareDic;
@end
