/********************************************************************************
 * 文件名称：AppDelegate.m
 * 内容摘要：启动页面
 * 版本编号：1.0.1
 * 创建日期：2017年10月31日
 ********************************************************************************/

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - **************************** 系统方法 *****************************
/********************************************************************************
 * 方法名称：didFinishLaunchingWithOptions
 * 功能描述：启动
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ViewController *mainView = [[ViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    self.window.rootViewController = mainNav;
    return YES;
}


/********************************************************************************
 * 方法名称：applicationWillResignActive
 * 功能描述：应用挂起
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


/********************************************************************************
 * 方法名称：applicationDidEnterBackground
 * 功能描述：应用进入后台
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}


/********************************************************************************
 * 方法名称：applicationWillEnterForeground
 * 功能描述：应用进入前台
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}


/********************************************************************************
 * 方法名称：applicationDidBecomeActive
 * 功能描述：应用进入活跃状态
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}


/********************************************************************************
 * 方法名称：applicationWillTerminate
 * 功能描述：应用退出／内存不足
 * 输入参数：
 * 返回数据：
 ********************************************************************************/
- (void)applicationWillTerminate:(UIApplication *)application
{
    
}


@end
