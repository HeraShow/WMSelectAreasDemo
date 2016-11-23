//
//  WMSelCityTabHeaderView.m
//  微猫商户端
//
//  Created by 冯文秀 on 16/11/16.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import "WMSelCityTabHeaderView.h"
@implementation WMSelCityTabHeaderView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.selectButton = [[UIButton alloc]initWithFrame:CGRectMake(17, 13 * KScreenWScale + 6, 20, 20)];
        [self.selectButton setImage:[UIImage imageNamed:@"wemart_sel_empty"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"wemart_selected"] forState:UIControlStateSelected];
        [self.selectButton addTarget:self action:@selector(wheatherSelected:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_selectButton];
        
        self.provLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 16, 128, 26 * KScreenWScale)];
        self.provLabel.font = WMH5MFont;
        self.provLabel.textColor = WMHPDark;
        self.provLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_provLabel];
        
        self.pullButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 42, 13 * KScreenWScale + 10, 26, 14)];
        [self.pullButton setImage:[UIImage imageNamed:@"wemart_down"] forState:UIControlStateNormal];
        [self.pullButton addTarget:self action:@selector(pullCityInfo:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_pullButton];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 26 * KScreenWScale + 31.5, KScreenWidth, 0.5)];
        lineView.backgroundColor = WMLineColor;
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

#pragma mark --- 是否选中 ---
- (void)wheatherSelected:(UIButton *)select
{
    select.selected = !select.selected;
    if ([self.delegate respondsToSelector:@selector(signWheatherSelected:)]) {
        [self.delegate signWheatherSelected:self];
    }
}

#pragma mark --- 点击 显示或收起二级菜单 ---
- (void)pullCityInfo:(UIButton *)pull
{
    if ([self.delegate respondsToSelector:@selector(showCityWithPullSecondMenu:)]) {
        [self.delegate showCityWithPullSecondMenu:self];
    }
}

- (void)configureProvinceWithString:(NSString *)provStr
{
    self.provLabel.text = provStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
