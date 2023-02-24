unit OneCompilerVersion;
//没什么 用就是做个记录
interface
uses System.Classes;
const
 OneAllPlatforms= {$IF CompilerVersion >= 33}     //10.3版本
                  pfidOSX or pfidiOS or pfidAndroid or pfidLinux or
                  {$ENDIF}
                  {$IF CompilerVersion = 32}   //10.2版本
                  pidOSX32 or  pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidLinux64 or
                  {$ENDIF}
                  {$IF CompilerVersion = 31}   //10.1版本
                  pidOSX32 or pidiOSSimulator or pidiOSDevice32 or pidiOSDevice64 or pidAndroid or pidLinux64 or
                  {$ENDIF}
                  pidWin32 or pidWin64;
implementation

end.
//VER350	Delphi 11.0 Alexandria / C++Builder 11.0 Alexandria	28	280	35.0
//VER340	Delphi 10.4 Sydney / C++Builder 10.4 Sydney	27	270	34.0
//VER330	Delphi 10.3 Rio / C++Builder 10.3 Rio	26	260	33.0
//VER320	Delphi 10.2 Tokyo / C++Builder 10.2 Tokyo	25	250	32.0
//VER310	Delphi 10.1 Berlin / C++Builder 10.1 Berlin	24	240	31.0
//VER300	Delphi 10 Seattle / C++Builder 10 Seattle	23	230	30.0
//VER290	Delphi XE8 / C++Builder XE8	22	220	29.0
//VER280	Delphi XE7 / C++Builder XE7	21	210	28.0
//VER270	Delphi XE6 / C++Builder XE6	20	200	27.0
//VER260	Delphi XE5 / C++Builder XE5	19	190	26.0
//VER250	Delphi XE4 / C++Builder XE4	18	180	25.0
//VER240	Delphi XE3 / C++Builder XE3	17	170	24.0le
//{$IF CompilerVersion >= 35}
//    TValue.Make<T>(self.ResultData, lTValue);
//{$ELSE}
//    TValue.Make(@self.ResultData, System.TypeInfo(T), lTValue);
//{$ENDIF}
