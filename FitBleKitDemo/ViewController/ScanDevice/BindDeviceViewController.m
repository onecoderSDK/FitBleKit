/********************************************************************************
 * 文件名称：BindDeviceViewController.h
 * 内容摘要：蓝牙选择列表
 * 版本编号：1.0.1
 * 创建日期：2017年03月02日
 ********************************************************************************/

#import "BindDeviceViewController.h"

@interface BindDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,FBKApiScanDevicesDelegate> {
    FBKApiScanDevices *m_scanBlue;
    UITableView       *m_searchEquTableView;
    NSMutableArray    *m_searchEquArray;
    NSMutableArray    *m_chooseArray;
}

@end

@implementation BindDeviceViewController

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
    
    m_chooseArray = [[NSMutableArray alloc] init];
    m_searchEquArray = [[NSMutableArray alloc] init];
    m_scanBlue = [[FBKApiScanDevices alloc] init];
    m_scanBlue.delegate = self;
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
    
    UIButton *headRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 80, 50)];
    headRightBtn.backgroundColor = [UIColor clearColor];
    [headRightBtn setTitle:@"Choose" forState:UIControlStateNormal];
    [headRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headRightBtn addTarget:self action:@selector(chooseDevice) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headRightBtn];
    
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
    if (@available(iOS 15.0, *)) {
        m_searchEquTableView.sectionHeaderTopPadding = 0;
    }
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
 * 方法名称：chooseDevice
 * 功能描述：选择设备
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)chooseDevice {
    if (m_chooseArray.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate getDeviceId:m_chooseArray];
        [m_scanBlue stopScanBleApi];
    }
    else {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Please choose device."
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Done"
                                                otherButtonTitles:nil, nil];
        [myAlert show];
    }
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


/********************************************************************************
 * 方法名称：deviceIdInList
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (int)deviceIdInList:(NSString *)deviceId {
    int resultNumber = -1;
    for (int i = 0; i < m_chooseArray.count; i++) {
        NSString *listId = [[m_chooseArray objectAtIndex:i] objectForKey:@"deviceId"];
        if ([listId isEqualToString:deviceId]) {
            resultNumber = i;
            break;
        }
    }
    
    return resultNumber;
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
    
    int deviceRow = [self deviceIdInList:uuid];
    if (deviceRow != -1) {
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
    
    CBPeripheral *nowPeripheral = [[m_searchEquArray objectAtIndex:indexPath.row] objectForKey:@"peripheral"];
    NSString *uuid = nowPeripheral.identifier.UUIDString;
    NSString *name = nowPeripheral.name;
    if (name.length == 0) {
        name = @"UnknowName";
    }
    
    if (self.scanDeviceType == BleDeviceNewScale) {
        uuid = [[m_searchEquArray objectAtIndex:indexPath.row] objectForKey:@"idString"];
    }
    else if (self.scanDeviceType == BleDeviceOldScale) {
        uuid = [[m_searchEquArray objectAtIndex:indexPath.row] objectForKey:@"MACAddress"];
    }
    
    NSMutableDictionary *deviceDic = [[NSMutableDictionary alloc] init];
    [deviceDic setObject:uuid forKey:@"deviceId"];
    [deviceDic setObject:name forKey:@"deviceName"];

    int deviceRow = [self deviceIdInList:uuid];
    if (deviceRow == -1) {
        if (m_chooseArray.count == 7) {
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"More than 7 devices"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Done"
                                                    otherButtonTitles:nil, nil];
            [myAlert show];
        }
        else {
            [m_chooseArray addObject:deviceDic];
        }
    }
    else {
        [m_chooseArray removeObjectAtIndex:deviceRow];
    }
    
    [tableView reloadData];
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


@end
