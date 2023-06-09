/********************************************************************************
 * 文件名称：WiFiListViewController.h
 * 内容摘要：WiFi 列表
 * 版本编号：1.0.1
 * 创建日期：2018年07月05日
 ********************************************************************************/

#import "WiFiListViewController.h"

@interface WiFiListViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate> {
    UITableView     *m_wifiTableView; // 设备列表
    NSMutableArray  *m_wifiArray;     // 设备列表数据
    UITextField     *m_nameField;
    UITextField     *m_passwordField;
    NSMutableDictionary *m_wifiDic;
}

@end

@implementation WiFiListViewController

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
    
    m_wifiArray = [[NSMutableArray alloc] initWithArray:self.scanWifiList];
    m_wifiDic = [[NSMutableDictionary alloc] init];
    
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
    titleLab.text = @"WiFi List";
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
    m_nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, self.view.frame.size.width-100, 38)];
    [self setViewBorderWithView:m_nameField cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    m_nameField.returnKeyType = UIReturnKeyDefault;
    m_nameField.backgroundColor = [UIColor clearColor];
    m_nameField.textAlignment = NSTextAlignmentCenter;
    m_nameField.placeholder = @"WiFi SSID";
    m_nameField.font = [UIFont systemFontOfSize:16];
    m_nameField.textColor = [UIColor blackColor];
    m_nameField.text = @"";
    m_nameField.delegate = self;
    [m_nameField setEnabled:NO];
    [self.view addSubview:m_nameField];
    
    m_passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 138, self.view.frame.size.width-100, 38)];
    [self setViewBorderWithView:m_passwordField cornerRadius:6 borderColor:[UIColor blackColor] borderWidth:1];
    m_passwordField.returnKeyType = UIReturnKeyDefault;
    m_passwordField.secureTextEntry = NO;
    m_passwordField.backgroundColor = [UIColor clearColor];
    m_passwordField.textAlignment = NSTextAlignmentCenter;
    m_passwordField.placeholder = @"Password";
    m_passwordField.font = [UIFont systemFontOfSize:16];
    m_passwordField.textColor = [UIColor blackColor];
    m_passwordField.text = @"";
    m_passwordField.delegate = self;
    [self.view addSubview:m_passwordField];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 90, 60, 86)];
    [self setViewBorderWithView:saveButton cornerRadius:6 borderColor:[UIColor clearColor] borderWidth:0];
    saveButton.backgroundColor = [UIColor blackColor];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [saveButton addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 185, self.view.frame.size.width, 1)];
    myLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:myLine];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    
    m_wifiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 186, self.view.frame.size.width, self.view.frame.size.height-170)];
    m_wifiTableView.delegate = self;
    m_wifiTableView.dataSource = self;
    m_wifiTableView.backgroundColor = [UIColor clearColor];
    [m_wifiTableView setTableFooterView:footerView];
    m_wifiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_wifiTableView];
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
    [self.navigationController popViewControllerAnimated:YES];
}


/********************************************************************************
 * 方法名称：savePassword
 * 功能描述
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)savePassword {
    [m_nameField resignFirstResponder];
    [m_passwordField resignFirstResponder];
    [m_wifiDic setObject:m_passwordField.text forKey:@"hubPassword"];
    [m_wifiDic setObject:@"1" forKey:@"setMode"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate chooseWiFiStaInfo:m_wifiDic];
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
    return m_wifiArray.count;
}


/********************************************************************************
 * 方法名称：heightForRowAtIndexPath
 * 功能描述：设置TableView的行高
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
    static NSString *cellString = @"WiFiListCell";
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

    NSString *hubSsid = [[m_wifiArray objectAtIndex:indexPath.row] objectForKey:@"hubSsid"];
    NSString *ssidName = [[m_wifiArray objectAtIndex:indexPath.row] objectForKey:@"ssidName"];
    NSString *wifiMac = [[m_wifiArray objectAtIndex:indexPath.row] objectForKey:@"wifiMac"];
    NSString *encryptionName = [[m_wifiArray objectAtIndex:indexPath.row] objectForKey:@"encryptionName"];
    NSString *algorithmName = [[m_wifiArray objectAtIndex:indexPath.row] objectForKey:@"algorithmName"];

    UILabel *info1Lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width-60, 80)];
    info1Lab.textAlignment = NSTextAlignmentLeft;
    info1Lab.font = [UIFont systemFontOfSize:14];
    info1Lab.textColor = [UIColor blackColor];
    info1Lab.text = [NSString stringWithFormat:@"SSID:%@(%@)  \nWiFiMac:%@  \nMode:%@/%@",ssidName, hubSsid, wifiMac,encryptionName,algorithmName];
    info1Lab.numberOfLines = 5;
    [cell.contentView addSubview:info1Lab];
    
    UIView *myLine = [[UIView alloc] initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1)];
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
    m_wifiDic = [[NSMutableDictionary alloc] initWithDictionary:[m_wifiArray objectAtIndex:indexPath.row]];
    NSString *ssidName = [[m_wifiArray objectAtIndex:indexPath.row] objectForKey:@"ssidName"];
    m_nameField.text = ssidName;
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
