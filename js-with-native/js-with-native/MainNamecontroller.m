//
//  MainName.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "MainNamecontroller.h"
#import "SettingNamecontroller.h"
#import "WebViewJavascriptBridge.h"

@interface MainName ()

@property(nonatomic,strong)NSString *urlstr;
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)WebViewJavascriptBridge *bridge;

@end

@implementation MainName

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建webview
    _web =[[UIWebView alloc] init];
    _web.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:_web];
    
    //获取本地文件路径，webview加载
    NSString *pathml = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"html"];
    NSURL *url =  [NSURL URLWithString:pathml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];
    [WebViewJavascriptBridge enableLogging];
    _bridge =[WebViewJavascriptBridge bridgeForWebView:_web];
    
    
    //设置按钮之间  js与oc交互
    [_bridge registerHandler:@"setting" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"调用完成");
        
        //[self.navigationController popViewControllerAnimated:YES];
        dispatch_async(dispatch_get_main_queue(), ^(){
        SettingName *setting = [[SettingName alloc] init];
        [self presentViewController:setting animated:NO completion:nil];

         });
        
    }];
    
    //API请求按钮之间  js与oc交互
    [_bridge registerHandler:@"loadapi" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"调用完成");
        
        NSURLSession *session = [NSURLSession sharedSession];
        
         _urlstr = @"http://iamjay.name/api/single_quota";
  //     _urlstr = @"http://apis.juhe.cn/cook/queryid?key=95da610cfef936cd972d23c10f25f818&id=1001";
        
        NSURL *url = [NSURL URLWithString:_urlstr];
        
        NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            
            [_bridge callHandler:@"loadadress" data:_urlstr responseCallback:nil];
            
            
            [_bridge callHandler:@"loadcontent" data:str responseCallback:nil];
            
        }];
        [task resume];
   

        
    }];
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    

        

        
// 
//    _context[@"call"] = ^(){
//        
//        NSLog(@"API呼叫");//测试代码
//        
//        [weakSelf apicall];//自定义方法进行网络请求
//    };
    
}

-(void)apicall{

    NSURLSession *session = [NSURLSession sharedSession];
    
    _urlstr = @"http://iamjay.name/api/single_quota";
 //   _urlstr = @"http://apis.juhe.cn/cook/queryid?key=95da610cfef936cd972d23c10f25f818&id=1001";
    
    NSURL *url = [NSURL URLWithString:_urlstr];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        
        [_bridge callHandler:@"showapiinner" data:str responseCallback:^(id response) {
            NSLog(@"testJavascriptHandler responded: %@", response);
        }];
        
    }];
    [task resume];
}



@end
