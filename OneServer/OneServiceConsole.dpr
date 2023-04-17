program OneServiceConsole;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  OneAttribute in 'basLib\attribute\OneAttribute.pas',
  OneGlobal in 'OneGlobal.pas',
  OneControllerResult in 'httpServer\OneControllerResult.pas',
  OneHttpConst in 'httpServer\OneHttpConst.pas',
  OneHttpController in 'httpServer\OneHttpController.pas',
  OneHttpControllerRtti in 'httpServer\OneHttpControllerRtti.pas',
  OneHttpCtxtResult in 'httpServer\OneHttpCtxtResult.pas',
  OneHttpRouterManage in 'httpServer\OneHttpRouterManage.pas',
  OneHttpServer in 'httpServer\OneHttpServer.pas',
  OneWebSocketServer in 'httpServer\OneWebSocketServer.pas',
  DataController in 'httpServer\Controller\DataController.pas',
  TokenController in 'httpServer\Controller\TokenController.pas',
  VirtualFileController in 'httpServer\Controller\VirtualFileController.pas',
  ZTManageController in 'httpServer\Controller\ZTManageController.pas',
  DemoController in 'httpServer\Controller\Demo\DemoController.pas',
  DemoCustResult in 'httpServer\Controller\Demo\DemoCustResult.pas',
  DemoDataController in 'httpServer\Controller\Demo\DemoDataController.pas',
  DemoJsonController in 'httpServer\Controller\Demo\DemoJsonController.pas',
  DemoLogController in 'httpServer\Controller\Demo\DemoLogController.pas',
  DemoMyController in 'httpServer\Controller\Demo\DemoMyController.pas',
  DemoOneWorkThread in 'httpServer\Controller\Demo\DemoOneWorkThread.pas',
  DemoOrmController in 'httpServer\Controller\Demo\DemoOrmController.pas',
  DemoTestController in 'httpServer\Controller\Demo\DemoTestController.pas',
  DemoUrlPathController in 'httpServer\Controller\Demo\DemoUrlPathController.pas',
  DemoVersionController in 'httpServer\Controller\Demo\DemoVersionController.pas',
  DemoWebFileController in 'httpServer\Controller\Demo\DemoWebFileController.pas',
  DemoZTController in 'httpServer\Controller\Demo\DemoZTController.pas',
  OneCrypto in 'basLib\crypto\OneCrypto.pas',
  OneSQLCrypto in 'basLib\crypto\OneSQLCrypto.pas',
  OneStreamString in 'basLib\crypto\OneStreamString.pas',
  OneDateTimeHelper in 'basLib\func\OneDateTimeHelper.pas',
  OneFileHelper in 'basLib\func\OneFileHelper.pas',
  OneFunc in 'basLib\func\OneFunc.pas',
  OneGUID in 'basLib\func\OneGUID.pas',
  OneILog in 'basLib\logger\OneILog.pas',
  OneLog in 'basLib\logger\OneLog.pas',
  OneMultipart in 'basLib\multipart\OneMultipart.pas',
  OneRttiHelper in 'basLib\rtti\OneRttiHelper.pas',
  OneThread in 'basLib\thread\OneThread.pas',
  OneTokenManage in 'basLib\token\OneTokenManage.pas',
  OneVirtualFile in 'basLib\virtualFile\OneVirtualFile.pas',
  OneDataInfo in 'DBCenter\OneDataInfo.pas',
  OneOrm in 'DBCenter\OneOrm.pas',
  OneOrmRtti in 'DBCenter\OneOrmRtti.pas',
  OneZTManage in 'DBCenter\OneZTManage.pas',
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
  OneNeonHelper in 'NeonSerialization\OneNeonHelper.pas',
  OneFastApiController in 'OneFastApi\OneFastApiController.pas',
  OneFastApiDo in 'OneFastApi\OneFastApiDo.pas',
  OneFastApiManage in 'OneFastApi\OneFastApiManage.pas',
  OneFastAdminController in 'OneFastCleint\OneFastAdminController.pas',
  OneFastLoginController in 'OneFastCleint\OneFastLoginController.pas',
  OneFastModuleController in 'OneFastCleint\OneFastModuleController.pas',
  OneFastModuleManage in 'OneFastCleint\OneFastModuleManage.pas',
  UniBillSendController in 'OneUniDemo\UniBillSendController.pas',
  UniClass in 'OneUniDemo\UniClass.pas',
  UniGoodsController in 'OneUniDemo\UniGoodsController.pas',
  UniLoginController in 'OneUniDemo\UniLoginController.pas',
  UniSendReceivController in 'OneUniDemo\UniSendReceivController.pas',
  OneUUID in 'basLib\uuid\OneUUID.pas',
  uDefaultIdGenerator in 'basLib\uuid\uDefaultIdGenerator.pas',
  uYitIdHelper in 'basLib\uuid\uYitIdHelper.pas',
  uIdGeneratorOptions in 'basLib\uuid\Contract\uIdGeneratorOptions.pas',
  uIIdGenerator in 'basLib\uuid\Contract\uIIdGenerator.pas',
  uISnowWorker in 'basLib\uuid\Contract\uISnowWorker.pas',
  uTOverCostActionArg in 'basLib\uuid\Contract\uTOverCostActionArg.pas',
  uSnowWorkerM1 in 'basLib\uuid\Core\uSnowWorkerM1.pas',
  uSnowWorkerM2 in 'basLib\uuid\Core\uSnowWorkerM2.pas',
  uSnowWorkerM3 in 'basLib\uuid\Core\uSnowWorkerM3.pas',
  WeixinAdminController in 'OneFastWeiXin\WeixinAdminController.pas',
  WeixinApi in 'OneFastWeiXin\WeixinApi.pas',
  WeixinApiPublic in 'OneFastWeiXin\WeixinApiPublic.pas',
  WeixinAuthController in 'OneFastWeiXin\WeixinAuthController.pas',
  WeiXinManage in 'OneFastWeiXin\WeiXinManage.pas',
  WeiXinMinApi in 'OneFastWeiXin\WeiXinMinApi.pas';

var
  lCmd, lErrmsg: string;
  isTerminated: boolean;
  lOneGlobal: TOneGlobal;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Repeat
      writeln('***********命令提示***********');
      writeln('输入命令[exit]退出');
      writeln('输入命令[start]启动服务');
      writeln('***********命令结束***********');
      readln(lCmd);
      Try

        if lCmd = 'exit' then
        begin
          isTerminated := true;
          exit;
        end;
        if lCmd = 'start' then
        begin
          lOneGlobal := TOneGlobal.GetInstance(true);
          if not lOneGlobal.StarWork(lErrmsg) then
          begin
            writeln('***********启动服务异常***********');
            writeln(lErrmsg);
          end;
        end;
      except
      end;
    Until isTerminated;

  except
    on E: Exception do
      writeln(E.ClassName, ': ', E.Message);
  end;

end.
