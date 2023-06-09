/********************************************************************************
 * 文件名称：BellListViewController.m
 * 内容摘要：壶铃数据列表
 * 版本编号：1.0.1
 * 创建日期：2019年04月13日
 ********************************************************************************/

#import "BellListViewController.h"
#import "SportListViewController.h"

@interface BellListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView      *m_kettleBellTableView; // 设备列表
    NSMutableArray   *m_kettleBellArray;     // 设备列表数据
}

@end

@implementation BellListViewController

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_kettleBellArray = [[NSMutableArray alloc] initWithArray:self.dataArray];
    [self loadHeadView];
    [self loadContentView];
}


/********************************************************************************
 * 方法名称：didReceiveMemoryWarning
 * 功能描述：内存警告时，释放内存
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - **************************** 加载界面 *****************************
/********************************************************************************
 * 方法名称：loadHeadView
 * 功能描述：获取头视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadHeadView {
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    powerView.backgroundColor = [UIColor clearColor];
    [headerBackView addSubview:powerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"KettleBell List";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    [headerBackView addSubview:titleLab];
    
    UIButton *headLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
    headLeftBtn.backgroundColor = [UIColor clearColor];
    [headLeftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBtn];
    
    UIImageView *headLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 24, 24)];
    headLeftImg.backgroundColor = [UIColor clearColor];
    headLeftImg.image = [UIImage imageNamed:@"img_app_back.png"];
    [headLeftBtn addSubview:headLeftImg];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerBackView addSubview:lineView];
}


/********************************************************************************
 * 方法名称：loadContentView
 * 功能描述：获取内容视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadContentView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    footerView.backgroundColor = [UIColor clearColor];
    
    m_kettleBellTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_kettleBellTableView.delegate = self;
    m_kettleBellTableView.dataSource = self;
    m_kettleBellTableView.backgroundColor = [UIColor clearColor];
    [m_kettleBellTableView setTableFooterView:footerView];
    m_kettleBellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_kettleBellTableView];
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - **************************** 列表回调 *****************************
/********************************************************************************
 * 方法名称：numberOfSectionsInTableView
 * 功能描述：设置TableView的块数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


/********************************************************************************
 * 方法名称：numberOfRowsInSection
 * 功能描述：设置TableView的行数
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return m_kettleBellArray.count;
}


/********************************************************************************
 * 方法名称：heightForRowAtIndexPath
 * 功能描述：设置TableView的行高
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


/********************************************************************************
 * 方法名称：heightForHeaderInSection
 * 功能描述：设置TableView的块的头UI的高度
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}


/********************************************************************************
 * 方法名称：viewForHeaderInSection
 * 功能描述：设置TableView的块的头UI
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *lineB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    lineB.backgroundColor = [UIColor clearColor];
    [headView addSubview:lineB];
    
    return headView;
}


/********************************************************************************
 * 方法名称：cellForRowAtIndexPath
 * 功能描述：设置TableView的行UI
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellString = @"KettleBellListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *weightGrade = [[m_kettleBellArray objectAtIndex:indexPath.row] objectForKey:@"weightGrade"];
    NSString *userNumber = [[m_kettleBellArray objectAtIndex:indexPath.row] objectForKey:@"userNumber"];
    NSString *sportNumber = [[m_kettleBellArray objectAtIndex:indexPath.row] objectForKey:@"sportNumber"];
    NSString *startTime = [[m_kettleBellArray objectAtIndex:indexPath.row] objectForKey:@"startTime"];
    NSString *endTime = [[m_kettleBellArray objectAtIndex:indexPath.row] objectForKey:@"endTime"];
    
    UILabel *userLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-80, 25)];
    userLab.textAlignment = NSTextAlignmentLeft;
    userLab.font = [UIFont systemFontOfSize:15];
    userLab.textColor = [UIColor blackColor];
    userLab.text = [NSString stringWithFormat:@"User Number: P%@",userNumber];
    [cell.contentView addSubview:userLab];
    
    UILabel *weightLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-80, 25)];
    weightLab.textAlignment = NSTextAlignmentLeft;
    weightLab.font = [UIFont systemFontOfSize:15];
    weightLab.textColor = [UIColor blackColor];
    weightLab.text = [NSString stringWithFormat:@"Weight: %@LB",weightGrade];
    [cell.contentView addSubview:weightLab];
    
    UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width-80, 25)];
    numberLab.textAlignment = NSTextAlignmentLeft;
    numberLab.font = [UIFont systemFontOfSize:15];
    numberLab.textColor = [UIColor blackColor];
    numberLab.text = [NSString stringWithFormat:@"Number: %@",sportNumber];
    [cell.contentView addSubview:numberLab];
    
    UILabel *startTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, self.view.frame.size.width-80, 25)];
    startTimeLab.textAlignment = NSTextAlignmentLeft;
    startTimeLab.font = [UIFont systemFontOfSize:15];
    startTimeLab.textColor = [UIColor blackColor];
    startTimeLab.text = [NSString stringWithFormat:@"startTime: %@",startTime];
    [cell.contentView addSubview:startTimeLab];
    
    UILabel *endTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width-80, 25)];
    endTimeLab.textAlignment = NSTextAlignmentLeft;
    endTimeLab.font = [UIFont systemFontOfSize:15];
    endTimeLab.textColor = [UIColor blackColor];
    endTimeLab.text = [NSString stringWithFormat:@"endTime: %@",endTime];
    [cell.contentView addSubview:endTimeLab];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-35, 65, 20, 20)];
    nextImg.backgroundColor = [UIColor clearColor];
    nextImg.image = [UIImage imageNamed:@"img_app_next.png"];
    [cell.contentView addSubview:nextImg];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 148, self.view.frame.size.width, 2)];
    lineView.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:lineView];
    
    return cell;
}


/********************************************************************************
 * 方法名称：didSelectRowAtIndexPath
 * 功能描述：设置TableView的行的触发方法
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sportList = [[m_kettleBellArray objectAtIndex:indexPath.row] objectForKey:@"sportList"];
    
    SportListViewController *sportView = [[SportListViewController alloc] init];
    sportView.sportInfoArrray = sportList;
    [self.navigationController pushViewController:sportView animated:YES];
}


@end
