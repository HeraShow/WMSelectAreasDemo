//
//  WMAreaSeeTableViewCell.m
//  WMSelectAreasDemo
//
//  Created by 冯文秀 on 16/11/23.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import "WMAreaSeeTableViewCell.h"

@implementation WMAreaSeeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.areaLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 8, KScreenWidth - 56, 21)];
        self.areaLabel.font = WMH5MFont;
        self.areaLabel.textColor = WMHPDark;
        self.areaLabel.textAlignment = NSTextAlignmentLeft;
        self.areaLabel.numberOfLines = 0;
        [self.contentView addSubview:_areaLabel];
        
        self.enterImgView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 22, 11, 9, 15)];
        self.enterImgView.image = [UIImage imageNamed:@"wemart_enter"];
        [self.contentView addSubview:_enterImgView];
        
        self.stripeLine = [[UIView alloc]initWithFrame:CGRectMake(0, 37, KScreenWidth, 1)];
        self.stripeLine.backgroundColor = WMShopBg;
        [self.contentView addSubview:_stripeLine];
        
    }
    return self;
}

- (void)configureAreaLabelWithDic:(NSDictionary *)fareDic
{
    NSArray *listArray = fareDic[@"cityList"];
    NSString *areaStr = [NSString string];
    for (NSInteger i = 0; i < listArray.count; i++) {
        NSDictionary *dic = listArray[i];
        if (i == 0) {
            areaStr = [areaStr stringByAppendingString:dic[@"city"]];
        }
        else{
            areaStr = [areaStr stringByAppendingString:[NSString stringWithFormat:@"、%@", dic[@"city"]]];
        }
    }
    self.areaLabel.text = areaStr;
    CGRect areaBounds = [areaStr boundingRectWithSize:CGSizeMake(KScreenWidth - 56, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:WMH5MFont forKey:NSFontAttributeName] context:nil];
    if (areaBounds.size.height > 21) {
        CGFloat aValue = areaBounds.size.height/2 - 10.5;
        self.areaLabel.frame = CGRectMake(18, 8, KScreenWidth - 56, areaBounds.size.height);
        self.enterImgView.frame = CGRectMake(KScreenWidth - 22, 11 + aValue, 9, 15);
        self.stripeLine.frame = CGRectMake(0, 37 + areaBounds.size.height - 22, KScreenWidth, 1);
    }
}

+ (CGFloat)configureAreaSeeCellHeightWithDic:(NSDictionary *)fareDic
{
    NSArray *listArray = fareDic[@"cityList"];
    NSString *areaStr = [NSString string];
    for (NSInteger i = 0; i < listArray.count; i++) {
        NSDictionary *dic = listArray[i];
        if (i == 0) {
            areaStr = [areaStr stringByAppendingString:dic[@"city"]];
        }
        else{
            areaStr = [areaStr stringByAppendingString:[NSString stringWithFormat:@"、%@", dic[@"city"]]];
        }
    }
    
    CGRect areaBounds = [areaStr boundingRectWithSize:CGSizeMake(KScreenWidth - 56, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:WMH5MFont forKey:NSFontAttributeName] context:nil];
    if (areaBounds.size.height > 21) {
        return areaBounds.size.height + 17;
    }
    else{
        return 38;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
