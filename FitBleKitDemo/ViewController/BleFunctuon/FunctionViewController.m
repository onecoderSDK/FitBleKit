/********************************************************************************
 * 文件名称：FunctionViewController.h
 * 内容摘要：蓝牙检测数据
 * 版本编号：1.0.1
 * 创建日期：2021年04月27日
 ********************************************************************************/

#import "FunctionViewController.h"

@interface FunctionViewController ()<UITableViewDataSource,UITableViewDelegate,FBKApiScanDevicesDelegate,FBKApiBsaeDataSource,FBKBleFunctionDelegate> {
    FBKApiScanDevices *m_scanBlue;
    FBKBleFunction    *m_bleFunction;
    UITableView       *m_searchEquTableView;
    NSMutableArray    *m_searchEquArray;
    NSString *m_deviceName;
    int m_chooseRow;
}

@end

@implementation FunctionViewController

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：UI开始加载
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_deviceName = @"";
    m_chooseRow = -1;
    m_searchEquArray = [[NSMutableArray alloc] init];
    m_scanBlue = [[FBKApiScanDevices alloc] init];
    m_scanBlue.delegate = self;
    
    m_bleFunction = [[FBKBleFunction alloc] init];
    m_bleFunction.dataSource = self;
    m_bleFunction.delegate = self;
    
    [self loadHeadView];
    [self loadContentView];
    
    NSTimer *reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(reloadTable)
                                                  userInfo:nil
                                                   repeats:YES];
    [reloadTimer fire];
}


/********************************************************************************
 * 方法名称：viewDidAppear
 * 功能描述：UI加载完毕
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
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
    titleLab.text = @"Choose Device";
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
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];    footerView.backgroundColor = [UIColor clearColor];
    
    m_searchEquTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_searchEquTableView.delegate = self;
    m_searchEquTableView.dataSource = self;
    m_searchEquTableView.backgroundColor = [UIColor clearColor];
    [m_searchEquTableView setTableFooterView:footerView];
    m_searchEquTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_searchEquTableView];
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回上一个页面
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction
{
    [m_scanBlue stopScanBleApi];
    [self.navigationController popViewControllerAnimated:YES];
}


/********************************************************************************
 * 方法名称：reloadTable
 * 功能描述：刷新页面
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)reloadTable {
    [m_searchEquTableView reloadData];
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
    return m_searchEquArray.count;
}


/********************************************************************************
 * 方法名称：heightForRowAtIndexPath
 * 功能描述：设置TableView的行高
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    static NSString *cellString = @"ScanListCell";
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
    
    CBPeripheral *nowPeripheral = [[m_searchEquArray objectAtIndex:indexPath.row] objectForKey:@"peripheral"];
    NSString *rssiNum = [[m_searchEquArray objectAtIndex:indexPath.row] objectForKey:@"RSSI"];
    NSString *name = nowPeripheral.name;
    NSString *uuid = nowPeripheral.identifier.UUIDString;
    
    UIView *cellBackImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
    cellBackImage.backgroundColor = [UIColor clearColor];
    cellBackImage.layer.masksToBounds = YES;
    cellBackImage.layer.cornerRadius = 8;
    [cell.contentView addSubview:cellBackImage];
    
    NSString *myXinHaoNum = rssiNum;
    double numXin = -100;
    if (myXinHaoNum != nil) {
        numXin = [myXinHaoNum doubleValue];
    }
    double myXin = numXin;
    
    if (name.length == 0) {
        name = @"UnknowName";
    }
    
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, self.view.frame.size.width-20, 20)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:15];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%@   RSSI %.1f",name,myXin];
    [cell.contentView addSubview:info1Lab];
    
    UILabel *info2Lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 28, 240, 20)];
    info2Lab.textAlignment = NSTextAlignmentLeft;
    info2Lab.font = [UIFont systemFontOfSize:10];
    info2Lab.textColor = [UIColor blackColor];
    info2Lab.text = uuid;
    [cell.contentView addSubview:info2Lab];
    
    UILabel *info3Lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-140, 10, 120, 30)];
    info3Lab.textAlignment = NSTextAlignmentRight;
    info3Lab.font = [UIFont systemFontOfSize:12];
    info3Lab.textColor = [UIColor darkGrayColor];
    info3Lab.text = @"";
    [cell.contentView addSubview:info3Lab];
    
    UIImageView *chooseImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-40, 15, 20, 20)];
    chooseImg.backgroundColor = [UIColor clearColor];
    chooseImg.image = [UIImage imageNamed:@"img_choose.png"];
    chooseImg.hidden = YES;
    [cell.contentView addSubview:chooseImg];
    
    if (indexPath.row == m_chooseRow) {
        chooseImg.hidden = NO;
    }
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    myLine.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:myLine];
    
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
    
    if (m_chooseRow == -1) {
        m_chooseRow = (int)indexPath.row;
        [tableView reloadData];
        
        CBPeripheral *nowPeripheral = [[m_searchEquArray objectAtIndex:indexPath.row] objectForKey:@"peripheral"];
        NSString *uuid = nowPeripheral.identifier.UUIDString;
        m_deviceName = nowPeripheral.name;
        [m_bleFunction startConnectBleApi:uuid andIdType:DeviceIdUUID];
        
    }
}


#pragma mark - **************************** 数据回调 *****************************
/********************************************************************************
 * 方法名称：phoneBleStatus
 * 功能描述：手机蓝牙状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)phoneBleStatus:(BOOL)isPoweredOn {
    if (isPoweredOn) {
        [m_scanBlue startScanBleApi:nil isRealTimeDevice:NO withRssi:70];
    }
}


/********************************************************************************
 * 方法名称：getDeviceList
 * 功能描述：获取蓝牙列表数据
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)getDeviceList:(NSArray *)deviceList {
    [m_searchEquArray removeAllObjects];
    [m_searchEquArray addObjectsFromArray:deviceList];
}



/********************************************************************************
 * 方法名称：deviceFunction
 * 功能描述：获取蓝牙功能
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFunction:(FBKFunction *)function andDevice:(id)bleDevice {
    NSString *typeString = [NSString stringWithFormat:@"TYPE: %u",function.functionType];
    NSString *recordString = [NSString stringWithFormat:@"HaveRecord: %i",function.haveRecord];
    NSString *hrString = [NSString stringWithFormat:@"IsHR: %i",function.isHR];
    NSString *hrvString = [NSString stringWithFormat:@"IsHRV: %i",function.isHRV];
    NSString *ecgString = [NSString stringWithFormat:@"IsECG: %i",function.isECG];
    NSString *alertString = [NSString stringWithFormat:@"%@\n\n%@\n%@\n%@\n%@\n%@\n",m_deviceName,typeString,recordString,hrString,hrvString,ecgString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        m_deviceName = @"";
        m_chooseRow = -1;
        [m_searchEquTableView reloadData];
    }]];
     
    [self presentViewController:alertController animated:true completion:nil];
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：bleConnectError
 * 功能描述：蓝牙连接错误信息
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectError:(id)error andDevice:(id)bleDevice {
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
- (void)devicePower:(NSString *)power andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：deviceFirmware
 * 功能描述：固件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceFirmware:(NSString *)version andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：deviceHardware
 * 功能描述：硬件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceHardware:(NSString *)version andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：deviceSoftware
 * 功能描述：软件版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)deviceSoftware:(NSString *)version andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：privateVersion
 * 功能描述：获取私有版本号
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateVersion:(NSDictionary *)versionMap andDevice:(id)bleDevice {
}


/********************************************************************************
 * 方法名称：privateMacAddress
 * 功能描述：获取私有MAC地址
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)privateMacAddress:(NSDictionary *)macMap andDevice:(id)bleDevice {
}



@end
