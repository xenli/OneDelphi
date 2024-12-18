unit ssl_md4;

interface
uses ssl_types;

var
	MD4_Init: function(_c: PMD4_CTX): TC_INT; cdecl = nil;
	MD4_Update: function(_c: PMD4_CTX; const _data: Pointer; _len: TC_SIZE_T): TC_INT; cdecl = nil;
	MD4_Final: function(_md: PAnsiChar; _c: PMD4_CTX): TC_INT; cdecl = nil;
	MD4: function(const _d: PByte; _n: TC_SIZE_T; _md: PByte): PByte; cdecl = nil;
	MD4_Transform: procedure(_c: PMD4_CTX; const _b: PAnsiChar); cdecl = nil;

procedure SSL_InitMD4;

implementation
uses ssl_lib;

procedure SSL_InitMD4;
begin
	if @MD4_Init = nil then
		begin
			@MD4_Init:= LoadFuncCLibCrypto('MD4_Init');
			@MD4_Update:= LoadFuncCLibCrypto('MD4_Update');
			@MD4_Final:= LoadFuncCLibCrypto('MD4_Final');
			@MD4:= LoadFuncCLibCrypto('MD4');
			@MD4_Transform:= LoadFuncCLibCrypto('MD4_Transform');
		end;
end;

end.
