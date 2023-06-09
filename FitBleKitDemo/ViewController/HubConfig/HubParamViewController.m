/********************************************************************************
 * 文件名称：HubParamViewController.h
 * 内容摘要：hub 参数设置
 * 版本编号：1.0.1
 * 创建日期：2018年07月05日
 ********************************************************************************/

#import "HubParamViewController.h"

@interface HubParamViewController ()<UITextFieldDelegate> {
    NSMutableDictionary *m_infoDic;
    UITextField *m_ipField;
    UITextField *m_portField;
}

@end

@implementation HubParamViewController

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
    
    m_infoDic = [[NSMutableDictionary alloc] initWithDictionary:self.hubInfo];
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
    titleLab.text = @"Hub Param";
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
    [headRightBtn setTitle:@"Save" forState:UIControlStateNormal];
    [headRightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    headRightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [headRightBtn addTarget:self action:@selector(saveParamInfo) forControlEvents:UIControlEventTouchUpInside];
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
    UIButton *hiddenButton = [[UIButton alloc] init];
    hiddenButton.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-80);
    hiddenButton.backgroundColor = [UIColor clearColor];
    [hiddenButton addTarget:self action:@selector(hiddenKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenButton];
    
    NSArray *socketArray = [[NSArray alloc]initWithObjects:@"Socket A", @"Socket B", nil];
    UISegmentedControl *socketSe = [[UISegmentedControl alloc]initWithItems:socketArray];
    [self setViewBorderWithView:socketSe cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    socketSe.tag = 100;
    socketSe.segmentedControlStyle = UISegmentedControlStyleBar;
    socketSe.backgroundColor = [UIColor clearColor];
    socketSe.selectedSegmentIndex = 0;
    [socketSe addTarget:self action:@selector(segmentedAction:)forControlEvents:UIControlEventValueChanged];
    socketSe.tintColor = [UIColor blackColor];
    socketSe.frame = CGRectMake(20, 96, self.view.frame.size.width-40, 35);
    [self.view addSubview:socketSe];
    
    NSString *socketNum = [NSString stringWithFormat:@"%@",[m_infoDic objectForKey:@"hubSocketNo"]];
    if ([socketNum isEqualToString:@"1"]) {
        socketSe.selectedSegmentIndex = 1;
    }
    
    if (!self.isSetParam) {
        return;
    }
    
    NSArray *proArray = [[NSArray alloc]initWithObjects:@"TCP", @"UDP", nil];
    UISegmentedControl *proSe = [[UISegmentedControl alloc]initWithItems:proArray];
    [self setViewBorderWithView:proSe cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    proSe.tag = 101;
    proSe.segmentedControlStyle = UISegmentedControlStyleBar;
    proSe.backgroundColor = [UIColor clearColor];
    proSe.selectedSegmentIndex = 1;
    [proSe addTarget:self action:@selector(segmentedAction:)forControlEvents:UIControlEventValueChanged];
    proSe.tintColor = [UIColor blackColor];
    proSe.frame = CGRectMake(20, 146, self.view.frame.size.width-40, 35);
    [self.view addSubview:proSe];
    
    NSString *proNum = [NSString stringWithFormat:@"%@",[m_infoDic objectForKey:@"hubSocketProtocol"]];
    if ([proNum isEqualToString:@"1"]) {
        proSe.selectedSegmentIndex = 0;
    }
    
    NSArray *csArray = [[NSArray alloc]initWithObjects:@"SERVER", @"CLIENT", nil];
    UISegmentedControl *csSe = [[UISegmentedControl alloc]initWithItems:csArray];
    [self setViewBorderWithView:csSe cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    csSe.tag = 102;
    csSe.segmentedControlStyle = UISegmentedControlStyleBar;
    csSe.backgroundColor = [UIColor clearColor];
    csSe.selectedSegmentIndex = 1;
    [csSe addTarget:self action:@selector(segmentedAction:)forControlEvents:UIControlEventValueChanged];
    csSe.tintColor = [UIColor blackColor];
    csSe.frame = CGRectMake(20, 196, self.view.frame.size.width-40, 35);
    [self.view addSubview:csSe];
    
    NSString *csNum = [NSString stringWithFormat:@"%@",[m_infoDic objectForKey:@"hubSocketCs"]];
    if ([csNum isEqualToString:@"1"]) {
        csSe.selectedSegmentIndex = 0;
    }
    
    m_ipField = [[UITextField alloc] initWithFrame:CGRectMake(20, 246, self.view.frame.size.width-40, 35)];
    [self setViewBorderWithView:m_ipField cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    m_ipField.returnKeyType = UIReturnKeyDefault;
    m_ipField.backgroundColor = [UIColor clearColor];
    m_ipField.textAlignment = NSTextAlignmentCenter;
    m_ipField.placeholder = @"Socket IP";
    m_ipField.font = [UIFont systemFontOfSize:14];
    m_ipField.textColor = [UIColor blackColor];
    m_ipField.text = [NSString stringWithFormat:@"%@",[m_infoDic objectForKey:@"hubSocketIp"]];
    m_ipField.delegate = self;
    [self.view addSubview:m_ipField];
    
    m_portField = [[UITextField alloc] initWithFrame:CGRectMake(20, 296, self.view.frame.size.width-40, 35)];
    [self setViewBorderWithView:m_portField cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    m_portField.returnKeyType = UIReturnKeyDefault;
    m_portField.backgroundColor = [UIColor clearColor];
    m_portField.textAlignment = NSTextAlignmentCenter;
    m_portField.placeholder = @"Socket Port";
    m_portField.font = [UIFont systemFontOfSize:14];
    m_portField.textColor = [UIColor blackColor];
    m_portField.text = [NSString stringWithFormat:@"%@",[m_infoDic objectForKey:@"hubSocketPort"]];
    m_portField.delegate = self;
    [self.view addSubview:m_portField];
}


/********************************************************************************
 * 方法名称：setViewBorderWithView
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)setViewBorderWithView:(UIView *)view cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    view.layer.cornerRadius = cornerRadius;  //圆弧半径
    view.layer.borderColor = borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    view.layer.masksToBounds = YES;
}


#pragma mark - **************************** 触发方法 *****************************
/********************************************************************************
 * 方法名称：backAction
 * 功能描述：返回
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)backAction {
    [self hiddenKeyBoard];
    [self.navigationController popViewControllerAnimated:YES];
}


/********************************************************************************
 * 方法名称：saveParamInfo
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)saveParamInfo {
    if (self.isSetParam) {
        [m_infoDic setObject:m_ipField.text forKey:@"hubSocketIp"];
        [m_infoDic setObject:m_portField.text forKey:@"hubSocketPort"];
        [self.delegate hubParamResult:m_infoDic isSet:YES];
        [self backAction];
    }
    else {
        [self.delegate hubParamResult:m_infoDic isSet:NO];
        [self backAction];
    }
}


/********************************************************************************
 * 方法名称：segmentedAction
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)segmentedAction:(UISegmentedControl *)segmented {
    NSInteger Index = segmented.selectedSegmentIndex;
    int myTag = (int)segmented.tag;
    switch (myTag) {
        case 100: {
            if (Index == 0) {
                [m_infoDic setObject:@"0" forKey:@"hubSocketNo"];
            }
            else {
                [m_infoDic setObject:@"1" forKey:@"hubSocketNo"];
            }
            break;
        }
            
        case 101: {
            if (Index == 0) {
                [m_infoDic setObject:@"1" forKey:@"hubSocketProtocol"];
            }
            else {
                [m_infoDic setObject:@"2" forKey:@"hubSocketProtocol"];
            }
            break;
        }
            
        case 102: {
            if (Index == 0) {
                [m_infoDic setObject:@"1" forKey:@"hubSocketCs"];
            }
            else {
                [m_infoDic setObject:@"2" forKey:@"hubSocketCs"];
            }
            break;
        }
            
        default:
            break;
    }
}


/********************************************************************************
 * 方法名称：hiddenKeyBoard
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)hiddenKeyBoard {
    [m_ipField resignFirstResponder];
    [m_portField resignFirstResponder];
}


/********************************************************************************
 * 方法名称：textFieldShouldReturn
 * 功能描述：
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end
