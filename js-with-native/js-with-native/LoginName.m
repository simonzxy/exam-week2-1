//
//  LoginName.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "LoginName.h"
#import "MainName.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface LoginName ()<UIWebViewDelegate>
@property(nonatomic,strong)JSContext *context;

@end

@implementation LoginName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //创建webview
    UIWebView *web =[[UIWebView alloc] init];
    web.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:web];
    web.delegate = self;
    //获取本地文件路径，webview加载
    NSString *pathml = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"];
    NSURL *url =  [NSURL URLWithString:pathml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    _context[@"btn"] = ^(){
        
        MainName *main = [[MainName alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = main;

        
        
        
    };
  
}

-(void)dealloc{

    NSLog(@"login dealloc");
}


@end
