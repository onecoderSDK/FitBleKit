/********************************************************************************
 * 文件名称：RosaryViewController.h
 * 内容摘要：念珠
 * 版本编号：1.0.1
 * 创建日期：2017年11月22日
 ********************************************************************************/

#import "RosaryViewController.h"
#import "BindDeviceViewController.h"
#import "SetViewController.h"
#import "HistoryViewController.h"

@interface RosaryViewController ()<DeviceIdDelegate,UITableViewDelegate,UITableViewDataSource,
FBKApiRosaryDelegate,FBKApiBsaeDataSource>
{
    NSString *m_myDeviceUuid;
    UITableView    *m_demoTable;
    NSMutableArray *m_demoArray;
    int m_setBeadNumber;
    int m_myBeadNumber;
    int m_remindType;
    int m_myRemindType;
    NSString *m_tipNumber;
    FBKApiRosary *m_rosaryApi;
    NSString *m_powerNum;
    NSString *m_stepNum;
    int m_bluePair;
    int m_bookIdNum;
    int m_timeCount;
    NSMutableArray *m_historyArray;
    BOOL m_isLoading;
    int m_beadNowState;
    
    NSString   *m_rosaryId; // 念珠ID
    UILabel    *m_alertLab; // 连接状态
    BOOL       m_isBleAvailable;      // 蓝牙是否可用状态
}


@end

@implementation RosaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_isBleAvailable = NO;
    
    m_tipNumber = @"--";
    m_remindType = 0;
    m_myRemindType = -1;
    m_setBeadNumber = 12;
    m_myBeadNumber = 0;
    m_myDeviceUuid = [[NSString alloc] init];
    m_powerNum = @"--";
    m_stepNum = @"--";
    m_bluePair = 2;
    m_bookIdNum = 1;
    m_timeCount = 0;
    m_historyArray = [[NSMutableArray alloc] init];
    m_isLoading = NO;
    m_beadNowState = 2;
    
    m_rosaryId = [[NSString alloc] init];
    m_rosaryApi = [[FBKApiRosary alloc] init];
    m_rosaryApi.delegate = self;
    m_rosaryApi.dataSource = self;

    m_demoArray = [[NSMutableArray alloc] initWithObjects:
                   @"开始念珠模式",
                   @"结束念珠模式",
                   @"查询来电提醒方式",
                   @"设置来电提醒方式",
                   @"查询电量",
                   @"查询念珠一圈颗数",
                   @"设置念珠一圈颗数",
                   @"获取实时步数",
                   @"获取念珠计数",
                   @"设置设备时间",
                   @"设置闪灯或震动提示",
                   @"设置当前经书ID",
                   @"蓝牙配对功能开关",
                   @"获取念经记录",
                   @"获取念珠当前状态",
                   @"查询固件版本号",
                   @"查询硬件版本号",
                   @"查询软件版本号",
                   @"P_Mac Address",
                   @"P_Total Version",
                   @"P_Enter OTA Mode",
                   nil];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadHeadView];
    [self loadContentView];
}


#pragma mark - **************************** 加载界面 *****************************
/********************************************************************************
 * 方法名称：loadHeadView
 * 功能描述：获取头视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadHeadView
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];
    
    UIView *powerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    powerView.backgroundColor = [UIColor clearColor];
    [headerBackView addSubview:powerView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = @"Rosary";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    [headerBackView addSubview:titleLab];
    
    UIButton *headLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 80, 44)];
    headLeftBtn.backgroundColor = [UIColor clearColor];
    [headLeftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBtn];
    
    UIImageView *headLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 24, 24)];
    headLeftImg.backgroundColor = [UIColor clearColor];
    headLeftImg.image = [UIImage imageNamed:@"img_app_back.png"];
    [headLeftBtn addSubview:headLeftImg];
    
    UIButton *headRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 20, 80, 44)];
    headRightBtn.backgroundColor = [UIColor clearColor];
    [headRightBtn setTitle:@"Device" forState:UIControlStateNormal];
    [headRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headRightBtn addTarget:self action:@selector(chooseDevice) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headRightBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerBackView addSubview:lineView];
}


/********************************************************************************
 * 方法名称：loadContentView
 * 功能描述：获取内容视图
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)loadContentView
{
    m_alertLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    m_alertLab.backgroundColor = [UIColor clearColor];
    m_alertLab.text = @"No device";
    m_alertLab.textColor = [UIColor redColor];
    m_alertLab.textAlignment = NSTextAlignmentCenter;
    m_alertLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:m_alertLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [m_alertLab addSubview:lineView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    
    m_demoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height-114)];
    m_demoTable.delegate = self;
    m_demoTable.dataSource = self;
    m_demoTable.backgroundColor = [UIColor clearColor];
    [m_demoTable setTableFooterView:footerView];
    m_demoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_demoTable];
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction
{
    [m_rosaryApi disconnectBleApi];
    [self.navigationController popViewControllerAnimated:YES];
}


/********************************************************************************
 * 方法名称：chooseDevice
 * 功能描述：选择设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)chooseDevice
{
    BindDeviceViewController *bindView = [[BindDeviceViewController alloc] init];
    bindView.scanDeviceType = BleDeviceRosary;
    bindView.delegate = self;
    [self.navigationController pushViewController:bindView animated:YES];
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
    return [m_demoArray count];
}


/***************************************************************************
 * MethodName :heightForRowAtIndexPath
 * Function   :height For Row At IndexPath
 * InputData  :nil
 * ReturnData :nil
 ***************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 50)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.font = [UIFont systemFontOfSize:18];
    titleName.textColor = [UIColor blackColor];
    titleName.text = [NSString stringWithFormat:@"%i、%@",(int)indexPath.row,[m_demoArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:titleName];
    
    if (indexPath.row == 0)
    {
        UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        tipLab.backgroundColor = [UIColor clearColor];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.font = [UIFont systemFontOfSize:18];
        tipLab.textColor = [UIColor greenColor];
        tipLab.text = [NSString stringWithFormat:@"%@",m_tipNumber];
        [cell.contentView addSubview:tipLab];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.8)];
        line1.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:line1];
    }
    else if (indexPath.row == 2)
    {
        UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        stateLab.backgroundColor = [UIColor clearColor];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.font = [UIFont systemFontOfSize:18];
        stateLab.textColor = [UIColor greenColor];
        stateLab.text = [NSString stringWithFormat:@"--"];
        [cell.contentView addSubview:stateLab];
        
        if (m_myRemindType == 0)
        {
            stateLab.text = @"灯亮";
        }
        else if (m_myRemindType == 1)
        {
            stateLab.text = @"震动";
        }
        else if (m_myRemindType == 2)
        {
            stateLab.text = @"灯亮+震动";
        }
    }
    else if (indexPath.row == 3)
    {
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        [setBtn addTarget:self action:@selector(setRemindType) forControlEvents:UIControlEventTouchUpInside];
        [setBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:setBtn];
        
        if (m_remindType == 0)
        {
            [setBtn setTitle:@"灯亮" forState:UIControlStateNormal];
        }
        else if (m_remindType == 1)
        {
            [setBtn setTitle:@"震动" forState:UIControlStateNormal];
        }
        else if (m_remindType == 2)
        {
            [setBtn setTitle:@"灯亮+震动" forState:UIControlStateNormal];
        }
    }
    else if (indexPath.row == 4)
    {
        NSString *wei = @"%";
        UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        stateLab.backgroundColor = [UIColor clearColor];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.font = [UIFont systemFontOfSize:18];
        stateLab.textColor = [UIColor greenColor];
        stateLab.text = [NSString stringWithFormat:@"%@%@",m_powerNum,wei];
        [cell.contentView addSubview:stateLab];
    }
    else if (indexPath.row == 5)
    {
        UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        stateLab.backgroundColor = [UIColor clearColor];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.font = [UIFont systemFontOfSize:18];
        stateLab.textColor = [UIColor greenColor];
        stateLab.text = [NSString stringWithFormat:@"%i",m_myBeadNumber];
        [cell.contentView addSubview:stateLab];
    }
    else if (indexPath.row == 6)
    {
        UIButton *minBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 50, 50)];
        [minBtn setTitle:@"-" forState:UIControlStateNormal];
        [minBtn addTarget:self action:@selector(minBeadNumber) forControlEvents:UIControlEventTouchUpInside];
        [minBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        minBtn.titleLabel.font = [UIFont systemFontOfSize:24];
        [cell.contentView addSubview:minBtn];
        
        UILabel *beadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 50, 50)];
        beadLab.backgroundColor = [UIColor clearColor];
        beadLab.textAlignment = NSTextAlignmentCenter;
        beadLab.font = [UIFont systemFontOfSize:18];
        beadLab.textColor = [UIColor redColor];
        beadLab.text = [NSString stringWithFormat:@"%i",m_setBeadNumber];
        [cell.contentView addSubview:beadLab];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 0, 50, 50)];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBeadNumber) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:24];
        [cell.contentView addSubview:addBtn];
    }
    else if (indexPath.row == 7)
    {
        UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        stateLab.backgroundColor = [UIColor clearColor];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.font = [UIFont systemFontOfSize:18];
        stateLab.textColor = [UIColor greenColor];
        stateLab.text = [NSString stringWithFormat:@"%@",m_stepNum];
        [cell.contentView addSubview:stateLab];
    }
    else if (indexPath.row == 8)
    {
        UILabel *tipLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        tipLab.backgroundColor = [UIColor clearColor];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.font = [UIFont systemFontOfSize:18];
        tipLab.textColor = [UIColor greenColor];
        tipLab.text = [NSString stringWithFormat:@"%@",m_tipNumber];
        [cell.contentView addSubview:tipLab];
    }
    else if (indexPath.row == 10)
    {
        UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        [setBtn addTarget:self action:@selector(setTimeData) forControlEvents:UIControlEventTouchUpInside];
        [setBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [cell.contentView addSubview:setBtn];
    }
    else if (indexPath.row == 11)
    {
        UIButton *minBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 50, 50)];
        [minBtn setTitle:@"-" forState:UIControlStateNormal];
        [minBtn addTarget:self action:@selector(minBookNumber) forControlEvents:UIControlEventTouchUpInside];
        [minBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        minBtn.titleLabel.font = [UIFont systemFontOfSize:24];
        [cell.contentView addSubview:minBtn];
        
        UILabel *beadLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 50, 50)];
        beadLab.backgroundColor = [UIColor clearColor];
        beadLab.textAlignment = NSTextAlignmentCenter;
        beadLab.font = [UIFont systemFontOfSize:18];
        beadLab.textColor = [UIColor redColor];
        beadLab.text = [NSString stringWithFormat:@"%i",m_bookIdNum];
        [cell.contentView addSubview:beadLab];
        
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 0, 50, 50)];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBookBeadNumber) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:24];
        [cell.contentView addSubview:addBtn];
    }
    else if (indexPath.row == 13)
    {
        if (m_isLoading)
        {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, 7.5, 35.0, 35.0)];
            indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [indicatorView startAnimating];
            [cell.contentView addSubview:indicatorView];
        }
    }
    else if (indexPath.row == 14)
    {
        UILabel *stateLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-150, 0, 150, 50)];
        stateLab.backgroundColor = [UIColor clearColor];
        stateLab.textAlignment = NSTextAlignmentCenter;
        stateLab.font = [UIFont systemFontOfSize:18];
        stateLab.textColor = [UIColor greenColor];
        [cell.contentView addSubview:stateLab];
        
        if (m_beadNowState == 1)
        {
            stateLab.text = @"正在念珠";
        }
        else
        {
            stateLab.text = @"已结束念珠";
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.2, self.view.frame.size.width, 0.8)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:line];
    
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
    
    if (m_rosaryApi.isConnected)
    {
        if (indexPath.row == 0)
        {
            [m_rosaryApi startRosaryOn:YES];
        }
        else if (indexPath.row == 1)
        {
            [m_rosaryApi startRosaryOn:NO];
        }
        else if (indexPath.row == 2)
        {
            [m_rosaryApi searchNotice:[NSString stringWithFormat:@"%i",m_remindType]];
        }
        else if (indexPath.row == 3)
        {
            [m_rosaryApi setNotice:[NSString stringWithFormat:@"%i",m_remindType]];
        }
        else if (indexPath.row == 4)
        {
            [m_rosaryApi searchPower];
        }
        else if (indexPath.row == 5)
        {
            [m_rosaryApi searchBeadNumber:@"12"];
        }
        else if (indexPath.row == 6)
        {
            [m_rosaryApi setBeadNumber:[NSString stringWithFormat:@"%i",m_setBeadNumber]];
        }
        else if (indexPath.row == 7)
        {
            [m_rosaryApi getRealTimeSteps];
        }
        else if (indexPath.row == 8)
        {
            [m_rosaryApi getBeadNumbers];
        }
        else if (indexPath.row == 9)
        {
            [m_rosaryApi setDeviceTime];
        }
        else if (indexPath.row == 10)
        {
            NSMutableDictionary *noticeDic = [[NSMutableDictionary alloc] init];
            [noticeDic setObject:@"1" forKey:@"noticeType"];  // 提示方式 （0-闪灯、1-震动、2-闪灯和震动）
            [noticeDic setObject:@"3" forKey:@"noticeRows"];  // 提示组数
            [noticeDic setObject:@"2000" forKey:@"intervalTime"]; // 每组间隔时间，单位毫秒
            [noticeDic setObject:@"3" forKey:@"timeNumbers"]; // 每组提示次数
            [noticeDic setObject:@"2000" forKey:@"noticeTime"];   // 一次提示持续时间，单位毫秒
            [noticeDic setObject:@"1000" forKey:@"restTime"];     // 一次提示休息时间，单位毫秒
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            if ([ud objectForKey:@"FNoticeType"] != nil)
            {
                [noticeDic setObject:[ud objectForKey:@"FNoticeType"] forKey:@"noticeType"];
            }
            
            if ([ud objectForKey:@"FNoticeRows"] != nil)
            {
                [noticeDic setObject:[ud objectForKey:@"FNoticeRows"] forKey:@"noticeRows"];
            }
            
            if ([ud objectForKey:@"FIntervalTime"] != nil)
            {
                [noticeDic setObject:[ud objectForKey:@"FIntervalTime"] forKey:@"intervalTime"];
            }
            
            if ([ud objectForKey:@"FTimeNunbers"] != nil)
            {
                [noticeDic setObject:[ud objectForKey:@"FTimeNunbers"] forKey:@"timeNumbers"];
            }
            
            if ([ud objectForKey:@"FNoticeTime"] != nil)
            {
                [noticeDic setObject:[ud objectForKey:@"FNoticeTime"] forKey:@"noticeTime"];
            }
            
            if ([ud objectForKey:@"FRestTime"] != nil)
            {
                [noticeDic setObject:[ud objectForKey:@"FRestTime"] forKey:@"restTime"];
            }
            
            [m_rosaryApi setNoticeSetting:noticeDic];
        }
        else if (indexPath.row == 11)
        {
            NSString *bookId = [NSString stringWithFormat:@"%i",m_bookIdNum]; // 经书ID
            [m_rosaryApi setBookId:bookId];
        }
        else if (indexPath.row == 12)
        {
            [m_rosaryApi bluetoothANCS:YES];// 打开配对功能/关闭配对功能
        }
        else if (indexPath.row == 13)
        {
            m_isLoading = YES;
            [m_historyArray removeAllObjects];
            [m_demoTable reloadData];
            
            [m_rosaryApi getBeadHistory];
        }
        else if (indexPath.row == 14)
        {
            [m_rosaryApi getBeadMode];
        }
        else if (indexPath.row == 15)
        {
            [m_rosaryApi readFirmwareVersion];
        }
        else if (indexPath.row == 16)
        {
            [m_rosaryApi readHardwareVersion];
        }
        else if (indexPath.row == 17)
        {
            [m_rosaryApi readSoftwareVersion];
        }
        else if (indexPath.row == 18)
        {
            [m_rosaryApi getPrivateMacAddress];
        }
        else if (indexPath.row == 19)
        {
            [m_rosaryApi getPrivateVersion];
        }
        else if (indexPath.row == 20)
        {
            [m_rosaryApi enterOTAMode];
        }
    }
}


- (void)setRemindType
{
    if (m_remindType == 0)
    {
        m_remindType = 1;
    }
    else if (m_remindType == 1)
    {
        m_remindType = 2;
    }
    else if (m_remindType == 2)
    {
        m_remindType = 0;
    }
    [m_demoTable reloadData];
}


- (void)setTimeData
{
    SetViewController *mySetView = [[SetViewController alloc] init];
    [self.navigationController pushViewController:mySetView animated:YES];
}


- (void)minBeadNumber
{
    m_setBeadNumber--;
    
    if (m_setBeadNumber <= 1)
    {
        m_setBeadNumber = 1;
    }
    
    [m_demoTable reloadData];
}


- (void)addBeadNumber
{
    m_setBeadNumber++;
    [m_demoTable reloadData];
}


- (void)minBookNumber
{
    m_bookIdNum--;
    
    if (m_bookIdNum <= 1)
    {
        m_bookIdNum = 1;
    }
    
    [m_demoTable reloadData];
}


- (void)addBookBeadNumber
{
    m_bookIdNum++;
    [m_demoTable reloadData];
}


#pragma mark - **************************** 数据回调 *****************************
/********************************************************************************
 * 方法名称：getDeviceId
 * 功能描述：得到设备ID
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceId:(NSArray *)deviceIdArray {
    if (deviceIdArray.count > 0) {
        m_rosaryId = [[deviceIdArray objectAtIndex:0] objectForKey:@"deviceId"];
        
        if (m_isBleAvailable)
        {
            [m_rosaryApi startConnectBleApi:m_rosaryId andIdType:DeviceIdUUID];
        }
    }
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice
{
    switch (status)
    {
        case DeviceBleClosed:
            m_isBleAvailable = NO;
            m_alertLab.text = @"Closed";
            break;
            
        case DeviceBleIsOpen:
            m_isBleAvailable = YES;
            m_alertLab.text = @"BleIsOpen";
            if (m_rosaryId.length > 0)
            {
                [m_rosaryApi startConnectBleApi:m_rosaryId andIdType:DeviceIdUUID];
            }
            break;
            
        case DeviceBleSearching:
            m_alertLab.text = @"Searching";
            break;
            
        case DeviceBleConnecting:
            m_alertLab.text = @"Connecting";
            break;
            
        case DeviceBleConnected:
            m_alertLab.text = @"Connected";
            break;
            
        case DeviceBleSynchronization:
            m_alertLab.text = @"Synchronization";
            break;
            
        case DeviceBleSyncOver:
            m_alertLab.text = @"SyncOver";
            break;
            
        case DeviceBleSyncFailed:
            m_alertLab.text = @"SyncFailed";
            break;
            
        case DeviceBleDisconnecting:
            m_alertLab.text = @"Disconnecting";
            break;
            
        case DeviceBleReconnect:
            m_alertLab.text = @"Reconnecting";
            break;
            
        default:
            break;
    }
}


/********************************************************************************
 * 方法名称：bleConnectError
 * 功能描述：蓝牙连接错误信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error andDevice:(id)bleDevice
{
    
}


/********************************************************************************
 * 方法名称：bleConnectLog
 * 功能描述：蓝牙连接LOG
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectLog:(NSString *)logString andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：devicePower
 * 功能描述：电量
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice
{
    NSString *bai = @"%";
    NSLog(@"Power is %@%@",power,bai);
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
    NSLog(@"Firmware is %@",version);
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
    NSLog(@"Hardware is %@",version);
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
    NSLog(@"Software is %@",version);
}


/********************************************************************************
 * 方法名称：privateVersion
 * 功能描述：获取私有版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice {
    NSLog(@"Software is %@",versionMap);
}


/********************************************************************************
 * 方法名称：privateMacAddress
 * 功能描述：获取私有MAC地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice {
    NSLog(@"Software is %@",macMap);
}


//  实时计数
- (void)realTimeBeadNumber:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_tipNumber = [info objectForKey:@"tipNumber"];//念珠的计数
    [m_demoTable reloadData];
}

//  电量
- (void)powerInfo:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_powerNum = [info objectForKey:@"power"];//念珠的电量
    [m_demoTable reloadData];
}


//  提醒模式
- (void)remindMode:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_myRemindType = [[info objectForKey:@"remindMode"] intValue];//来电提醒方式 0-灯亮、1-震动、2-灯亮+震动
    [m_demoTable reloadData];
}


//  佛珠个数
- (void)circelBeadNumber:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_myBeadNumber = [[info objectForKey:@"beadNumber"] intValue];// 念珠一圈的颗数
    [m_demoTable reloadData];
}


//  实时步数
- (void)realTimeSteps:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_stepNum = [info objectForKey:@"stepNum"];// 实时步数
    [m_demoTable reloadData];
}


//  历史
- (void)rosaryRecord:(NSDictionary *)info andDevice:(id)bleDevice
{
    if (info != nil)
    {
        NSArray *myArray = [info objectForKey:@"historyData"];
        [m_historyArray addObjectsFromArray:[info objectForKey:@"historyData"]];
        
        for (int i = 0; i < myArray.count; i++)
        {
            NSMutableDictionary *daDic = [myArray objectAtIndex:i];
            NSString *startTime = [daDic objectForKey:@"startTime"];  // 开始时间
            NSString *endTime = [daDic objectForKey:@"endTime"]; // 结束时间
            NSString *beadNumber = [daDic objectForKey:@"beadNumber"]; // 念珠次数
            NSString *bookId = [daDic objectForKey:@"bookId"]; // 经书ID
        }
    }
}


//  计数
- (void)nowBeadNumber:(NSDictionary *)info andDevice:(id)bleDevice
{
    
}


//  配对
- (void)connectAncs:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_bluePair = [[info objectForKey:@"bluePair"] intValue];//蓝牙配对是否打开 1-打开、2-关闭
    [m_demoTable reloadData];
}


//  历史状态
- (void)recordStatus:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_isLoading = NO;
    [m_demoTable reloadData];
    int historyState = [[info objectForKey:@"historyState"] intValue];// 1-获取完成、2-获取中出现数据丢失
    
    if (historyState == 1)
    {
        if (m_historyArray.count > 0)
        {
            HistoryViewController *myHisView = [[HistoryViewController alloc] init];
            myHisView.dataArray = m_historyArray;
            [self.navigationController pushViewController:myHisView animated:YES];
        }
        else
        {
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Data"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Done"
                                                    otherButtonTitles:nil, nil];
            [myAlert show];
            return;
        }
    }
    else
    {
        if (m_historyArray.count > 0)
        {
            HistoryViewController *myHisView = [[HistoryViewController alloc] init];
            myHisView.dataArray = m_historyArray;
            [self.navigationController pushViewController:myHisView animated:YES];
        }
        
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"history data error,please try again"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Done"
                                                otherButtonTitles:nil, nil];
        [myAlert show];
        return;
    }
}


//  连接状态
- (void)beadStatus:(NSDictionary *)info andDevice:(id)bleDevice
{
    m_beadNowState = [[info objectForKey:@"beadState"] intValue];// 1-念珠模式开始、2-念珠模式结束
    [m_demoTable reloadData];
}


@end
