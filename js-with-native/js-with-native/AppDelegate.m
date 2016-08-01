//
//  AppDelegate.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginNamecontroller.h"
#import <notify.h>


@interface AppDelegate ()
@property(nonatomic,strong)NSString *status;


@end

@implementation AppDelegate

static void displayStatusChanged(CFNotificationCenterRef center,
                                 void *observer,
                                 CFStringRef name,
                                 const void *object,
                                 CFDictionaryRef userInfo) {
    if (name == CFSTR("com.apple.springboard.lockcomplete")) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisplayStatusLocked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


}

static void setScreenStateCb()

{
    
    uint64_t locked;
    
    dispatch_once_t p;
    
    __block int token = 0;
    notify_register_dispatch("com.apple.springboard.lockstate",&token,dispatch_get_main_queue(),^(int t){
    });
    notify_get_state(token, &locked);
    
    if ((int)locked ==1) {
    NSLog(@"我知道，但不吭声");
    
    }
//    NSLog(@"我知道，但不吭声");
    
}
//////////////////////////////////////////////////////////


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LoginName *login = [[LoginName alloc] init ];
    self.window.rootViewController = login;
    [self.window makeKeyAndVisible];
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    displayStatusChanged,
                                    CFSTR("com.apple.springboard.lockcomplete"),
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
   
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"我休息一下");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    
 
    while (YES) {

        setScreenStateCb();
        sleep(1);
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kDisplayStatusLocked"]) {
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"标题" message:@"开始工作了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert1 addAction:action];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert1 animated:YES completion:nil];
    }else{
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"标题" message:@"欢迎回来" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert1 addAction:action];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert1 animated:YES completion:nil];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisplayStatusLocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.



}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
