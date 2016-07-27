###iphone与App icon尺寸

**手机尺寸(pt)**

* iPhone4：320*480
* iPhone5：320*568
* iPhone6：375*667
* iPhone6plus： 414*736

**APP icon尺寸(px)**

1. 桌面图标
   * iPhone6/5/4s：120*120
   * iPhone6plus: 180*180
 
2. 系统搜索框图标
   * iPhone6/5/4s：80*80
   * iPhone6plus:  120*120
4. 系统设置图标
   * iPhone6/5/4s：58*58
   * iPhone6plus: 87*87
5. 启动图片
   * iPhone4：640*960
   * iPhone5：640*1136
   * iPhone6：750*1334
   * iPhone6plus：1242*2208
   
#####App icon的理解

* 使用APP icon的时候，把准备好的对应尺寸的图片拖入到项目的images.xcassets文件夹下，系统会根据图片尺寸自动的作出相关匹配
* 在设置启动图片的时候，要把启动图片放入images.xcassets文件夹下的lanunchimage中
* 由于iPhone6s Plus为三倍像素，所以为了屏幕的适配，在准备图片时，要作出@2x的图片和@3x的图片