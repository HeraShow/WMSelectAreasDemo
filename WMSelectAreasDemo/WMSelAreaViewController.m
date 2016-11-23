//
//  WMSelAreaViewController.m
//  微猫商户端
//
//  Created by 冯文秀 on 16/11/16.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import "WMSelAreaViewController.h"
#import "WMSelCityTabHeaderView.h"
#import "WMSelCityTableViewCell.h"

@interface WMSelAreaViewController ()<UITableViewDelegate, UITableViewDataSource, ShowCityDelegate>
@property (nonatomic, strong) NSDictionary *totalDic;
@property (nonatomic, strong) NSDictionary *provDic;
@property (nonatomic, strong) NSDictionary *cityDic;
@property (nonatomic, strong) UITableView *selAreaTableView;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *provArray;
@property (nonatomic, strong) NSMutableArray *provNoArray;

@property (nonatomic, assign) BOOL firstShow;
@end

@implementation WMSelAreaViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WMShopBg;
    self.navigationItem.title = @"物流设置";
    self.navigationController.navigationBar.barTintColor = WMNavBgColor;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"wemart_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.leftBarButtonItem.tintColor = WMBlueColor;
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(confirmEdit)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.rightBarButtonItem.tintColor = WMBlueColor;
    
    // 本地地区数据源 txt
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.totalDic = [self receiveDicWithString:str];
    self.provDic = self.totalDic[@"province"];
    self.cityDic = self.totalDic[@"city"];
    self.selectIndex = -1;
    
    self.provArray = [NSMutableArray array];
    self.provNoArray = [NSMutableArray array];
    
    if ([self.fareDic[@"cityNoList"] count] != 0) {
        for (NSDictionary *cityDic in self.fareDic[@"cityList"]) {
            NSDictionary *dic = @{@"city":cityDic[@"city"], @"cityNo":cityDic[@"cityNo"], @"province":@""};
            [self.provArray addObject:dic];
            [self.provNoArray addObject:cityDic[@"cityNo"]];
        }
    }
    
    
    [self createSelAreaTableView];
}

#pragma mark --- 字符串解析成字典 ---
- (NSDictionary *)receiveDicWithString:(NSString *)str
{
    NSData *resultData = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    id result = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * messageDic = result;
    return messageDic;
}

#pragma mark --- 创建  selAreaTableView ---
- (void)createSelAreaTableView
{
    // 第一次显示 只展示分区 不显示cell
    self.firstShow = YES;
    self.selAreaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    self.selAreaTableView.delegate = self;
    self.selAreaTableView.dataSource = self;
    self.selAreaTableView.bounces = NO;
    self.selAreaTableView.sectionHeaderHeight = 26 * KScreenWScale + 32;
    [self.selAreaTableView registerClass:[WMSelCityTableViewCell class] forCellReuseIdentifier:@"selectCell"];
    [self.selAreaTableView registerClass:[WMSelCityTabHeaderView class] forHeaderFooterViewReuseIdentifier:@"slectHeader"];
    self.selAreaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_selAreaTableView];
}

#pragma mark --- selAreaTableView 代理方法 ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.provDic.allValues.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *provNo = self.provDic.allKeys[section];
    for (NSString *key in self.cityDic) {
        if ([provNo isEqualToString:key]) {
            NSArray *cityArray = self.cityDic[key];
            self.cityArray = cityArray;
        }
    }
    return _cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.firstShow) {
        return 0;
    }
    else{
        if (indexPath.section == self.selectIndex){
            return  26 * KScreenWScale + 24;
            
        }else  {
            return 0;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMSelCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell" forIndexPath:indexPath];
    NSString *provNo = self.provDic.allKeys[indexPath.section];
    for (NSString *key in self.cityDic) {
        if ([provNo isEqualToString:key]) {
            NSArray *cityArray = self.cityDic[key];
            self.cityArray = cityArray;
        }
    }
    NSArray *array = self.cityArray[indexPath.row];
    if (self.selectIndex == indexPath.section) {
        // 选中分区 含地区 则cell被选中
        NSNumber *cityNum = [NSNumber numberWithInteger:[array[0] integerValue]];
        if ([self.fareDic[@"cityNoList"] containsObject:cityNum]) {
            cell.selectButton.selected = YES;
        }
        else{
            cell.selectButton.selected = NO;
        }
        cell.selectButton.tag = 300 + indexPath.row;
        [cell.selectButton addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
        [cell configureSelectCityTableViewCell:array[1]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark --- 选择城市 ---
- (void)selectCity:(UIButton *)select
{
    NSInteger rowIndex = select.tag - 300;
    NSArray *cityArray = [NSArray array];
    NSString *provNo = self.provDic.allKeys[self.selectIndex];
    for (NSString *key in self.cityDic) {
        if ([provNo isEqualToString:key]) {
            cityArray = self.cityDic[key];
        }
    }
    NSArray *array = cityArray[rowIndex];
    NSString *cityNo = array[0];
    NSString *cityStr = array[1];
    NSNumber *cityNum = [NSNumber numberWithInteger:[cityNo integerValue]];
    select.selected = !select.selected;

    if (select.selected) {
        if (![self.fareDic[@"cityNoList"] containsObject:cityNum]) {
            NSDictionary *dic = @{@"city":cityStr, @"cityNo":cityNum, @"province":@""};
            [self.provArray addObject:dic];
            [self.provNoArray addObject:cityNum];

        }
    }
    else{
        NSDictionary *dic = @{@"city":cityStr, @"cityNo":cityNum, @"province":@""};
        [self.provArray removeObject:dic];
        [self.provNoArray removeObject:cityNum];
    }
    [self refreshFareDicWithArray:self.provArray arrayNo:self.provNoArray];

    NSInteger count = 0;
    for (NSArray *arr in cityArray) {
        NSNumber *arrNum = [NSNumber numberWithInteger:[arr[0] integerValue]];
        if ([self.fareDic[@"cityNoList"] containsObject:arrNum]) {
            count++;
        }
    }
    for (UIView *subViews in self.selAreaTableView.subviews) {
        if (subViews.tag == self.selectIndex + 100) {
            WMSelCityTabHeaderView *headerView = (WMSelCityTabHeaderView *)subViews;
            // 分区下 选中cell总数 与对应分区 地区数相同 则分区被选中
            if (count == cityArray.count) {
                headerView.selectButton.selected = YES;
            }
            // 反之 不选中
            else{
                headerView.selectButton.selected = NO;
            }
        }
    }
    [self.selAreaTableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WMSelCityTabHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"slectHeader"];
    headerView.delegate = self;
    NSString *provNo = self.provDic.allKeys[section];
    NSArray *cityArray = [NSArray array];
    for (NSString *key in self.cityDic) {
        if ([provNo isEqualToString:key]) {
            cityArray = self.cityDic[key];
        }
    }
    NSInteger count = 0;
    for (NSArray *arr in cityArray) {
        NSNumber *arrNum = [NSNumber numberWithInteger:[arr[0] integerValue]];
        if ([self.fareDic[@"cityNoList"] containsObject:arrNum]) {
            count++;
        }
    }
    // 分区下 选中cell总数 与对应分区 地区数相同 则分区被选中
    if (count == cityArray.count) {
        headerView.selectButton.selected = YES;
    }
    else{
        headerView.selectButton.selected = NO;
    }
    
    headerView.tag = 100 + section;
    if (!self.firstShow) {
        // 分区点击下拉 显示该分区cell
        if (self.selectIndex == section) {
            [headerView.pullButton setImage:[UIImage imageNamed:@"wemart_up"] forState:UIControlStateNormal];
        }
        else{
            [headerView.pullButton setImage:[UIImage imageNamed:@"wemart_down"] forState:UIControlStateNormal];
        }
    }
    else{
        [headerView.pullButton setImage:[UIImage imageNamed:@"wemart_down"] forState:UIControlStateNormal];
    }

    NSString *provStr = self.provDic.allValues[section];
    [headerView configureProvinceWithString:provStr];
    return headerView;
}


#pragma mark --- WMSelCityTabHeaderView 代理方法 ---
// 点击下拉
- (void)showCityWithPullSecondMenu:(WMSelCityTabHeaderView *)selectView
{
    if (selectView.tag - 100 == self.selectIndex) {
        UIImage *buttonImg = [selectView.pullButton imageForState:UIControlStateNormal];
        if ([buttonImg isEqual:[UIImage imageNamed:@"wemart_down"]]) {
            self.firstShow = NO;
        }
        else
        {
            self.firstShow = YES;
        }
    }
    else{
        // 对应选中 分区下标
        self.selectIndex = selectView.tag - 100;
        self.firstShow = NO;
    }
    [self.selAreaTableView reloadData];
}
// 点击选择按钮
- (void)signWheatherSelected:(WMSelCityTabHeaderView *)selectView
{
    NSInteger index = selectView.tag - 100;
    NSString *provNo = self.provDic.allKeys[index];
    NSArray *cityArray = [NSArray array];
    for (NSString *key in self.cityDic) {
        if ([provNo isEqualToString:key]) {
            cityArray = self.cityDic[key];
        }
    }
    if (selectView.selectButton.selected) {
        for (NSArray *arr in cityArray) {
            NSNumber *arrNum = [NSNumber numberWithInteger:[arr[0] integerValue]];
            if (![self.provNoArray containsObject:arrNum]) {
                NSDictionary *dic = @{@"city":arr[1], @"cityNo":arrNum, @"province":@""};
                [self.provArray addObject:dic];
                [self.provNoArray addObject:arrNum];
            }
        }
    }
    else{
        for (NSArray *arr in cityArray) {
            NSNumber *arrNum = [NSNumber numberWithInteger:[arr[0] integerValue]];
            NSDictionary *dic = @{@"city":arr[1], @"cityNo":arrNum, @"province":@""};
            [self.provArray removeObject:dic];
            [self.provNoArray removeObject:arrNum];
        }
    }
    [self refreshFareDicWithArray:self.provArray arrayNo:self.provNoArray];
    [self.selAreaTableView reloadData];
}

#pragma mark --- 刷新数组数据 ---
// 同步修改数据 便于返回传送
- (void)refreshFareDicWithArray:(NSMutableArray *)array arrayNo:(NSMutableArray *)arrayNo
{
    NSMutableDictionary *mutableDic = [self.fareDic mutableCopy];
    [mutableDic setObject:[arrayNo copy] forKey:@"cityNoList"];
    [mutableDic setObject:[array copy] forKey:@"cityList"];
    self.fareDic = [mutableDic copy];
}

#pragma mark --- 返回上一级 ---
- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 确定编辑 保存 ---
- (void)confirmEdit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCitySelected" object:[NSNumber numberWithInteger:self.indexNum]  userInfo:self.fareDic];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
