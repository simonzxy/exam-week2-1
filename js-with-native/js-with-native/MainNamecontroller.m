//
//  MainName.m
//  js-with-native
//
//  Created by 朱益达 on 16/7/27.
//  Copyright © 2016年 朱益达. All rights reserved.
//

#import "MainNamecontroller.h"
#import "SettingNamecontroller.h"
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
        [self presentViewController:setting animated:NO completion:nil];
        
    };
    _context[@"call"] = ^(){
        
        NSLog(@"API呼叫");//测试代码
        
        [weakSelf apicall];//自定义方法进行网络请求
    };
    
}

-(void)apicall{

    NSURLSession *session = [NSURLSession sharedSession];
    
//    _urlstr = @"https://api.douban.com/v2/book/1220562";
    _urlstr = @"http://apis.juhe.cn/cook/queryid?key=95da610cfef936cd972d23c10f25f818&id=1001";
    
    NSURL *url = [NSURL URLWithString:_urlstr];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
      // NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //js与oc交互之 oc调用js
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [_web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"api('%@','%@');",_urlstr,str]];

       
        });
        
    }];
    [task resume];
}



@end
