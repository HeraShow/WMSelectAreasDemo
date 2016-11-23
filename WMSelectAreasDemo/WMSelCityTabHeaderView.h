//
//  WMSelCityTabHeaderView.h
//  微猫商户端
//
//  Created by 冯文秀 on 16/11/16.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMSelCityTabHeaderView;
@protocol ShowCityDelegate <NSObject>
- (void)showCityWithPullSecondMenu:(WMSelCityTabHeaderView *)selectView;
- (void)signWheatherSelected:(WMSelCityTabHeaderView *)selectView;
@end

@interface WMSelCityTabHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *provLabel;
@property (nonatomic, strong) UIButton *pullButton;
@property (nonatomic, assign) id <ShowCityDelegate> delegate;

- (void)configureProvinceWithString:(NSString *)provStr;
@end
