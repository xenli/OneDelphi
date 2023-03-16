unit OneHttpRouterManage;

interface

uses
  System.StrUtils, System.Generics.Collections, System.Classes, System.SysUtils,
  System.Variants, OneHttpControllerRtti, OneHttpCtxtResult;

// 路由挂载的模式 unknow=未知,pool=线程池,single=单例模式,even=事件
type
  emRouterMode = (unknow, pool, single, even);

type
  TOneRouterUrlPath = class;
  TOneRouterWorkItem = class;
  TOneRouterManage = class;
  // 创建控制层对象回调函数
  TEvenCreaNewController = function(QRouterItem: TOneRouterWorkItem): TObject;

  TOneRouterUrlPath = class
  private
    // URL路径
    FRootName: string;
    // 方法名称
    FMethodName: string;
    // 挂载的路由
    FRouterWorkItem: TOneRouterWorkItem;
  public
    property RootName: string read FRootName;
    property MethodName: string read FMethodName;
    property RouterWorkItem: TOneRouterWorkItem read FRouterWorkItem;
  end;

  TOneRouterWorkItem = class(TObject)
  private
    // 多例模式下,锁
    FLockObj: TObject;
    // 路由挂载的模式
    FRouterMode: emRouterMode;
    // URL路径
    FRootName: string;
    // 最大运行线程个数
    FPoolMaxCount: Integer;
    // 正在运行的线程个数
    FWorkingCount: Integer;
    // 挂载的控制层的类
    FPersistentClass: TPersistentClass;
    // 创建实例的方法注册
    FEvenCreateNew: TEvenCreaNewController;
    // 挂载的控制层的类的RTTI信息
    FControllerRtti: TOneControllerRtti;
    // 单例情况下，预先创建好,加快请求速度
    FSingleWorkObject: TObject;
    // 也有可能是一个方法，后面在扩展
    FEvenControllerProcedure: TEvenControllerProcedure;
  private
    // 池是否满了
    function LockPoolWorkCount(): boolean;
    // 池归还
    procedure UnLockPoolWorkCount();
    function GetClassName(): string;
  public
    constructor Create; overload;
    destructor Destroy; override;
  public
    // 锁定一个控制器出来干活
    function LockWorkItem(Var QErrMsg: string): TObject;
    // 获取一个控制函数来干活
    function LockWorkEven(Var QErrMsg: string): TEvenControllerProcedure;
    // 称释放一个控制器
    procedure UnLockWorkItem(QObject: TObject);
    // 获取一个方法反射信息
    function GetRttiMethod(QMethodName: string): TOneMethodRtti;
  published
    property ControllerRtti: TOneControllerRtti read FControllerRtti;
    property RouterMode: emRouterMode read FRouterMode;
    property RootName: string read FRootName;
    property PoolMaxCount: Integer read FPoolMaxCount;
    property WorkingCount: Integer read FWorkingCount;
    property RootClassName: string read GetClassName;
  end;

  TOneRouterManage = class(TObject)
  private
    // 路由信息控制(路由,路由信息)
    FRouterWorkItems: TDictionary<string, TOneRouterWorkItem>;
    // 路由由注册路径+方法名称
    FRouterUrlPath: TDictionary<string, TOneRouterUrlPath>;
    // 路由代方法名称和参数值
    FRouterUrlPathWithParams: TDictionary<string, TOneRouterUrlPath>;
    FErrMsg: string;
  public
    constructor Create; overload;
    destructor Destroy; override;
  public
    // 跟据路由获取路由名称
    function GetRouterItem(QRootName: string; Var QErrMsg: string): TOneRouterWorkItem;
    function GetRouterItems(): TDictionary<string, TOneRouterWorkItem>;
    // 跟据URL路径获取对应路由信息
    function GetRouterUrlPath(QUrlPath: string; Var QErrMsg: string): TOneRouterUrlPath;
    // 增加池工作模式
    // QRootName URL路径, QClass控制器类型, QPoolCount池大小(<=0不控制), QEvenCreateNew 创建实例的回调函数
    // 如果QEvenCreateNew未传，那么采用  TPersistentClass创建实例
    procedure AddHTTPPoolWork(QRootName: string; QClass: TPersistentClass;
      QPoolCount: Integer; QEvenCreateNew: TEvenCreaNewController);
    // 增加单例模式
    // QRootName URL路径, QClass控制器类型, QWorkMaxCount最大同时调用人数(<=0不控制), QEvenCreateNew 创建实例的回调函数
    // 如果QEvenCreateNew未传，那么采用  TPersistentClass创建实例
    procedure AddHTTPSingleWork(QRootName: string; QClass: TPersistentClass;
      QWorkMaxCount: Integer; QEvenCreateNew: TEvenCreaNewController);
    // 增加事件工作模式
    // QRootName URL路径, QEvenController回调事件, QWorkMaxCount最大同时调用人数(<=0不控制)
    procedure AddHTTPEvenWork(QRootName: string;
      QEvenController: TEvenControllerProcedure; QWorkMaxCount: Integer);
    // 标准化rootName
    function FormatRootName(QRootName: string): string;
  public
    property ErrMsg: string read FErrMsg;
  end;

var
  Init_RouterManage: TOneRouterManage = nil;
function GetInitRouterManage(): TOneRouterManage;

implementation

function GetInitRouterManage(): TOneRouterManage;
begin
  if Init_RouterManage = nil then
  begin
    Init_RouterManage := TOneRouterManage.Create;
  end;
  result := Init_RouterManage;
end;

// 单个路由创建
constructor TOneRouterWorkItem.Create;
begin
  inherited Create;
  self.FLockObj := TObject.Create;
  self.FRouterMode := emRouterMode.unknow;
  self.FPoolMaxCount := -1;
  self.FWorkingCount := 0;
  self.FPersistentClass := nil;
  self.FEvenCreateNew := nil;
  self.FControllerRtti := nil;
  self.FSingleWorkObject := nil;
  self.FEvenControllerProcedure := nil;
end;

// 单个路由销毁
destructor TOneRouterWorkItem.Destroy;
begin
  inherited Destroy;
  if FLockObj <> nil then
  begin
    FLockObj.Free;
  end;
  if FPersistentClass <> nil then
  begin
    FPersistentClass := nil;
  end;
  if FControllerRtti <> nil then
  begin
    FControllerRtti.Free;
    FControllerRtti := nil;
  end;
  if FSingleWorkObject <> nil then
  begin
    FSingleWorkObject.Free;
  end;
  self.FEvenCreateNew := nil;
  self.FEvenControllerProcedure := nil;
end;

// 池模式锁定工作数量
function TOneRouterWorkItem.LockPoolWorkCount(): boolean;
begin
  result := false;
  TMonitor.Enter(self.FLockObj);
  try
    if self.FPoolMaxCount <= 0 then
    begin
      // 不控制池大小
      self.FWorkingCount := self.FWorkingCount + 1;
      result := true;
      exit;
    end;
    if self.FWorkingCount >= self.FPoolMaxCount then
    begin
      result := false;
      exit;
    end;
    self.FWorkingCount := self.FWorkingCount + 1;
    result := true;
  finally
    TMonitor.exit(self.FLockObj);
  end;
end;

// 池模式释放工作数量
procedure TOneRouterWorkItem.UnLockPoolWorkCount();
begin
  TMonitor.Enter(self.FLockObj);
  try
    self.FWorkingCount := self.FWorkingCount - 1;
  finally
    TMonitor.exit(self.FLockObj);
  end;
end;

function TOneRouterWorkItem.GetClassName(): string;
begin
  if self.FPersistentClass <> nil then
  begin
    result := self.FPersistentClass.QualifiedClassName;
  end
  else
  begin
    result := '事件';
  end;
end;

// 锁定一个控制器出来干活
function TOneRouterWorkItem.LockWorkItem(Var QErrMsg: string): TObject;
var
  tempObj: TObject;
begin
  result := nil;
  tempObj := nil;
  QErrMsg := '';
  case self.FRouterMode of
    emRouterMode.unknow:
      begin
        QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式unknow未知';
        exit;
      end;
    emRouterMode.pool:
      begin
        // 池模式
        if not self.LockPoolWorkCount() then
        begin
          QErrMsg := 'URL路径->' + FRootName + ',对应的池已满载工作,请稍候在试!!!';
          exit;
        end;
        if (Assigned(self.FEvenCreateNew)) then
        begin
          // 跟据方法创建对象 ,最好跟据方法创建
          tempObj := self.FEvenCreateNew(self);
        end
        else
        begin
          // 跟据控制类创建对象
          if self.FPersistentClass = nil then
          begin
            QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式控制器类型为nil无法创建实例!!!';
            exit;
          end;
          tempObj := self.FPersistentClass.Create();
        end;
        result := tempObj;
      end;
    emRouterMode.single:
      begin
        if not self.LockPoolWorkCount() then
        begin
          QErrMsg := 'URL路径->' + FRootName + ',对应的工作数量已满载工作,请稍候在试!!!';
          exit;
        end;
        // 单例模式
        if self.FSingleWorkObject = nil then
        begin
          //
          // lItem.FPersistentClass.ClassParent;
          // lItem.FPersistentClass.InheritsFrom(classaa)
          if (Assigned(self.FEvenCreateNew)) then
          begin
            // 跟据方法创建对象 ,最好跟据方法创建
            self.FSingleWorkObject := self.FEvenCreateNew(self);
          end
          else
          begin
            // 跟据控制类创建对象
            if self.FPersistentClass = nil then
            begin
              QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式控制器类型为nil无法创建实例!!!';
              exit;
            end;
            self.FSingleWorkObject := self.FPersistentClass.Create();
          end;
        end;
        result := self.FSingleWorkObject;
        exit;
      end;
    emRouterMode.even:
      begin
        QErrMsg := 'URL路径->' + FRootName + ',请用获取路由方法调用事件';
        exit;
      end;
  else
    begin
      QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式未设计';
      exit;
    end;
  end;
end;

// 获取一个控制函数来干活
function TOneRouterWorkItem.LockWorkEven(Var QErrMsg: string)
  : TEvenControllerProcedure;
begin
  result := nil;
  QErrMsg := '';
  case self.FRouterMode of
    emRouterMode.unknow:
      begin
        QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式unknow未知';
        exit;
      end;
    emRouterMode.pool, emRouterMode.single:
      begin
        // 池模式
        QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式pool只能获得控制器对象';
        exit;
      end;
    emRouterMode.even:
      begin
        if not self.LockPoolWorkCount() then
        begin
          QErrMsg := 'URL路径->' + FRootName + ',对应的工作数量已满载工作,请稍候在试!!!';
          exit;
        end;
        result := self.FEvenControllerProcedure;
        exit;
      end;
  else
    begin
      QErrMsg := 'URL路径->' + FRootName + ',对应的路由模式未设计';
      exit;
    end;
  end;
end;

// 称释放一个控制器
procedure TOneRouterWorkItem.UnLockWorkItem(QObject: TObject);
begin
  // 路由模式判断
  case self.FRouterMode of
    emRouterMode.unknow:
      begin
        exit;
      end;
    emRouterMode.pool:
      begin
        // 池模式要进行类释放
        self.UnLockPoolWorkCount();
        // 释放
        QObject.Free;
        QObject := nil;
      end;
    emRouterMode.single:
      begin
        // 单例模式
        self.UnLockPoolWorkCount();
        exit;
      end;
    emRouterMode.even:
      begin
        self.UnLockPoolWorkCount();
        exit;
      end;
  else
    begin
      self.UnLockPoolWorkCount();
      exit;
    end;
  end;
end;

function TOneRouterWorkItem.GetRttiMethod(QMethodName: string): TOneMethodRtti;
begin
  result := nil;
  if self.FControllerRtti = nil then
  begin
    result := nil;
    exit;
  end;
  result := self.FControllerRtti.GetRttiMethod(QMethodName);
end;

// ***********************路由管理************************//
// 路由管理创建
constructor TOneRouterManage.Create;
begin
  inherited Create;
  FRouterUrlPath := TDictionary<string, TOneRouterUrlPath>.Create;
  FRouterUrlPathWithParams := TDictionary<string, TOneRouterUrlPath>.Create;
  FRouterWorkItems := TDictionary<string, TOneRouterWorkItem>.Create;
  FErrMsg := '';
end;

// 路由管理销毁
destructor TOneRouterManage.Destroy;
var
  lItemPath: TOneRouterUrlPath;
  lItem: TOneRouterWorkItem;
begin
  //
  for lItemPath in FRouterUrlPath.Values do
  begin
    lItemPath.FRouterWorkItem := nil;
    lItemPath.Free;
  end;
  FRouterUrlPath.Clear;
  FRouterUrlPath.Free;
  //
  for lItem in FRouterWorkItems.Values do
  begin
    lItem.Free;
  end;
  FRouterWorkItems.Clear;
  FRouterWorkItems.Free;

  for lItemPath in FRouterUrlPathWithParams.Values do
  begin
    lItemPath.FRouterWorkItem := nil;
    lItemPath.Free;
  end;
  FRouterUrlPathWithParams.Clear;
  FRouterUrlPathWithParams.Free;
  inherited Destroy;
end;

// 跟据路由获取路由名称
function TOneRouterManage.GetRouterItem(QRootName: string; Var QErrMsg: string): TOneRouterWorkItem;
var
  lItem: TOneRouterWorkItem;
begin
  result := nil;
  QErrMsg := '';
  if FRouterWorkItems.TryGetValue(QRootName, lItem) then
  begin
    if (lItem = nil) then
    begin
      QErrMsg := 'URL路径->' + QRootName + ',对应的路由信息为nil';
      exit;
    end;
    result := lItem;
  end
  else
  begin
    QErrMsg := '无效的URL路径->' + QRootName;
  end;
end;

function TOneRouterManage.GetRouterItems(): TDictionary<string, TOneRouterWorkItem>;
begin
  result := self.FRouterWorkItems;
end;

function TOneRouterManage.GetRouterUrlPath(QUrlPath: string; Var QErrMsg: string): TOneRouterUrlPath;
var
  lItem: TOneRouterUrlPath;
  tempUrl: string;
  i: Integer;
begin
  result := nil;
  QErrMsg := '';
  if FRouterUrlPath.TryGetValue(QUrlPath, lItem) then
  begin
    if (lItem = nil) then
    begin
      QErrMsg := 'URL路径->' + QUrlPath + ',对应的路由信息为nil';
      exit;
    end;
    result := lItem;
  end
  else
  begin
    // OnePath匹配,参数也在Url上
    for tempUrl in self.FRouterUrlPathWithParams.Keys do
    begin
      if QUrlPath.StartsWith(tempUrl + '/') then
      begin
        FRouterUrlPathWithParams.TryGetValue(tempUrl, lItem);
        result := lItem;
        break;
      end;
    end;
  end;
  if result = nil then
    QErrMsg := '无效的URL路径->' + QUrlPath;
end;

function TOneRouterManage.FormatRootName(QRootName: string): string;
begin
  result := OneHttpCtxtResult.FormatRootName(QRootName);
end;

// 增加池工作模式
// QRootName URL路径, QClass控制器类型, QPoolCount池大小(<=0不控制), QEvenCreateNew 创建实例的回调函数
// 如果QEvenCreateNew未传，那么采用  TPersistentClass创建实例
procedure TOneRouterManage.AddHTTPPoolWork(QRootName: string;
  QClass: TPersistentClass; QPoolCount: Integer;
  QEvenCreateNew: TEvenCreaNewController);
var
  lItem: TOneRouterWorkItem;
  lRootName: string;
  lObj: TObject;
  lMethodName: string;
  lPathMethod: string;
  lRouterUrlPath: TOneRouterUrlPath;
  lOneMethodRtti: TOneMethodRtti;
begin
  lRootName := self.FormatRootName(QRootName);
  if lRootName = '' then
    exit;
  if not FRouterWorkItems.TryGetValue(lRootName, lItem) then
  begin
    // 创建路由信息
    lItem := TOneRouterWorkItem.Create;
    FRouterWorkItems.Add(lRootName, lItem);
    lItem.FRootName := lRootName;
    lItem.FPoolMaxCount := QPoolCount;
    lItem.FEvenCreateNew := QEvenCreateNew;
    lItem.FPersistentClass := QClass;
    lItem.FRouterMode := emRouterMode.pool;
    if QClass <> nil then
    begin
      // 挂载RTTI信息
      lItem.FControllerRtti := TOneControllerRtti.Create(QClass);
      for lOneMethodRtti in lItem.FControllerRtti.MethodList.Values do
      begin
        lMethodName := lOneMethodRtti.MethodName;
        lPathMethod := lRootName + '/' + lMethodName;
        lOneMethodRtti.UrlMethod := lPathMethod;
        if lOneMethodRtti.HttpMethodType = emOneHttpMethodMode.OnePath then
        begin
          if not self.FRouterUrlPathWithParams.ContainsKey(lPathMethod) then
          begin
            lRouterUrlPath := TOneRouterUrlPath.Create;
            lRouterUrlPath.FRootName := lRootName;
            lRouterUrlPath.FMethodName := lMethodName;
            lRouterUrlPath.FRouterWorkItem := lItem;
            self.FRouterUrlPathWithParams.Add(lPathMethod, lRouterUrlPath);
          end;
        end
        else
        begin
          if not self.FRouterUrlPath.ContainsKey(lPathMethod) then
          begin
            lRouterUrlPath := TOneRouterUrlPath.Create;
            lRouterUrlPath.FRootName := lRootName;
            lRouterUrlPath.FMethodName := lMethodName;
            lRouterUrlPath.FRouterWorkItem := lItem;
            self.FRouterUrlPath.Add(lPathMethod, lRouterUrlPath);
          end;
        end;
      end;
    end;
  end
  else
  begin
    FErrMsg := FErrMsg + '路径[' + lRootName + ']已存在,请检查是否重复,当前注册类[' + QClass.QualifiedClassName + '],'
      + '已注册类[' + lItem.FPersistentClass.QualifiedClassName + ']' + #13#10;
  end;
end;

// 增加单例模式
// QRootName URL路径, QClass控制器类型, QWorkMaxCount最大同时调用人数(<=0不控制), QEvenCreateNew 创建实例的回调函数
// 如果QEvenCreateNew未传，那么采用  TPersistentClass创建实例
procedure TOneRouterManage.AddHTTPSingleWork(QRootName: string;
  QClass: TPersistentClass; QWorkMaxCount: Integer;
  QEvenCreateNew: TEvenCreaNewController);
var
  lItem: TOneRouterWorkItem;
  lRootName: string;
  lObj: TObject;
  lMethodName: string;
  lPathMethod: string;
  lRouterUrlPath: TOneRouterUrlPath;
  lOneMethodRtti: TOneMethodRtti;
begin
  lRootName := self.FormatRootName(QRootName);
  if lRootName = '' then
    exit;
  if not FRouterWorkItems.TryGetValue(lRootName, lItem) then
  begin
    // 创建路由信息
    lItem := TOneRouterWorkItem.Create;
    FRouterWorkItems.Add(lRootName, lItem);
    lItem.FRootName := lRootName;
    lItem.FPoolMaxCount := QWorkMaxCount;
    lItem.FEvenCreateNew := QEvenCreateNew;
    lItem.FPersistentClass := QClass;
    lItem.FRouterMode := emRouterMode.single;
    if QClass <> nil then
    begin
      // 挂载RTTI信息
      lItem.FControllerRtti := TOneControllerRtti.Create(QClass);
      for lOneMethodRtti in lItem.FControllerRtti.MethodList.Values do
      begin
        lMethodName := lOneMethodRtti.MethodName;
        lPathMethod := lRootName + '/' + lMethodName;
        lOneMethodRtti.UrlMethod := lPathMethod;
        if lOneMethodRtti.HttpMethodType = emOneHttpMethodMode.OnePath then
        begin
          if not self.FRouterUrlPathWithParams.ContainsKey(lPathMethod) then
          begin
            lRouterUrlPath := TOneRouterUrlPath.Create;
            lRouterUrlPath.FRootName := lRootName;
            lRouterUrlPath.FMethodName := lMethodName;
            lRouterUrlPath.FRouterWorkItem := lItem;
            self.FRouterUrlPathWithParams.Add(lPathMethod, lRouterUrlPath);
          end;
        end
        else
        begin
          if not self.FRouterUrlPath.ContainsKey(lPathMethod) then
          begin
            lRouterUrlPath := TOneRouterUrlPath.Create;
            lRouterUrlPath.FRootName := lRootName;
            lRouterUrlPath.FMethodName := lMethodName;
            lRouterUrlPath.FRouterWorkItem := lItem;
            self.FRouterUrlPath.Add(lPathMethod, lRouterUrlPath);
          end;
        end;
      end;
    end;
  end
  else
  begin
    FErrMsg := FErrMsg + '路径[' + lRootName + ']已存在,请检查是否重复,当前注册类[' + QClass.QualifiedClassName + ']'
      + '已注册类[' + lItem.FPersistentClass.QualifiedClassName + ']' + #13#10;
  end;
end;

// 增加事件工作模式
// QRootName URL路径, QEvenController回调事件, QWorkMaxCount最大同时调用人数(<=0不控制)
procedure TOneRouterManage.AddHTTPEvenWork(QRootName: string;
  QEvenController: TEvenControllerProcedure; QWorkMaxCount: Integer);
var
  lItem: TOneRouterWorkItem;
  lRootName: string;
  lObj: TObject;

  lPathMethod: string;
  lRouterUrlPath: TOneRouterUrlPath;
begin
  lRootName := self.FormatRootName(QRootName);
  if lRootName = '' then
    exit;
  if not FRouterWorkItems.TryGetValue(lRootName, lItem) then
  begin
    // 创建路由信息
    lItem := TOneRouterWorkItem.Create;
    FRouterWorkItems.Add(lRootName, lItem);
    lItem.FRootName := lRootName;
    lItem.FPoolMaxCount := QWorkMaxCount;
    lItem.FEvenCreateNew := nil;
    lItem.FPersistentClass := nil;
    lItem.FRouterMode := emRouterMode.even;
    lItem.FEvenControllerProcedure := QEvenController;

    lRouterUrlPath := TOneRouterUrlPath.Create;
    lRouterUrlPath.FRootName := lRootName;
    lRouterUrlPath.FMethodName := '';
    lRouterUrlPath.FRouterWorkItem := lItem;
    self.FRouterUrlPath.Add(lRootName, lRouterUrlPath);
  end
  else
  begin
    FErrMsg := FErrMsg + '路径[' + lRootName + ']已存在,请检查是否重复,当前注册事件' + #13#10;
  end;
end;

initialization

finalization

if Init_RouterManage <> nil then
begin
  Init_RouterManage.Free;
  Init_RouterManage := nil;
end;

end.
