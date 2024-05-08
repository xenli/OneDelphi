# OneDelphi 
## OneDelphi是叫兽(FLM)QQ:378464060基于Delphi IDE开发的三层中间件，开源免费，支持MVC及传统DataSet框架，使用的是Mormot2的HTTP通讯

[![Security Status](https://www.murphysec.com/platform3/v31/badge/1676410356589420544.svg)](https://www.murphysec.com/console/report/1676410356530700288/1676410356589420544)

## One系列相关介绍http://pascal.callbaba.cn/
>                                                 叫兽(FLM)出品
>                                                 QQ:378464060
点击链接加入群聊【OneDelphi开源群】：https://jq.qq.com/?_wv=1027&k=AGDV4HQi  
QQ群：814696487（原来的群被封了，请加新群）

---
>另外我录制了一期oneDelphi对接uniapp的视频，需要的可以看看，大佬请划过,不喜勿喷；  
>第一次录视频，前几集声音有点小，就这样看吧。  
>其中也有叫兽录制的关于OneFastClient的视频，需要的可以看看  
>视频地址：https://space.bilibili.com/344699795  
>视频中用到的DIYGW工具有需要可以找我，有优惠。QQ/微信：630425535  
---
                                           
环境是基于 D11的，其它低版本，可能系统库 部份不兼容
### 1.控件包mormot2下载，群文件里面也有直接到群下载也行
  https://github.com/synopse/mORMot2
	*注意：*	static目录里的文件需要单独下载  
	https://synopse.info/files/mormot2static.7z   
### 2.控件包mormot2源码路径加到Lib

----以上多是基础操作不会的不要问，没时间回答-----
### 3.打开 OneService.dpr 工程
### 4.编译，运行 即可
### 5.目前做好了MVC基础功能看源码单元httpServer->Controller->Demo-> DemoController.pas
   // 注册到路由 DemoController.initialization部份，路由如何注册
   // 注意，路由名称 不要一样，否则会判定已注册过，跳过
  // 多例模式注册
  OneHttpRouterManage.GetInitRouterManage().AddHTTPPoolWork('DemoA',TDemoController, 100, CreateNewDemoController);
  // 单例模式注册
  OneHttpRouterManage.GetInitRouterManage().AddHTTPSingleWork('DemoB',TDemoController, 100, CreateNewDemoController);
  // 方法注册
 OneHttpRouterManage.GetInitRouterManage().AddHTTPEvenWork('DemoEven',HelloWorldEven, 10);
 
### 6.直接用http页面输入地址请求相关url或者相关HTTP请求工具
  例:  http://127.0.0.1:9090/DemoA/GetPersonListT



## 目前传统客户端基本已完成;
### 1.数据打开保存,执行DML执行存储过程-对应Demo->OneClientDemo.dproj
### 2.客户端事务自由控制-对应Demo->OneCleintDemoCustTran.dproj
### 3.多个数据批量打开，批量保存-对应Demo->OneCleintDemoDatas.dproj
### 4.客户端post,get请求-对应Demo->OneCleintDemoPostGet.dproj
### 5.异步打开数据及保存-对应Demo->OneCleintDemoAsync.dproj
### 6.虚拟文件上传下载-对应Demo->OneClientDemoVirtualFile.dproj
### 7.大文件上传下载-对应Demo->OneClientDemoVirtualFile.dproj

![](https://bbs.2ccc.com/attachments/2023/flmbbb_202358101428.jpg "title")

## 更新日志

*****************2024-04-30*****************  
服务端:  
	1:承担web站点时，增加mjs文件头部的输出
	OneHttpServer单元 GetCustContentType 如果系统返回的不一样。这边自定义一些就好了  
客户端:  
 	1.文件分块上传，返回文件名的问题处理，详细看demo   

*****************2024-04-10*****************  
服务端: 增加 TOneAuthor=> TCustomAttribute 注解,需授权验证才可以访问API接口  
   增加Demo TDemoAuthorController 使用例子  
   TDemoAuthorController = class(TOneControllerBase)
  public
    // 建议使用方式
    // 跟据ulr?后面的参数获取相关验证信息
    [TOneAuthor(TOneAuthorGetMode.token)]
    [TOneHttpGet]
    function GetTestA(name: string; sex: string): string;

    // 建议使用方式
    // 跟据关部 Authorization获取验证信息
    [TOneAuthor(TOneAuthorGetMode.header)]
    [TOneHttpGet]
    function GetTestB(name: string; sex: string): string;

    // 底程有提供相关方法,线程安全直接调用
    // 但个人建议还是用注解方式
    [TOneHttpGet]
    function GetTestC(name: string; sex: string): string;
  end;
        

*****************2024-04-05*****************  
服务端: 
    增加 TOneRouter=> TCustomAttribute 注解  
            增加匿名路由,如下Demo DemoAttributeController  
              //增加匿名路由,访问地址如下  
             //http://127.0.0.1:9090/DemoAttribute/mytest  
             //而不是 http://127.0.0.1:9090/DemoAttribute/CustRouter  
    [TOneRouter('/mytest')]  
    [TOneHttpPost]  
    function CustRouter(name: string; sex: string): string;  

  
*****************2024-04-04*****************  
服务端: 
    增加 TCustomAttribute 注解相关功能,慢慢升级吧。大多人理解不了这些东东，  
	Attribute功能玩法有很多，高版本D才支持，这也是我一直不加上去的原因。。。   
                思考在三后，还是加了，慢慢增加一些Attribute高级玩法，  
	升级这些多很快，我也就好了半小时，增加此功能。。OnePascel本身就易于扩展自已想要的东东  
           1.参考服务端Demo  DemoAttributeController  
  如下：	 
   type  
  TDemoAttributeController = class(TOneControllerBase)  
     //取参数取的是ULR ?后面的参数,且只支持Get访问,不需要以OneGet开头  
    [TOneHttpGet]  
    function GetTest(name: string;sex:string): string;  
 
     //取参数取的是ULR路径的参数 /url路径/myname/mysex;,不需要以OnePath开头  
    [TOneHttpPath]  
    function GetPath(name: string;sex:string): string;  

    //取参数取的是post Data数据且为JSON格式,且只支持Post访问,不需要以OnePost开头  
    [TOneHttpPost]  
    function PostTest(name: string;sex:string): string;  

     //取参数取的是post Data数据,且只支持Post访问  
     //data数据是表单格式 key1=value1&key2=value2  
     //数据之间是用&关联  
    [TOneHttpForm]  
    function PostForm(name: string;sex:string): string;  


  end;  



 
*****************2024-03-30*****************  
服务端:  
    由httpanyServer改成httpserver   
           momrmot2的httpanyserver在某此场景环境不极其不稳定  

*****************2024-01-28*****************  
主要进行控件升级mormot2升级,neo控件升级  


*****************2024-01-13*****************  
服务端增加web目录功能:  
	1.OneWeb目录,Exe运行程序下同级目录  OnePlatform\OneWeb 承担web站点  
                   我的Exe路径 D:\devTool\delphi\project\OneDelphi\OneServer\Win64\Debug  
	   访问路径示例如下 http://127.0.0.1:9090/oneweb/index.html   
                   即访问目录 D:\devTool\delphi\project\OneDelphi\OneServer\Win64\Debug\OnePlatform\OneWeb\index.html 网站  
	   访问路径示例如下 http://127.0.0.1:9090/oneweb/myjxc/index.html   
                   即访问目录 D:\devTool\delphi\project\OneDelphi\OneServer\Win64\Debug\OnePlatform\OneWeb\myjxc\index.html 网站  
                 
	2.HTTP访问路径  http://127.0.0.1:9090/onewebv/虚拟目录代码/index.html   
                   访问的是虚拟目录的站点,其它功能是oneWeb类似，oneWeb只是固定目录,onewebv 可以访问自定义目录  
                
                 3. OneFile 目录,Exe运行程序下同级目录  OnePlatform\OneFile   
                     http://127.0.0.1:9090/OneFile/my.txt   
                     以文件流形式输出文件  

	2.Mormot2 BUG修正,请自行去修正此单元  
                  单元  mormot.net.http.pas   
                  方法: function THttpRequestContext.ContentFromFile有Bug  
	  Bug原因,文件为空时输出的是false,找不到文件，是不对的。 
                  修正如下: 
                  ContentLength := FileSize(FileName); 
	  //在此句加这个判断即可  
  	  if ContentLength=0 then  
	 begin  
    	    result := true;  
    	    exit;  
 	 end;  


************2023-12-15***********  
服务端:  
	1.增加自增ID数据集保存时,返回正确的获取自增ID后的数据集  

客户端:  
	2.增加自增ID数据集Demo  OneClientDemo   
	其数据集 Data.DataInfo.IsReturnData := true 即可原数据取回  
	当设置 DataInfo.IsReturnData := true 是整个数据集提交，整个返回加载  
	不适用于大数据。。。增大传输压力，个人建议主键还是不要用自增,OneClientDataset提供了方便的获取整型ID的方法  
	请认真看各个DEMO  
	
************2023-12-08***********  
服务端:  
	1.增加10分钟未交互的连接,主动断掉，重连。。。  
                主要有的驱动或数据库配置你保活没用。。。久的连接会未明其妙挂了。倒不如断开重连下，太久没交互的连接  
	主要更改以下方法，增加两个保活机制  
                function TOneZTPool.LockZTItem(var QErrMsg: string): TOneZTItem;    

               if SecondsBetween(Now, lZTItem.FLastTime) >= 600 then  
               begin
                  lZTItem.ADConnection.Close(True);  
                  lZTItem.ADConnection.Open;  
               end;          

                同上面也是为了保证数据库是连接情况下，才使用账套  
                if (not lZTItem.ADConnection.Connected) then  
               begin  
                 //判断状态如果未连接重新连接下  
                 lZTItem.ADConnection.Open;  
                end;     
				 
************2023-09-14***********
服务端:
	1.服务端增加Demo OneUniDemo\UniFileDownController
	   一个是DataSet转Excel提供给前端下载,一个是图片下载,两个区别不大
客户端:
	1.OneUniapp增加文件下载Demo demoExcelDown.vue
	
************2023-08-15***********  
服务端:  
	1.服务端HTTP保持连接功能 FKeepAliveTimeOut设成0,不保持,HTTP短连接，用完即放，主要是为了高并发更健康  
                   constructor TOneHttpServer.Create(QLog: IOneLog);  
	2.FastApi增加批量保存数据的功能，及一些BUG和相关功能的纠正  
	3.其它优化  
客户端:  
	1.FastApiDemo增加相关批量保存数据的功能  
	
************2023-07-04***********  
服务端:  
	1.服务端账套管理，增加扩容,当池用尽，无限扩容，用完自动释放连接  
	2.优化账套一些功能  
客户端:  
	1.OneClient控件TOneConnection增加post请求相关等待事件机制  
	2. 等待机制的实现参考Demo-OneClientDemoHttpWaitHint  
	
************2023-06-24***********
服务端:  
	1.增加服务端报表单元，需要装FR如果没装FR同学，请屏B此单元  
	  OneFastApi目录下 OneFastReportController  
	2.优化文件输出功能和HTML输出功能  

客户端:  
	1.增加控件 TOneServerFastReport设计服务端报表交互控件  
	2. 增加Demo-OneClientDemoFastApi.dproj 报表设计单元  
	
************2023-06-10***********  
服务端:  
	1.增加调用业务层Controrl前置如果出现错误，自定义返回格式，参考Demo  
	DemoWorkCustErrResult->\httpServer\Controller\Demo  
客户端:  
	1.TOneDataSet增加RefreshSingle刷新单条数据功能  
	2.增加Demo-OneClientDemoRefreshSingle  
	
************2023-05-27***********  
服务端:  
	1.修正Token进入临界区的一些处理  
	2.修正FastApi相关功能的缺失及时间字段的输出和参数处理  

客户端:	  
	1.OneFastApi-Demo增加相关时间格式字段输出，记得补脚本  
	
************2023-05-17***********
--祝大家五一快乐,给大家一份大礼包吧  
服务端:  
	1.账套增加 TOneZTManage.ExecScript 执行脚本用的,脚本是咋样就是咋样  
	2.一些优化及修正  
客户端:	  
	1.OneClient控件包增加 TOneDataSet.ExecScript 执行脚本用的    
	2.OneClient增加Demo OneClientDemoScript 脚本执行Demo   
	3.修正 TOneDataSet.ActiveDesign方法,只添加不存在的字段，且是添加在Fields不在是Fielddefs  
	4.增加 TOneDataSet.ActiveDesignOpen在设计时打开数据  
	
************2023-05-10***********  
--祝大家五一快乐,给大家一份大礼包吧  
服务端:  
	1.修正webSocket一些BUG  
客户端:	 
	2.修正webscoket一些BUG  
	
************2023-05-07***********  
--祝大家五一快乐,给大家一份大礼包吧  
服务端:  
	1.增加WebSocket互相发送消息功能，及修正一些乱码问题  
	2.增加WebSocket对外相关controll接口  
客户端:	  
	1.为OneWebSocketClient.TOneWebSocketClient增加功能及修正  
	2.增加Demo OneClientDemoWebSocketChat 发送消息  


************2023-05-01***********  
--祝大家五一快乐,给大家一份大礼包吧  
服务端:  
	1.增加WebSocket服务,单元 OneWebSocketServer  
	2.修正OneZTManage获取驱动目录  
	3.主界面增加WebSocket相关配置  
	3.以及一些优化  
客户端:	
	1.增加Demo OneClientFastApi 需要安装Dev  
	2.增加新的控件 OneWebSocketClient.TOneWebSocketClient   
	3.增加Demo OneClientDemoWebSocket  
	
************2023-04-28***********  
服务端:  
	1.增加OneFastFile 附件功能机制,提供附件上传下载删除等功能  
	2.TOneZTManage.OpenDatas 以文件流下载产生的临时文件，10分钟后自动删除，保证硬盘的健康  
	3.修正Token释放问题,及一些优化  
客户端:  
	1.OneClinet控件包增加目录OneFast记得把lib也要加进去,同时移动几个相关文件及单元名称oneCleintLsh改成oneCleintFastLsh  
	2.OneClient包增加控件TOneFastFile 附件功能  
	3.增加Demo  OneClientDemoFastFile  附件功能展示  
	4.增加Demo OneClientFastApi 需要安装Dev,未完成相关功能下个版本就好了只是初步界面设计  
	5.以及一些功能优化  
	
************2023-04-23***********  
服务端:  
	1.增加OneFastUpdate升级功能机制,提供升级管理功能  
	2.以及一些功能优化  
客户端:
	1.OneClient包增加控件TOneFastUpdate 提供升级功能  
	2.增加Demo  OneClientDemoUpdate 如何自已升级自已  
	3.以及一些功能优化  

************2023-04-17***********
服务端:  
	1.增加流水号配置相关功能,目录OneFastLsh  
	2.优化一些，代码自行比较  
客户端:  
	1.OneClient包增加控件TOneFastLsh,专门获取流水号用的  
	2.增加Demo  OneClientDemoLsh 获取流水号Demo  

************2023-04-13***********  
服务端:  
	1.增加获取数据库结构方法  
	   DataController.GetDBMetaInfo  

客户端:  
	1.OneClient包OneClientDataSet.TOneDataSet.GetDBMetaInfo增加获取数据库结构方法  
	2.增加Demo OneClientDemoMetaInfo.dproj 获取数据库相关结构方法  
	3.增加Demo OneClientDemoSQLToClass.dproj 跟据SQL打开数据,把数据结构转化成D的类\  
	4.修正OneClientUUID获取GetUUID倒序问题  
	
************2023-04-11***********  
服务端:  
	1.增加UUID整开ID功能,同时开放取UUID接口 TokenController  
客户端:  
	1.oneCleint控件包,因为有删除增加属性，控件包clear重新编译,安装  
	你的项目窗体上面有放TOneDataSet重新打开下,提示去掉没用的属性即可,claer工程，重编译  
	去掉TOneDataSet.DataInfo.isPost;属性 
	增加TOneDataSet.ActiveDesign设计时打开数据，获取字段  
	2.OneClient控件包增加取UUID控件 TOneUUID，获取整型ID的  
	3.增加Demo-OneClientDemoUUID  
	4.以及一些功能增加和优化  

客户端:OneFastCleint  
	1.增加各种下拉配置  
	2.脚本大体实现初版  
	
************2023-03-29***********
服务端:  
	1.增加控制台版服务端OneServiceConsole功能  
	2.增加OneFastWeixin基础功能  
	3.IOneTokenItem去除Token管理接口全用类属性，不考虑大家Token不一样，后面在个年字典属性保存不一样的属性  
	4.其它功能和修正  
客户端:  
	OneFastCleint  
	1.增加微信管理界面  
	
 	OneUniapp  
	1.增加小程序和系统用户绑定登陆的功能  
	2.增加兼容小程序，web,app三端  
	

	
************2023-03-24***********
服务端:  
	1.增加FastApi功能DML功能  
	OneZTManage.TOneZTItem.Create  
	2.增加Orcal-Number(1,0)-对应成Delphi boolean  
	3.增加Orcal-Number(5,0)到Number(10,0)-对应成Delphi Integer  
 	 FDConnection.FormatOptions.MapRules.Add(5, 10, 0, 0, dtBCD, dtInt32);	    
   	 FDConnection.FormatOptions.MapRules.Add(1, 1, 0, 0, dtBCD, dtBoolean);  
客户端:  
	OneFastCleint  
	1.增加模板[列表编辑]-frm_LayOut_ListEdit  
	2.增加导航图功能  
	3.增加菜单导航图,列表编辑功能  
	4.增加FastApi DML插入,删除，更新功能  
	5.以及一些优化，及底程修正  
	
************2023-03-22***********  
服务端:  
	1.增加FastApi功能，无需写任何一句代码只需写SQL，即可获取相关账套数据  
	支持SQL查询数据，支持存储过程，格式如下  
	接口单元:OneFastApiController  
	接口地址:http://127.0.0.1:9090/OneServer/FastApi/DoFastApi  
	apiCode:FastApi接口代码  
	apiData:FastApi请求数据,只能是Json对象或数组  
	apiParam:FastApi请求条件参数,只能是Json数组  
	{
    	"apiCode":"TEST",  
    	"apiData":{},
    	"apiParam":{"FBillID":"1AAE0AFFE4E649E7A5EE8E0899AFB81C"}
	}

客户端:  
	1.OneFastClient增加FastApi设置界面  

************2023-03-16***********
服务端:  
	1.增加UrlPath风格的请求,单元示例 DemoUrlPathController  
    		// 请求 url xxxx/DemoUrlPath/OnePathTest/flm123  
    		function OnePathTest(id: string): string;  
    		// 请求 url xxxx/DemoUrlPath/OnePathTest/flm123/18  
    		function OnePathTest2(id: string; age: integer): string;  
	2. OneHttpRouterManage中的类TOneRouterItem改成TOneRouterWorkItem  

客户端:
	1.OneClientConnect post数据增加zlib压缩,以及zlib解压
	
************2023-03-13***********  
服务端:  
	1.主要增加OneFastCleint相关对接单元  
	2.增加TOneTokenManage.TokenTimeOutSec Token失效时间功能处理  
	3.增加 ZTManageController开放获取账套信息  
	4.以及一些优化修正  
客户端:  
	1.OneCleint包控件TOneDataSet增加  
                   跟据SQL检测某个字段是否重复  
	   function CheckRepeat(QSQL: string; QParamValues: array of Variant; QSourceValue: string): boolean;  
	   执行DML语句,update,insert,delete语句，依托于DataSet但不会影响本身DataSet任何东东  
                   function ExecDMLSQL(QSQL: string; QParamValues: array of Variant; QMustOneAffected: boolean = true): boolean;  
                   及一些功能增加  
                2.TOneConnection  
                    //验证失败回调事件,比如回调登陆界面  
                    FTokenFailCallBack  
                    获取账套信息能力  
                    function OneGetZTList(Var QErrMsg: string): TList<TZTInfo>;  
                    function OneGetZTStringList(Var QErrMsg: string): TStringList;  
                     //功能扩展  
                     function GetResultBytes(const QUrl: string): TOneResultBytes;  
                     及一些功能增加和修正  
                 3.OneFastClient  
                     是的，一个快速开发  
有的东东我增加了，我忘了大体功能或什么的。。。不在以上描述，自已对比大体代码  

************2023-02-26***********  
服务端:  
	1.修正 SaveData事务处理多个数据集前面提交后面出错，前面事务未回滚问题。在迁移代码，漏了个not  
客户端:  
	1.OneCleint包控件TOneDataSet增加  
	一次性打开多个数据集  
	   function OpenDatas(QOpenDatas: array of TOneDataSet): boolean;  
	示例  
	  if not qryModule.OpenDatas([qryModule, qryData, qryUI, qryControl, qryButton, qryButtonpop]) then  
	2.OneCleint包控件TOneDataSet增加  
	  function SaveDatas(QOpenDatas: array of TOneDataSet): boolean;  
	示例  
	  qryModule.SaveDatas([qryModule, qryData, qryUI, qryControl, qryButton, qryButtonpop])  

************2020-02-24***********  
服务端:  
	1.优化 OneMultipart 对multipart/form-data解析，以及BUG，此单元值得你拥有, 解析multipart函数,D基本没有  
	2.优化 THTTPCtxt.FRequestInContent: RawByteString; 由string改成RawByteString保持原本接收到的字符串  
	3.UniGoodsController增加  
    '  //文件上传示例
    	function PostGoodsImg(QFormData: TOneMultipartDecode): TActionResult<string>;
 	    //获取文件示例
    	function OneGetGoodsImg(imgid: string): TActionResult<string>;'  
	4.以及一些BUG和优化  
客户端:  
oneuniapp客户端:  
	1.增加商品编辑,文件上传  
	2.优化一些函数  

************2023-02-17***********  
服务端:  
	1.增加OneUniDemo与oneUniapp相关单元对接, 在线地址:http://house.callbaba.cn/#/
	 或安装OneUniApp.apk,在开源群里有  
	2.服务端增加删除虚拟文件的功能  
	
客户端:  
	1.增加Demo->OneClientDemoVirtualFile删除文件的功能  
	
OneUniApp客户端:  
	1.增加制作订单交互流程Demo  
	 在线地址:http://house.callbaba.cn/#/  
	或者下载Apk,去开源群下载  
QQ群：193878346  
	

*************2023-02-09**************  
服务端:  
	1.统一返回值类名称及参数大小写叫法与OneLaz,OneuniApp一至,	如果有需要OneUniapp联系**叫兽(FLM)QQ:378464060**一年399  
	2. OneLaz同步增加线程变量及参数结果释放优先问题  
	3.OneLaz同步支持Uos,depbian系统  
	4.OneLaz修复各种接口  
客户端:  
	1.统一返回值类名称及参数大小写叫法  
	
*************2023-02-06**************  
服务端:  
	1.优化MVC 参数和返回结果参数的释放优先问题  
	2.增加MVC 线程变量的使用,可以在无HTTP上下文参数，直接调用HTTP上下文参数  
	3.增加对接OneUniApp的Demo单元,服务端 UniDemoController  
客户端:  
	1.增加OneUniApp目前只对OneLaz VIP会员免费开放  
             
*************2023-02-01**************  
服务端: 修正文件名称是中文返回错误(oneweb,oneweb)虚拟路径输出静态文件  

*************2023-01-29**************  
服务端： 
	增强web表单上传，后台接收处理  
	参考服务端Demo->DemoWebFileController  
              // 解析 multipart/form-data提交的数据,只需要参数类型是 TOneMultipartDecode就行，                   其它的交给底程处理解析  
              ' function WebPostFormData(QFormData: TOneMultipartDecode): TResult<string>;'

*************2023-01-28**************  
服务端：   
	增强文件分块上传下载  
客户端:  
	增强文件分块上传下载,及批量文件上传功能  
	增强Demo-OneClientDemoUpDownChunt  
 
*************2023-01-03**************  
OneDelphi正式版,正式发布.  
服务端:  
	1.完善Token功能  
	2.服务端主界面增加Token查看管理  
	3.服务端主界面增加win一些启动功能  
	4.其它优化和修正  
客户端:  
	1.OneCelint包增加与服务端交互的验证的机制功能  
	       OneClientConnect.MakeUrl安全机制，有兴趣的去看，在其URL拼接 ?token=xx&time=xxx&sing=xxxx  
	       lSign := self.FToKenID + lTimeStr + self.FPrivateKey  MD5换算来的  
	       ToKenID和PrivateKey由DoConnect连接向服务端申请的安全码和秘钥，秘钥不传输，只能参与签名  


*************2023-01-01**************  
首先在这边祝大家新的一年合家欢乐，新年新气象  
服务端:  
	1.完善ORM功能  
	2.增加Demo-> DemoOrmController  

*************2022-12-29**************  
服务端:  
	1.增加静态站点功能  
	第一种:把文件放在运行目录 OnePlatform\oneWeb 目录下面  
	如下 oneweb特定标识，表明要访问运行目录  OnePlatform\oneWeb 下文件  
	http://127.0.0.1:9090/oneweb/admin/index.html  
                最终访问: D:\devTool\delphi\project\OneDelphi\OneServer\Win64\Debug\OnePlatform\oneWeb\admin\index.html  
	第二种:把文件放在虚拟目录下  
	例: 虚拟路径代码(TEST)---实际物理路径(D:\test)  
	如下 onewebv特定标识,表明要访问虚拟路径文件 /test/ 虚拟路径代码  admin/index.html 路径代码  
                http://127.0.0.1:9090/onewebv/test/admin/index.html  
	最终访问:D:\test\admin\index.html  
	2.增加文件访问Demo  
	 DemoWebFileController  

*************2022-12-28**************  
服务端:  
	1.界面增加路由情况查看,以及路由注册失败原因  
 	2.MVC增加方法能数为 TJsonObject,TJsonArray,TJSonValue参数，有且只能有一个参数系统单元system.json  
	例:DemoJsonController=> function GetJsonParam(QJsonObj: TJsonObject): string;  
	3.新增的ORM在11版本以下不兼容，进行了修正兼容。  
	4.优化 OneHttpRouterManage.TOneRouterItem相关方法及属性  
	5.其它修正及优化  
	
*************2022-12-27**************  
服务端:  
	1.完成orm查询测式 Demo：DemoOrmController  
	
*************2022-12-26**************  
有事外出处理事情  

*************2022-12-25**************  
有事外出处理事情  

*************2022-12-24**************  
在次感谢  
今天收到QQ群友的  蓝色  一万元赞助，算是今年中最幸运的一件事吧。倒霉了一年，希望有个新的开始,  
谢谢支持鼓励  

*************2022-12-23**************  
在次感谢  
今天收到QQ群友的  蓝色  一万元赞助，算是今年中最幸运的一件事吧。倒霉了一年，希望有个新的开始,  
谢谢支持鼓励  

*************2022-12-22**************  
今天收到QQ群友的  蓝色  一万元赞助，算是今年中最幸运的一件事吧。倒霉了一年，希望有个新的开始,  
谢谢支持鼓励  

*************2022-12-21**************  
搭建ORM基类  

*************2022-12-20**************  
搭建ORM基类  

*************2022-12-19**************  
搭建ORM基类  

*************2022-12-18**************  
服务端:  
	1.增加对接OneClient分块上传下载功能  
客户端:  
	1.增加对接服务端分块上传下载的功能  
	2.增加Demo文件分块上传下载  

今天收到QQ群友(790166332)的两箱橙子，挺好吃的,愉快的一天，谢谢对作者的支持和鼓励。  

*************2022-12-17**************  
休息  

*************2022-12-16**************  
服务端:  
	1.增加对接OneClient文件上传下载(小文件), 单元 VirtualFileController  
	 2.修正一些功能  
客户端:  
	1.增加对接服务端小文件上传下载，一次性上传下载  
	2.增加文件上传下载Demo  
	3.修正一些功能  

*************2022-12-15**************  
心累，休息。   

*************2022-12-14**************  
心累，休息。  

*************2022-12-13**************  
服务端:  
	1.加快openData取数据文件下载模式压缩，直接压缩流.  
	2.返回的JSON数据不在采用uncoide编码 \uxxxx 直接UTF8编码  
客户端:  
	1.修正自定义事务控制DemoBUG及异常，纠正DEMO写法  
        2.增加DataSet.OpenAsync,DataSet.SaveAsync  
        3.增加异步Demo	 
        4.增加Api使用Demo  
        5.优化一些功能  
### Delphi三层中间件 Dephi中间件 Delphi开源中间件
### 叫兽的另一款[OneLazarus中间件](https://github.com/xenli/OneLazarus "OneLazarus中间件")
### 群友维护的基于[Cross-Socket OneDelphi中间件](https://gitee.com/cityboat/OnePascal "Cross-Socket OneDelphi中间件")