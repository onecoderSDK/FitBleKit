/********************************************************************************
 * 文件名称：ViewController.m
 * 内容摘要：主页
 * 版本编号：1.0.1
 * 创建日期：2017年10月31日
 ********************************************************************************/

#import "ViewController.h"
#import "NewBandViewController.h"
#import "NewScaleViewController.h"
#import "SkippingViewController.h"
#import "CadenceViewController.h"
#import "OldScaleViewController.h"
#import "OldBandViewController.h"
#import "RosaryViewController.h"
#import "HeartRateViewController.h"
#import "BikeComputerViewController.h"
#import "ArmBandViewController.h"
#import "KettleBellViewController.h"
#import "HubListViewController.h"
#import "FistPowerViewController.h"
#import "BroadcastingScaleViewController.h"
#import "PowerViewController.h"
#import "ECGViewController.h"
#import "FunctionViewController.h"
#import "RunningViewController.h"
#import "PPGDFUViewController.h"
#import "FightViewController.h"
#import "ErgometerViewController.h"
#import "NewBandListViewController.h"
#import "ShowTools.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate> {
    UITableView    *m_deviceTypeTableView; // 设备列表
    NSMutableArray *m_deviceTypeArray;     // 设备列表数据
    FBKProNTrackerAnalytical *m_newTrackerAnalytical;
    FBKTemAlgorithm *m_mytem;
}

@end

@implementation ViewController

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：viewDidLoad
 * 功能描述：初始化
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_mytem = [[FBKTemAlgorithm alloc] init];
//    double i1 = [m_mytem listTemperatureData:23 witEvnTem:18];
//    double i2 = [m_mytem listTemperatureData:33.6 witEvnTem:31.6];
//    double i3 = [m_mytem listTemperatureData:37 witEvnTem:37];
//    double i4 = [m_mytem listTemperatureData:38 witEvnTem:38];
//    double i5 = [m_mytem listTemperatureData:17 witEvnTem:17];
    
    m_newTrackerAnalytical = [[FBKProNTrackerAnalytical alloc] init];
    m_newTrackerAnalytical.analyticalDeviceType = BleDeviceNewBand;
    
    m_deviceTypeArray = [[NSMutableArray alloc] initWithObjects:
                         @"Ergometer",
                         @"Fighting",
                         @"PPG DFU",
                         @"Running",
                         @"ECG",
                         @"Power",
                         @"Arm Band",
                         @"Hub Config",
                         @"Heart Rate",
                         @"Boxing",
                         @"Cadence",
                         @"Skipping",
                         @"New Band",
                         @"Old Band",
                         @"New Scale",
                         @"Old Scale",
                         @"Broadcasting Scale",
                         @"Rosary",
                         @"BikeComputer",
                         @"Kettle Bell",
                         @"BleFunction",
                         nil];
    
    [self loadHeadView];
    [self loadContentView];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"PM200" ofType:@"bin"];
//    FBKPPGCmd *ppgCmd = [[FBKPPGCmd alloc] init];
//    NSArray *myCmdArray = [ppgCmd ppgDFUForFilePath:path withMTU:20];
//    NSLog(@"myCmdData --- %@",myCmdArray);
//
//    long int myLowZone = -127;
//    if (myLowZone < 0) {
//        myLowZone = ~myLowZone;
//        myLowZone = myLowZone + 1;
//    }
//    NSLog(@"%li",myLowZone);
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
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVerString = [NSString stringWithFormat:@"%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    titleLab.backgroundColor = [UIColor whiteColor];
    titleLab.text = [NSString stringWithFormat:@"FitBleKit V%@",nowVerString];
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:20];
    [headerBackView addSubview:titleLab];
    
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
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    
    m_deviceTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80)];
    m_deviceTypeTableView.delegate = self;
    m_deviceTypeTableView.dataSource = self;
    m_deviceTypeTableView.backgroundColor = [UIColor clearColor];
    [m_deviceTypeTableView setTableFooterView:footerView];
    m_deviceTypeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 15.0, *)) {
        m_deviceTypeTableView.sectionHeaderTopPadding = 0;
    }
    [self.view addSubview:m_deviceTypeTableView];
}


#pragma mark - **************************** 回调方法 *****************************
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
    return m_deviceTypeArray.count;
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
    static NSString *cellString = @"MainListCell";
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
    
    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-20, 50)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:15];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"%@",[m_deviceTypeArray objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:info1Lab];
    
    UIImageView *nextImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-32, 17, 16, 16)];
    nextImg.backgroundColor = [UIColor clearColor];
    nextImg.image = [UIImage imageNamed:@"img_app_next.png"];
    [cell.contentView addSubview:nextImg];
    
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
    int myRow = (int)indexPath.row;

    int baseRow = 4;
    if (myRow == 0) {
        ErgometerViewController *ergView = [[ErgometerViewController alloc] init];
        [self.navigationController pushViewController:ergView animated:YES];
    }
    else if (myRow == baseRow-3) {
        FightViewController *fightView = [[FightViewController alloc] init];
        [self.navigationController pushViewController:fightView animated:YES];
    }
    else if (myRow == baseRow-2) {
        PPGDFUViewController *PPGView = [[PPGDFUViewController alloc] init];
        [self.navigationController pushViewController:PPGView animated:YES];
    }
    else if (myRow == baseRow-1) {
        RunningViewController *runView = [[RunningViewController alloc] init];
        [self.navigationController pushViewController:runView animated:YES];
    }
    else if (myRow == baseRow-0) {
        ECGViewController *ecgView = [[ECGViewController alloc] init];
        [self.navigationController pushViewController:ecgView animated:YES];
    }
    else if (myRow == 1+baseRow) {
        PowerViewController *powerView = [[PowerViewController alloc] init];
        [self.navigationController pushViewController:powerView animated:YES];
    }
    else if (myRow == 2+baseRow) {
        ArmBandViewController *armBandView = [[ArmBandViewController alloc] init];
        [self.navigationController pushViewController:armBandView animated:YES];
    }
    else if (myRow == 3+baseRow) {
        HubListViewController *hubConfigView = [[HubListViewController alloc] init];
        [self.navigationController pushViewController:hubConfigView animated:YES];
    }
    else if (myRow == 4+baseRow) {
        HeartRateViewController *heartRateView = [[HeartRateViewController alloc] init];
        [self.navigationController pushViewController:heartRateView animated:YES];
    }
    else if (myRow == 5+baseRow) {
        FistPowerViewController *fistPowerView = [[FistPowerViewController alloc] init];
        [self.navigationController pushViewController:fistPowerView animated:YES];
    }
    else if (myRow == 6+baseRow) {
        CadenceViewController *cadenceView = [[CadenceViewController alloc] init];
        [self.navigationController pushViewController:cadenceView animated:YES];
    }
    else if (myRow == 7+baseRow) {
        SkippingViewController *skippingView = [[SkippingViewController alloc] init];
        [self.navigationController pushViewController:skippingView animated:YES];
    }
    else if (myRow == 8+baseRow) {
        NewBandViewController *bandNewView = [[NewBandViewController alloc] init];
        [self.navigationController pushViewController:bandNewView animated:YES];
    }
    else if (myRow == 9+baseRow) {
        OldBandViewController *bandOldView = [[OldBandViewController alloc] init];
        [self.navigationController pushViewController:bandOldView animated:YES];
    }
    else if (myRow == 10+baseRow) {
        NewScaleViewController *scaleNewView = [[NewScaleViewController alloc] init];
        [self.navigationController pushViewController:scaleNewView animated:YES];
    }
    else if (myRow == 11+baseRow) {
        OldScaleViewController *scaleOldView = [[OldScaleViewController alloc] init];
        [self.navigationController pushViewController:scaleOldView animated:YES];
    }
    else if (myRow == 12+baseRow) {
        BroadcastingScaleViewController *broadcastingScaleView = [[BroadcastingScaleViewController alloc] init];
        [self.navigationController pushViewController:broadcastingScaleView animated:YES];
    }
    else if (myRow == 13+baseRow) {
        RosaryViewController *rosaryView = [[RosaryViewController alloc] init];
        [self.navigationController pushViewController:rosaryView animated:YES];
    }
    else if (myRow == 14+baseRow) {
        BikeComputerViewController *bikeComputerView = [[BikeComputerViewController alloc] init];
        [self.navigationController pushViewController:bikeComputerView animated:YES];
    }
    else if (myRow == 15+baseRow) {
        KettleBellViewController *kettleBellView = [[KettleBellViewController alloc] init];
        [self.navigationController pushViewController:kettleBellView animated:YES];
    }
    else if (myRow == 16+baseRow) {
        FunctionViewController *functionView = [[FunctionViewController alloc] init];
        [self.navigationController pushViewController:functionView animated:YES];
    }
}


- (void)analyData {
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:
                                @"ff801400340310fe01050100000d01fe010302f1",
                                @"ffc1060001c7",
                                nil];
    
    
    for (int i = 0; i < dataArray.count; i++) {
        NSString *cmdString = [dataArray objectAtIndex:i];
        
        double delayInSeconds = 0.1*i;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self->m_newTrackerAnalytical receiveBlueData:cmdString];
        });
        
    }
}


@end

