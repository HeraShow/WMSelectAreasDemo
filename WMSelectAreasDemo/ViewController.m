//
//  ViewController.m
//  WMSelectAreasDemo
//
//  Created by 冯文秀 on 16/11/23.
//  Copyright © 2016年 冯文秀. All rights reserved.
//

#import "ViewController.h"
#import "WMSelAreaViewController.h"
#import "WMAreaSeeTableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *areasTableView;
@property (nonatomic, strong) NSMutableArray *areaArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = WMShopBg;
    self.navigationItem.title = @"地区显示";
    self.navigationController.navigationBar.barTintColor = WMNavBgColor;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCitySelected:) name:@"refreshCitySelected" object:nil];
    
    // 数据源格式 对应了后台请求所得数据规范
    NSDictionary *dic1 = @{@"cityList":@[@{@"city":@"上海市",@"cityNo":@73,@"province":@""}], @"cityNo":@0, @"cityNoList":@[@73]};
    NSDictionary *dic2 = @{@"cityList":@[@{@"city":@"无锡市",@"cityNo":@75,@"province":@""}, @{@"city":@"苏州市",@"cityNo":@78,@"province":@""}, @{@"city":@"南通市",@"cityNo":@79,@"province":@""}], @"cityNo":@0, @"cityNoList":@[@75, @78, @79]};
    NSDictionary *dic3 = @{@"cityList":@[@{@"city":@"嘉兴市",@"cityNo":@90,@"province":@""}, @{@"city":@"杭州市",@"cityNo":@87,@"province":@""}, @{@"city":@"宁波市",@"cityNo":@88,@"province":@""}], @"cityNo":@0, @"cityNoList":@[@90, @87, @88]};
    self.areaArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i++) {
        if (i == 0 || i == 3 || i == 6) {
            [self.areaArray addObject:dic1];
        }
        if (i == 1 || i == 4 || i == 7) {
            [self.areaArray addObject:dic2];
        }
        if (i == 2 || i == 5 || i == 8) {
            [self.areaArray addObject:dic3];
        }
    }

    self.areasTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStylePlain];
    self.areasTableView.backgroundColor = WMShopBg;
    self.areasTableView.delegate = self;
    self.areasTableView.dataSource = self;
    self.areasTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.areasTableView registerClass:[WMAreaSeeTableViewCell class] forCellReuseIdentifier:@"areaSee"];
    [self.view addSubview:_areasTableView];
}

#pragma mark --- areasTableView 代理方法 ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.areaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMAreaSeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaSee" forIndexPath:indexPath];
    [cell configureAreaLabelWithDic:self.areaArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [WMAreaSeeTableViewCell configureAreaSeeCellHeightWithDic:self.areaArray[indexPath.row]];
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMSelAreaViewController *selAreaVc = [[WMSelAreaViewController alloc]init];
    selAreaVc.indexNum = indexPath.row;
    selAreaVc.fareDic = self.areaArray[indexPath.row];
    [self.navigationController pushViewController:selAreaVc animated:YES];
}

#pragma mark --- 刷新显示 ---
- (void)refreshCitySelected:(NSNotification *)notification
{
    NSDictionary *fareDic = notification.userInfo;
    NSInteger index = [notification.object integerValue];
    [self.areaArray replaceObjectAtIndex:index withObject:fareDic];
    [self.areasTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
