/********************************************************************************
 * 文件名称：FightViewController.m
 * 内容摘要：新拳击
 * 版本编号：1.0.1
 * 创建日期：2022年08月023日
 ********************************************************************************/

#import "FightViewController.h"
#import "BindDeviceViewController.h"
#import "PYToolUIAdapt.h"
#import "PYToolColor.h"
#import "PYToolString.h"
#import "SandbagView.h"

@interface FightViewController ()<DeviceIdDelegate, FBKApiFightDelegate, SandbagViewDelegate> {
    FBKApiFight     *m_fightApi;
    FBKFightSandbag *m_sandbag;
    UILabel         *m_nameLabel;
    UIButton        *m_connectBtn;
    UIView          *m_dataView;
    SandbagView     *m_sandbagView;
    NSMutableArray  *m_showArray;
}

@end

@implementation FightViewController

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
    
    m_showArray = [[NSMutableArray alloc] init];
    [m_showArray addObject:@"--"];
    [m_showArray addObject:@"--"];
    [m_showArray addObject:@"--"];
    
    m_fightApi = [[FBKApiFight alloc] init];
    m_fightApi.delegate = self;
    
    m_sandbag = [[FBKFightSandbag alloc] init];
    m_sandbag.sandbagLength = 400;
    m_sandbag.sandbagWidth = 400;
    m_sandbag.sandbagHight = 2000;
    m_sandbag.sandbagWeight = 100;
    m_sandbag.sandbagType = 0;
    m_sandbag.powerSensitivity = 13;
    m_sandbag.rateSensitivity = 8;
    
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
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 80.0)];
    headerBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerBackView];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 30.0, self.view.frame.size.width, 50.0)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"Fighting";
    titleLab.textColor = [UIColor blackColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    [headerBackView addSubview:titleLab];
    
    UIButton *headLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
    headLeftBtn.backgroundColor = [UIColor clearColor];
    [headLeftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerBackView addSubview:headLeftBtn];
    
    UIImageView *headLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 24, 24)];
    headLeftImg.backgroundColor = [UIColor clearColor];
    headLeftImg.image = [UIImage imageNamed:@"img_app_back.png"];
    [headLeftBtn addSubview:headLeftImg];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 79.0, self.view.frame.size.width, 1.0)];
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
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0.0, 80.0, self.view.frame.size.width, 330.0);
    headerView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:headerView];
    
    UIImageView *deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fight.png"]];
    deviceImage.frame = CGRectMake((self.view.frame.size.width-80.0)/2, 8.0, 80.0, 80.0);
    deviceImage.backgroundColor = [UIColor clearColor];
    [[PYToolUIAdapt selfAlloc] setViewBorderWith:deviceImage cornerRadius:40.0/PY_SCREEN_RATE borderColor:[UIColor whiteColor] borderWidth:1];
    [headerView addSubview:deviceImage];
    
    m_nameLabel = [[UILabel alloc] init];
    m_nameLabel.frame = CGRectMake(10.0, 92.0, self.view.frame.size.width-20.0, 18.0);
    m_nameLabel.backgroundColor = [UIColor clearColor];
    m_nameLabel.textAlignment = NSTextAlignmentCenter;
    m_nameLabel.text = @"";
    m_nameLabel.textColor = [[PYToolColor selfAlloc] hexColor:@"#32000000"];
    m_nameLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:m_nameLabel];
    
    UIButton *deviceBtn = [[UIButton alloc] init];
    deviceBtn.frame = CGRectMake((self.view.frame.size.width-140.0)/2, 0.0, 140.0, 160.0);
    deviceBtn.backgroundColor = [UIColor clearColor];
    [deviceBtn addTarget:self action:@selector(connectDevice) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:deviceBtn];
    
    m_connectBtn = [[UIButton alloc] init];
    m_connectBtn.frame = CGRectMake((self.view.frame.size.width-140.0)/2, 112.0, 140.0, 36.0);
    [[PYToolUIAdapt selfAlloc] setViewBorderWith:m_connectBtn cornerRadius:18.0/PY_SCREEN_RATE borderColor:[UIColor clearColor] borderWidth:0];
    m_connectBtn.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#FF000000"];
    [m_connectBtn setTitle:@"Device" forState:UIControlStateNormal];
    [m_connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_connectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [m_connectBtn addTarget:self action:@selector(connectDevice) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:m_connectBtn];
    
    double witchDis = 24.0;
    double witchWidth = (self.view.frame.size.width-witchDis*4.0)/3.0;
    if (witchWidth > 100) {
        witchDis = witchDis+(witchWidth-100.0)*3.0/4.0;
        witchWidth = 100.0;
    }
    NSArray *cmdArray = [NSArray arrayWithObjects:
                         @"Upgrade Mode",
                         @"Turn Off\nDevice",
                         @"Punching\nbag Info",
                         nil];

    for (int i = 0; i < cmdArray.count; i++) {
        UIButton *cmdBtn = [[UIButton alloc] init];
        cmdBtn.tag = 400+i;
        cmdBtn.frame = CGRectMake(witchDis+(witchWidth+witchDis)*i, 165.0, witchWidth, witchWidth);
        [[PYToolUIAdapt selfAlloc] setViewBorderWith:cmdBtn cornerRadius:witchWidth/2.0/PY_SCREEN_RATE borderColor:[[PYToolColor selfAlloc] hexColor:@"#FF000000"] borderWidth:1];
        cmdBtn.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#FF000000"];
        [cmdBtn setTitle:[cmdArray objectAtIndex:i] forState:UIControlStateNormal];
        [cmdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cmdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        cmdBtn.titleLabel.numberOfLines = 2;
        cmdBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cmdBtn addTarget:self action:@selector(sendCmd:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:cmdBtn];
    }
    
    m_dataView = [[UIView alloc] init];
    m_dataView.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(0.0, 360.0/PY_SCREEN_RATE, PY_BASE_WEIGHT, PY_SCREEN_HEIGHT-360.0/PY_SCREEN_RATE)];
    m_dataView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_dataView];
    
    m_sandbagView = [[SandbagView alloc] init];
    m_sandbagView.frame = self.view.frame;
    m_sandbagView.backgroundColor = [UIColor clearColor];
    m_sandbagView.sandbag = m_sandbag;
    m_sandbagView.alpha = 0;
    m_sandbagView.delegate = self;
    [self.view addSubview:m_sandbagView];
    
    [self refreshDataUi];
}


/*-****************************************************************************************
* Method: refreshDataUi
* Description: refreshDataUi
* Parameter:
* Return Data:
******************************************************************************************/
- (void)refreshDataUi {
    for (UIView *view in m_dataView.subviews) {
        [view removeFromSuperview];
    }
    
    double dataHeight  = PY_SCREEN_HEIGHT-360.0/PY_SCREEN_RATE-PY_FOOTER_HEIGHT;
    double widthHeight = dataHeight/3.0;
    for (int i = 0; i < m_showArray.count; i++) {
        UIView *showView = [[UIView alloc] init];
        showView.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(0.0, widthHeight*(i%3), PY_BASE_WEIGHT, widthHeight)];
        showView.backgroundColor = [UIColor clearColor];
        [m_dataView addSubview:showView];
        
        UIImageView *downLine = [[UIImageView alloc] init];
        downLine.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(0.0, 0.0, PY_BASE_WEIGHT, 10.0)];
        downLine.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#10000000"];
        [showView addSubview:downLine];
        
        UIImageView *upLine = [[UIImageView alloc] init];
        upLine.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(80.0, 10.0, 1.0, widthHeight-10.0)];
        upLine.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#10000000"];
        [showView addSubview:upLine];
        
        UILabel *showLabel = [[UILabel alloc] init];
        showLabel.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(0.0, 10.0, 80.0, widthHeight-10.0)];
        showLabel.backgroundColor = [UIColor clearColor];
        showLabel.textAlignment = NSTextAlignmentCenter;
        showLabel.textColor = [[PYToolColor selfAlloc] hexColor:@"#32000000"];
        showLabel.font = [UIFont boldSystemFontOfSize:18];
        showLabel.numberOfLines = 2;
        showLabel.adjustsFontSizeToFitWidth = true;
        [showView addSubview:showLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(80.0, 10.0, PY_BASE_WEIGHT-160.0, widthHeight-10.0)];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        valueLabel.textColor = [[PYToolColor selfAlloc] hexColor:@"#FF000000"];
        valueLabel.font = [UIFont boldSystemFontOfSize:50];
        valueLabel.text = [m_showArray objectAtIndex:i];;
        valueLabel.adjustsFontSizeToFitWidth = true;
        [showView addSubview:valueLabel];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(PY_BASE_WEIGHT-80.0, 10.0, 80.0, widthHeight-10.0)];
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.textAlignment = NSTextAlignmentCenter;
        unitLabel.textColor = [[PYToolColor selfAlloc] hexColor:@"#32000000"];
        unitLabel.font = [UIFont systemFontOfSize:18];
        unitLabel.adjustsFontSizeToFitWidth = true;
        [showView addSubview:unitLabel];
        
        if (i == 0) {
            showLabel.text = @"Number";
            unitLabel.text = @"";
        }
        else if (i == 1) {
            showLabel.text = @"Frequency";
            unitLabel.text = @"times/min";
        }
        else if (i == 2) {
            showLabel.text = @"Strength";
            unitLabel.text = @"kg";
        }
    }
    
    UIImageView *downLine1 = [[UIImageView alloc] init];
    downLine1.frame = [[PYToolUIAdapt selfAlloc] adaptScreen:CGRectMake(0.0, widthHeight*3.0, PY_BASE_WEIGHT, 10.0)];
    downLine1.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#10000000"];
    [m_dataView addSubview:downLine1];
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction {
    [m_fightApi disconnectBleApi];
    [self.navigationController popViewControllerAnimated:YES];
}


/*-****************************************************************************************
* Method: connectDevice
* Description: connectDevice
* Parameter:
* Return Data:
******************************************************************************************/
- (void)connectDevice {
    if (m_fightApi.isConnected) {
        [m_fightApi disconnectBleApi];
        m_nameLabel.text = @"";
    }
    else {
        BindDeviceViewController *bindView = [[BindDeviceViewController alloc] init];
        bindView.scanDeviceType = BleDeviceFight;
        bindView.delegate = self;
        [self.navigationController pushViewController:bindView animated:YES];
    }
}

/*-****************************************************************************************
* Method: sendCmd
* Description: sendCmd
* Parameter:
* Return Data:
******************************************************************************************/
- (void)sendCmd:(UIButton *)sender {
    int myTag = (int)sender.tag-400;
    if (m_fightApi.isConnected) {
        if (myTag == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"The device will enter upgrade mode" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self->m_fightApi enterDfuMode];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
        else if (myTag == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Turn off device" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self->m_fightApi turnOffDevice];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self.navigationController presentViewController:alertController animated:YES completion:nil];
        }
        else if (myTag == 2) {
            [UIView animateWithDuration:0.5 animations:^{
                self->m_sandbagView.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Device" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
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
        NSString *uuidString = [[deviceIdArray objectAtIndex:0] objectForKey:@"deviceId"];
        m_nameLabel.text = [[deviceIdArray objectAtIndex:0] objectForKey:@"deviceName"];
        [m_fightApi disconnectBleApi];
        [m_fightApi startConnectBleApi:uuidString andIdType:DeviceIdUUID];
    }
}


/********************************************************************************
 * 方法名称：sendSandbag
 * 功能描述：sendSandbag
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)sendSandbag:(FBKFightSandbag *)mySandbag {
    if (m_fightApi.isConnected) {
        [m_fightApi setSandbag:mySandbag];
    }
}


/********************************************************************************
 * 方法名称：bleConnectStatus
 * 功能描述：蓝牙连接状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)bleConnectStatus:(DeviceBleStatus)status andDevice:(id)bleDevice {
    if (status == DeviceBleSearching || status == DeviceBleConnecting) {
        m_connectBtn.enabled = false;
        m_connectBtn.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#FF000000"];
        [m_connectBtn setTitle:@"Connecting..." forState:UIControlStateNormal];
    }
    else if (status == DeviceBleConnected) {
        m_connectBtn.enabled = true;
        m_connectBtn.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#FFFF0000"];
        [m_connectBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
    }
    else if (status == DeviceBleDisconneced) {
        m_connectBtn.enabled = true;
        m_connectBtn.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#FF000000"];
        [m_connectBtn setTitle:@"Device" forState:UIControlStateNormal];
        
        [m_showArray replaceObjectAtIndex:0 withObject:@"--"];
        [m_showArray replaceObjectAtIndex:1 withObject:@"--"];
        [m_showArray replaceObjectAtIndex:2 withObject:@"--"];
        [self refreshDataUi];
    }
    else if (status == DeviceBleReconnect) {
        m_connectBtn.enabled = true;
        m_connectBtn.backgroundColor = [[PYToolColor selfAlloc] hexColor:@"#FF000000"];
        [m_connectBtn setTitle:@"Connecting..." forState:UIControlStateNormal];
        
        [m_showArray replaceObjectAtIndex:0 withObject:@"--"];
        [m_showArray replaceObjectAtIndex:1 withObject:@"--"];
        [m_showArray replaceObjectAtIndex:2 withObject:@"--"];
        [self refreshDataUi];
    }
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
 * 方法名称：realTimeFight
 * 功能描述：realTimeFight
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)realTimeFight:(FBKFightInfo *)fightInfo andDevice:(id)bleDevice{
//    NSMutableString *resultString = [[NSMutableString alloc] init];
//    [resultString appendFormat:@"协议版本：%i\n",fightInfo.protocolVersion];
//    [resultString appendFormat:@"拳击次数：%i\n",fightInfo.fightNumbers];
//    [resultString appendFormat:@"拳击频率：%i\n",fightInfo.fightFrequency];
//    [resultString appendFormat:@"电量状态：%@\n",fightInfo.isEnoughBattery?@"电量充足":@"低电状态"];
//    [resultString appendFormat:@"力量指数：%i",fightInfo.strengthIndex];
    
    // 0.01490*weight(kg)*拳击指数；
//    double myKg = 0.01490 * m_sandbag.sandbagWeight * fightInfo.strengthIndex;
    double myKg = fightInfo.strengthIndex;
    [m_showArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%i",fightInfo.fightNumbers]];
    [m_showArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%i",fightInfo.fightFrequency]];
    [m_showArray replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%.0f",myKg]];
    
    
    [self refreshDataUi];
}


/********************************************************************************
 * 方法名称：enterDfuResult
 * 功能描述：enterDfuResult
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)enterDfuResult:(BOOL)status andDevice:(id)bleDevice{
    NSString *alertString = @"The device enter upgrade mode failed.";
    if (status) {
        alertString = @"The device enter upgrade mode succeed.";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


/********************************************************************************
 * 方法名称：turnOffDeviceResult
 * 功能描述：turnOffDeviceResult
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)turnOffDeviceResult:(BOOL)status andDevice:(id)bleDevice{
    NSString *alertString = @"Turn off device failed.";
    if (status) {
        alertString = @"Turn off device succeed.";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


/********************************************************************************
 * 方法名称：setSandbagResult
 * 功能描述：setSandbagResult
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setSandbagResult:(BOOL)status andDevice:(id)bleDevice{
    NSString *alertString = @"Set punching bag information failed.";
    if (status) {
        alertString = @"Set punching bag information succeed.";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertString message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}


@end
