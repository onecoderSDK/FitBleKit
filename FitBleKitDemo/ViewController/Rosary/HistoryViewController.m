//
//  HistoryViewController.m
//  RosaryDemo
//
//  Created by apple on 2017/4/20.
//  Copyright © 2017年 CS. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView    *m_historyTable;
    NSMutableArray *m_historyArray;
}

@end

@implementation HistoryViewController
@synthesize dataArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadHeaderUI];
    
    m_historyArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    m_historyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    m_historyTable.delegate = self;
    m_historyTable.dataSource = self;
    m_historyTable.backgroundColor = [UIColor clearColor];
    m_historyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_historyTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ************************ Load UI ****************************
/***************************************************************************
 * MethodName :loadHeaderUI
 * Function   :get header UI
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
- (void)loadHeaderUI
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 68)];
    headerBackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    powerView.backgroundColor = [UIColor whiteColor];;
    [headerBackView addSubview:powerView];
    
    UIButton *headLeftBigBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headLeftBigBtn.backgroundColor = [UIColor clearColor];
    headLeftBigBtn.frame = CGRectMake(0, 20, 60, 48);
    [headLeftBigBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBigBtn];
    
    UIButton *headLeftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headLeftBtn.backgroundColor = [UIColor clearColor];
    headLeftBtn.frame = CGRectMake(0, 20, 60, 48);
    [headLeftBtn setTitle:@"back" forState:UIControlStateNormal];
    [headLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headLeftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBtn];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 48)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"History";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:16];
    [headerBackView addSubview:titleLab];
}

#pragma mark - ************************ Delegate ***************************
/***************************************************************************
 * MethodName :numberOfSectionsInTableView
 * Function   :number Of Sections In TableView
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/***************************************************************************
 * MethodName :numberOfRowsInSection
 * Function   :number Of Rows In Section
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_historyArray count];
}

/***************************************************************************
 * MethodName :heightForRowAtIndexPath
 * Function   :height For Row At IndexPath
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/***************************************************************************
 * MethodName :heightForHeaderInSection
 * Function   :height For Header In Section
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

/***************************************************************************
 * MethodName :viewForHeaderInSection
 * Function   :view For Header In Section
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    tableHeadView.backgroundColor = [UIColor clearColor];
    
    return tableHeadView;
}

/***************************************************************************
 * MethodName :cellForRowAtIndexPath
 * Function   :cell For Row At IndexPath
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"MySetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    for (id view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dataDic = [m_historyArray objectAtIndex:indexPath.row];
    NSString *startTime = [dataDic objectForKey:@"startTime"];
    NSString *endTime = [dataDic objectForKey:@"endTime"];
    NSString *beadNumber = [dataDic objectForKey:@"beadNumber"];
    NSString *bookId = [dataDic objectForKey:@"bookId"];
    
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 80)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.font = [UIFont systemFontOfSize:14];
    titleName.textColor = [UIColor blackColor];
    titleName.numberOfLines = 4;
    titleName.text = [NSString stringWithFormat:@"startTime: %@\nendTime: %@\nBookId: %@\nbeadNumber: %@",startTime,endTime,bookId,beadNumber];
    [cell.contentView addSubview:titleName];
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 79.3, self.view.frame.size.width, 0.7)];
    myLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:myLine];
    
    return cell;
}

/***************************************************************************
 * MethodName :didSelectRowAtIndexPath
 * Function   :did Select Row At IndexPath
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
