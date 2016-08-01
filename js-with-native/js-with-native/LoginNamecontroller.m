//
//  LoginName.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "LoginNamecontroller.h"
#import "MainNamecontroller.h"
#import "WebViewJavascriptBridge.h"


@interface LoginName ()
@property(nonatomic,strong)WebViewJavascriptBridge *bridge;


@end

@implementation LoginName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewWillAppear:YES];
    //创建webview
    UIWebView *web =[[UIWebView alloc] init];
    web.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:web];
    //获取本地文件路径，webview加载
    NSString *pathml = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"];
    NSURL *url =  [NSURL URLWithString:pathml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    _bridge=[WebViewJavascriptBridge bridgeForWebView:web];
//    [_bridge registerHandler:@"mainload" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"调用完成");
//        
//         dispatch_async(dispatch_get_main_queue(), ^(){
//           MainName *main = [[MainName alloc] init];
//           [UIApplication sharedApplication].keyWindow.rootViewController = main;
//            });
//        
//        responseCallback(data);
//    }];
    
    [_bridge registerHandler:@"mainload" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"调用完成");
        MainName *bview=[[MainName alloc]init];
        //[self.navigationController popViewControllerAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self presentViewController:bview animated:YES completion:^{
                [self.view removeFromSuperview];
            }];
            
        });
        
        responseCallback(data);
    }];
}



-(void)dealloc{

    NSLog(@"login dealloc");
}


@end
