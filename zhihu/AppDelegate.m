//
//  AppDelegate.m
//  zhihu
//
//  Created by bytedance on 2020/12/9.
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MainViewController.h"
#import "MyViewController.h"
#import "MessageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"username"]){
        UITabBarController *tabbarController = [[UITabBarController alloc]init];
        UINavigationController *mainNav = [self navWithRootVC:[MainViewController new]];
        mainNav.tabBarItem.title = @"首页";
        UINavigationController *msgNav = [self navWithRootVC:[MessageViewController new]];
        msgNav.tabBarItem.title = @"消息";
        UINavigationController *myNav = [self navWithRootVC:[MyViewController new]];
        myNav.tabBarItem.title = @"我的";
        [tabbarController setViewControllers:@[mainNav, myNav]];
        self.window.rootViewController = tabbarController;
    } else {
        //跳转到登录界面
        ViewController * loginController = [[ViewController alloc]init];
        loginController.view.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = loginController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (UINavigationController *)navWithRootVC:(UIViewController *)rootVC {
    if (!rootVC) {
        return nil;
    }
    return [[UINavigationController alloc] initWithRootViewController:rootVC];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
