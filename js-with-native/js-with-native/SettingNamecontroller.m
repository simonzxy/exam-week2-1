//
//  SettingName.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "SettingNamecontroller.h"
#import "LoginNamecontroller.h"
#import "MainNamecontroller.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SettingName ()<UIWebViewDelegate>
@property(nonatomic,strong)JSContext *context;

@end

@implementation SettingName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建webview
    UIWebView *web =[[UIWebView alloc] init];
    web.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:web];
    web.delegate = self;
    //获取本地文件路径，webview加载
    NSString *pathml = [[NSBundle mainBundle] pathForResource:@"setting" ofType:@"html"];
    NSURL *url =  [NSURL URLWithString:pathml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    //返回的调用方法
    _context[@"back"] = ^(){
        
       
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        };
    //登出的调用方法
    _context[@"logout"] = ^(){
        
        LoginName *login = [[LoginName alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = login;
        [weakSelf dismissViewControllerAnimated:NO completion:nil];

        
    };
    
}

-(void)dealloc{

    NSLog(@"setting dealloc");
}
@end
