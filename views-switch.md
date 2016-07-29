###iOS视图跳转的方式

####1.使用modal方式进行跳转

* modal方式跳转，其实就是通过方法 - (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion跳转

* present方法，是所有视图控制器对象都有的成员方法，但是需要注意的是，同一个视图控制器，在同一个时间，只能present一个另外的视图控制器，如果当前的VC已经present了，再次present一个VC时，就会提示失败，如果想继续present，就必须将原来present的控制器dismiss。

* 另外有两个只读属性：presentedViewController和presentingViewController，他们分别是被present的控制器和正在presenting的控制器。比如说， 控制器A和B，[A presentViewController B animated：YES completion：nil]; 那么A相对于B就是presentingViewController，B相对于A是presentedViewController，即这个时候：  
B.presentingViewController = A;
A.presentedViewController = B;

* modal方法一般用在两个控制器没有什么逻辑关系的情况下，且弹出方式是从下往上弹出，弹出另一个控制器的时候自身并不会销毁

```
-(void)login{
    KCLoginViewController *loginVC=[[KCLoginViewController alloc]init];
    //调用此方法显示窗口
    [self presentViewController:loginVC animated:YES completion:nil];
}
@end
```


####2.使用导航控制器进行跳转

* 导航控制器进行界面跳转用的方法为：pushViewController，且此种方法是uinavigationcontroller 和其子类才有的方法

* 弹出某个界面，返回到上个界面使用方法为：popViewController（注意，当当前界面是根结面时，这个方法是不起作用的）

* 跳转到某个特定的控制器，使用的方法为：popToViewController（获取需要跳转的界面的方式有很多，我一般是遍历UINavigationController的viewControllers数组，用iskindofclass方法来获取某个控制器对象再来跳转的）

* 导航控制器中的子控制器以栈的方式进行管理，各个视图的切换就是压栈和出栈操作，出栈后的视图会立即销毁，且弹出方式为从右到左

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _window.backgroundColor =[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];

    KCFriendViewController *friendVC=[[KCFriendViewController alloc]init];
    
    UINavigationController *navigationController=[[UINavigationController alloc]initWithRootViewController:friendVC];
    
    _window.rootViewController=navigationController;
    
    [_window makeKeyAndVisible];
    
    return YES;
```

####3.通过UITabBarcontroller进行跳转

* 一般作为app的根界面视图控制器。UITabBarController的界面跳转，其实是界面切换，因为UITabBarController的界面跳转其实就是UITabBarController的viewControllers数组中的几个界面切换

* UITabBarController：以平行的方式管理视图，各个视图之间往往关系并不大，在初始化UITabBarController时，每个加入到UITabBarController的视图都会进行初始化即使当前不显示在界面上。

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    KCTabBarViewController *tabBarController=[[KCTabBarViewController alloc]init];
    
    KCWebChatViewController *webChatVC=[[KCWebChatViewController alloc]init];
    KCContactViewController *contactVC=[[KCContactViewController alloc]init];
    tabBarController.viewControllers=@[webChatVC,contactVC];
    //注意默认情况下UITabBarController在加载子视图时是懒加载的，所以这里调用一次contactVC，否则在第一次展示时只有第一个控制器tab图标，contactController的tab图标不会显示
    for (UIViewController *controller in tabBarController.viewControllers) {
        UIViewController *view= controller.view;
    }
    _window.rootViewController=tabBarController;
    [_window makeKeyAndVisible];
    
    return YES;
}
```