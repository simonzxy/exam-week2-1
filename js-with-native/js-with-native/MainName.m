//
//  MainName.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "MainName.h"
#import "SettingName.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface MainName ()<UIWebViewDelegate>
@property(nonatomic,strong)JSContext *context;
@property(nonatomic,strong)NSString *urlstr;
@property(nonatomic,strong)UIWebView *web;

@end

@implementation MainName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    //创建webview
    _web =[[UIWebView alloc] init];
    _web.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:_web];
    _web.delegate = self;
    //获取本地文件路径，webview加载
    NSString *pathml = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"html"];
    NSURL *url =  [NSURL URLWithString:pathml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    _context[@"setting"] = ^(){
        
        SettingName *setting = [[SettingName alloc] init];
        [weakSelf presentViewController:setting animated:NO completion:nil];
        
    };
    _context[@"call"] = ^(){
        
        NSLog(@"API呼叫");//测试代码
        
        [weakSelf apicall];//自定义方法进行网络请求
    };
    
}

-(void)apicall{

    NSURLSession *session = [NSURLSession sharedSession];
    
    _urlstr = @"http://v.juhe.cn/nba/team_info_byId.php?team_id=8&key=e34f42ff859ed3aa974401bdde36dccf";
    
    NSURL *url = [NSURL URLWithString:_urlstr];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //js与oc交互之 oc调用js
        dispatch_async(dispatch_get_main_queue(), ^{
        [_web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"api('%@');",_urlstr]];

            
            // NSLog(@"%@",str);//测试代码
        });
        
    }];
    [task resume];
}



@end
