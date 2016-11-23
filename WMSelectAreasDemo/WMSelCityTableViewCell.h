//
//  WMSelCityTableViewCell.h
//  微猫商户端
//
//  Created by 冯文秀 on 16/11/16.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMSelCityTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *cityLabel;


- (void)configureSelectCityTableViewCell:(NSString *)cityStr;
@end
