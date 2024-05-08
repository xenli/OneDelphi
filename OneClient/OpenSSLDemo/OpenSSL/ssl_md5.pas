unit ssl_md5;
//md5相关加解密
interface
uses ssl_types;

var
	MD5_Init: function(_c: PMD5_CTX): TC_INT; cdecl = nil;
	MD5_Update: function(_c: PMD5_CTX; const _data: Pointer; _len: TC_SIZE_T): TC_INT; cdecl = nil;
	MD5_Final: function(_md: PByte; _c: PMD5_CTX): TC_INT; cdecl = nil;
	MD5: function(const _d: PByte; _n: TC_SIZE_T; _md: PByte): PByte; cdecl = nil;
	MD5_Transform: procedure(_c: PMD5_CTX; const _b: PByte); cdecl = nil;

procedure SSL_InitMD5;

implementation
uses ssl_lib;

procedure SSL_InitMD5;
begin
  if @MD5_Init = nil then
  begin
    @MD5_Init := LoadFunctionCLib('MD5_Init');
    @MD5_Update := LoadFunctionCLib('MD5_Update');
    @MD5_Final := LoadFunctionCLib('MD5_Final');
    @MD5 := LoadFunctionCLib('MD5');
    @MD5_Transform := LoadFunctionCLib('MD5_Transform');
  end;
end;

end.
