program OneService;
{$R *.res}
{$I Neon.inc}


uses
  Vcl.Forms,
  Winapi.Windows,
  system.IOUtils,
  frm_main in 'frm_main.pas' {frmMain},
  OneTokenManage in 'basLib\token\OneTokenManage.pas',
  OneHttpServer in 'httpServer\OneHttpServer.pas',
  OneHttpController in 'httpServer\OneHttpController.pas',
  TokenController in 'httpServer\Controller\TokenController.pas',
  DataController in 'httpServer\Controller\DataController.pas',
  VirtualFileController in 'httpServer\Controller\VirtualFileController.pas',
  OneHttpControllerRtti in 'httpServer\OneHttpControllerRtti.pas',
  OneHttpRouterManage in 'httpServer\OneHttpRouterManage.pas',
  OneHttpCtxtResult in 'httpServer\OneHttpCtxtResult.pas',
  DemoController in 'httpServer\Controller\Demo\DemoController.pas',
  Neon.Core.Attributes in 'NeonSerialization\Neon.Core.Attributes.pas',
  Neon.Core.DynamicTypes in 'NeonSerialization\Neon.Core.DynamicTypes.pas',
  Neon.Core.Nullables in 'NeonSerialization\Neon.Core.Nullables.pas',
  Neon.Core.Persistence.JSON in 'NeonSerialization\Neon.Core.Persistence.JSON.pas',
  Neon.Core.Persistence.JSON.Schema in 'NeonSerialization\Neon.Core.Persistence.JSON.Schema.pas',
  Neon.Core.Persistence in 'NeonSerialization\Neon.Core.Persistence.pas',
  Neon.Core.Serializers.DB in 'NeonSerialization\Neon.Core.Serializers.DB.pas',
  Neon.Core.Serializers.Nullables in 'NeonSerialization\Neon.Core.Serializers.Nullables.pas',
  Neon.Core.Serializers.RTL in 'NeonSerialization\Neon.Core.Serializers.RTL.pas',
  Neon.Core.TypeInfo in 'NeonSerialization\Neon.Core.TypeInfo.pas',
  Neon.Core.Types in 'NeonSerialization\Neon.Core.Types.pas',
  Neon.Core.Utils in 'NeonSerialization\Neon.Core.Utils.pas',
  OneZTManage in 'DBCenter\OneZTManage.pas',
  OneILog in 'basLib\logger\OneILog.pas',
  OneLog in 'basLib\logger\OneLog.pas',
  OneThread in 'basLib\thread\OneThread.pas',
  DemoOneWorkThread in 'httpServer\Controller\Demo\DemoOneWorkThread.pas',
  OneDataInfo in 'DBCenter\OneDataInfo.pas',
  OneSQLCrypto in 'basLib\crypto\OneSQLCrypto.pas',
  OneStreamString in 'basLib\crypto\OneStreamString.pas',
  OneGUID in 'basLib\func\OneGUID.pas',
  OneFileHelper in 'basLib\func\OneFileHelper.pas',
  OneGlobal in 'OneGlobal.pas',
  OneDateTimeHelper in 'basLib\func\OneDateTimeHelper.pas',
  OneNeonHelper in 'NeonSerialization\OneNeonHelper.pas',
  OneWebSocketServer in 'httpServer\OneWebSocketServer.pas',
  OneCrypto in 'basLib\crypto\OneCrypto.pas',
  OneRttiHelper in 'basLib\rtti\OneRttiHelper.pas',
  DemoCustResult in 'httpServer\Controller\Demo\DemoCustResult.pas',
  OneCompilerVersion in 'OneCompilerVersion.pas',
  DemoJsonController in 'httpServer\Controller\Demo\DemoJsonController.pas',
  DemoDataController in 'httpServer\Controller\Demo\DemoDataController.pas',
  DemoZTController in 'httpServer\Controller\Demo\DemoZTController.pas',
  DemoTestController in 'httpServer\Controller\Demo\DemoTestController.pas',
  OneControllerResult in 'httpServer\OneControllerResult.pas',
  OneHttpConst in 'httpServer\OneHttpConst.pas',
  DemoLogController in 'httpServer\Controller\Demo\DemoLogController.pas',
  OneVirtualFile in 'basLib\virtualFile\OneVirtualFile.pas',
  OneOrm in 'DBCenter\OneOrm.pas',
  OneOrmRtti in 'DBCenter\OneOrmRtti.pas',
  DemoOrmController in 'httpServer\Controller\Demo\DemoOrmController.pas',
  OneAttribute in 'basLib\attribute\OneAttribute.pas',
  DemoMyController in 'httpServer\Controller\Demo\DemoMyController.pas',
  DemoWebFileController in 'httpServer\Controller\Demo\DemoWebFileController.pas',
  DemoVersionController in 'httpServer\Controller\Demo\DemoVersionController.pas',
  OneWinReg in 'basLib\winRegister\OneWinReg.pas',
  OneMultipart in 'basLib\multipart\OneMultipart.pas',
  UniLoginController in 'OneUniDemo\UniLoginController.pas',
  OneFastLoginController in 'OneFastCleint\OneFastLoginController.pas',
  OneFastAdminController in 'OneFastCleint\OneFastAdminController.pas',
  UniGoodsController in 'OneUniDemo\UniGoodsController.pas',
  UniBillSendController in 'OneUniDemo\UniBillSendController.pas',
  UniClass in 'OneUniDemo\UniClass.pas',
  UniSendReceivController in 'OneUniDemo\UniSendReceivController.pas',
  OneFastModuleManage in 'OneFastCleint\OneFastModuleManage.pas',
  OneFastModuleController in 'OneFastCleint\OneFastModuleController.pas',
  ZTManageController in 'httpServer\Controller\ZTManageController.pas',
  DemoUrlPathController in 'httpServer\Controller\Demo\DemoUrlPathController.pas',
  OneFastApiManage in 'OneFastApi\OneFastApiManage.pas',
  OneFastApiController in 'OneFastApi\OneFastApiController.pas',
  OneFastApiDo in 'OneFastApi\OneFastApiDo.pas',
  WeiXinManage in 'OneFastWeiXin\WeiXinManage.pas',
  WeixinApi in 'OneFastWeiXin\WeixinApi.pas',
  WeixinAuthController in 'OneFastWeiXin\WeixinAuthController.pas',
  WeixinAdminController in 'OneFastWeiXin\WeixinAdminController.pas',
  WeiXinMinApi in 'OneFastWeiXin\WeiXinMinApi.pas',
  WeixinApiPublic in 'OneFastWeiXin\WeixinApiPublic.pas',
  uDefaultIdGenerator in 'basLib\uuid\uDefaultIdGenerator.pas',
  uYitIdHelper in 'basLib\uuid\uYitIdHelper.pas',
  uIdGeneratorOptions in 'basLib\uuid\Contract\uIdGeneratorOptions.pas',
  uIIdGenerator in 'basLib\uuid\Contract\uIIdGenerator.pas',
  uISnowWorker in 'basLib\uuid\Contract\uISnowWorker.pas',
  uTOverCostActionArg in 'basLib\uuid\Contract\uTOverCostActionArg.pas',
  uSnowWorkerM1 in 'basLib\uuid\Core\uSnowWorkerM1.pas',
  uSnowWorkerM2 in 'basLib\uuid\Core\uSnowWorkerM2.pas',
  uSnowWorkerM3 in 'basLib\uuid\Core\uSnowWorkerM3.pas',
  OneUUID in 'basLib\uuid\OneUUID.pas',
  OneFastLshManage in 'OneFastLsh\OneFastLshManage.pas',
  OneFastLshController in 'OneFastLsh\OneFastLshController.pas',
  OneFastUpdateManage in 'OneFastUpload\OneFastUpdateManage.pas',
  OneFastUpdateController in 'OneFastUpload\OneFastUpdateController.pas',
  OneFastFileMange in 'OneFastFile\OneFastFileMange.pas',
  OneFastFileController in 'OneFastFile\OneFastFileController.pas',
  OneWsChatController in 'httpServer\Controller\OneWsChatController.pas',
  OneWebSocketConst in 'httpServer\OneWebSocketConst.pas',
  OneFastFlowManage in 'OneFastFlow\OneFastFlowManage.pas',
  OneFastFlowController in 'OneFastFlow\OneFastFlowController.pas',
  DemoWorkCustErrResult in 'httpServer\Controller\Demo\DemoWorkCustErrResult.pas',
  OneFastPlatManage in 'OneFastCleint\OneFastPlatManage.pas',
  TestApiController in 'httpServer\Controller\TestApiController.pas',
  OneFastReportController in 'OneFastApi\OneFastReportController.pas',
  Vcl.Themes,
  Vcl.Styles;

var
  lpStartupInfo: TStartupInfo;
  lpProcessInformation: TProcessInformation;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  // debug状态下弹出内存泄漏报告
  if DebugHook <> 0 then
    ReportMemoryLeaksOnShutdown := True;

  // 设置软件系统时间格式
  Application.UpdateFormatSettings := false;
  SetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SSHORTDATE, 'yyyy-MM-dd');
  OneDateTimeHelper.SetSystemDataTimeFormatSettings();
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sky');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
  // 添加重启代码 ，win特有的，如果移值到其它平台请剁掉
  if not Restart_Flag then
    Exit; // 不需要重启
  FillChar(lpStartupInfo, sizeof(lpStartupInfo), 0);
  FillChar(lpProcessInformation, sizeof(lpProcessInformation), 0);
  lpStartupInfo.cb := sizeof(lpStartupInfo);
  if CreateProcess(nil, PChar(Application.ExeName), nil, nil, false, 0, nil, nil, lpStartupInfo, lpProcessInformation) then
  begin
    CloseHandle(lpProcessInformation.hThread);
    CloseHandle(lpProcessInformation.hProcess);
  end;

end.
