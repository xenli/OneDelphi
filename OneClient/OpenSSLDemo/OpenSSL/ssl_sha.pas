unit ssl_sha;

interface
uses ssl_types;

var
	SHA_Init: function(_c: PSHA_CTX): TC_INT; cdecl = nil;
	SHA_Update: function(_c: PSHA_CTX; const _data: Pointer; _len: TC_SIZE_T): TC_INT; cdecl = nil;
	SHA_Final: function(md: PAnsiChar; c: PSHA_CTX): TC_INT; cdecl = nil;
	SHA: function(const _d: PAnsiChar; n: TC_SIZE_T; md: PAnsiChar): PAnsiChar; cdecl = nil;
	SHA_Transform: procedure(c: PSHA_CTX; const data: PAnsiChar); cdecl = nil;
	SHA1_Init: function(c: PSHA_CTX): TC_INT; cdecl = nil;
	SHA1_Update: function(c: PSHA_CTX; const data: Pointer; len: TC_SIZE_T): TC_INT; cdecl = nil;
	SHA1_Final: function(md: PAnsiChar; c: PSHA_CTX): TC_INT; cdecl = nil;
	SHA1: function(const d: PAnsiChar; n: TC_SIZE_T; md: PAnsiChar): PAnsiChar; cdecl = nil;
	SHA1_Transform: procedure(c: PSHA_CTX; const data: PAnsiChar); cdecl = nil;
	SHA224_Init: function(c: PSHA256_CTX): TC_INT; cdecl = nil;
	SHA224_Update: function(c: PSHA256_CTX; const data: Pointer; len: TC_SIZE_T): TC_INT; cdecl = nil;
	SHA224_Final: function(md: PAnsiChar; c: PSHA256_CTX): TC_INT; cdecl = nil;
	SHA224: function(const d: PAnsiChar; n: TC_SIZE_T;md: PAnsiChar): PAnsiChar; cdecl = nil;
	SHA256_Init: function(c: PSHA256_CTX): TC_INT; cdecl = nil;
	SHA256_Update: function(c: PSHA256_CTX; const data: Pointer; len: TC_SIZE_T): TC_INT; cdecl = nil;
	SHA256_Final: function(md: PAnsiChar; c: PSHA256_CTX): TC_INT; cdecl = nil;
	SHA256: function(const d: PAnsiChar; n: TC_SIZE_T;md: PAnsiChar): PAnsiChar; cdecl = nil;
	SHA256_Transform: procedure(c: PSHA256_CTX; const data: PAnsiChar); cdecl = nil;
	SHA384_Init: function(c: PSHA512_CTX): TC_INT; cdecl = nil;
	SHA384_Update: function(c: PSHA512_CTX; const data: Pointer; len: TC_SIZE_T): TC_INT; cdecl = nil;
	SHA384_Final: function(md: PAnsiChar; c: PSHA512_CTX): TC_INT; cdecl = nil;
	SHA384: function(const d: PAnsiChar; n: TC_SIZE_T;md: PAnsiChar): PAnsiChar; cdecl = nil;
	SHA512_Init: function(c: PSHA512_CTX): TC_INT; cdecl = nil;
	SHA512_Update: function(c: PSHA512_CTX; const data: Pointer; len: TC_SIZE_T): TC_INT; cdecl = nil;
	SHA512_Final: function(md: PAnsiChar; c: PSHA512_CTX): TC_INT; cdecl = nil;
	SHA512: function(const d: PAnsiChar; n: TC_SIZE_T;md: PAnsiChar): PAnsiChar; cdecl = nil;
	SHA512_Transform: procedure(c: PSHA512_CTX; const data: PAnsiChar); cdecl = nil;


procedure SSL_Initsha;

implementation
uses ssl_lib;

procedure SSL_Initsha;
begin
	if @SHA_Init = nil then
		begin
			@SHA_Init:= LoadFuncCLibCrypto('SHA_Init');
			@SHA_Update:= LoadFuncCLibCrypto('SHA_Update');
			@SHA_Final:= LoadFuncCLibCrypto('SHA_Final');
			@SHA:= LoadFuncCLibCrypto('SHA');
			@SHA_Transform:= LoadFuncCLibCrypto('SHA_Transform');
			@SHA1_Init:= LoadFuncCLibCrypto('SHA1_Init');
			@SHA1_Update:= LoadFuncCLibCrypto('SHA1_Update');
			@SHA1_Final:= LoadFuncCLibCrypto('SHA1_Final');
			@SHA1:= LoadFuncCLibCrypto('SHA1');
			@SHA1_Transform:= LoadFuncCLibCrypto('SHA1_Transform');
			@SHA224_Init:= LoadFuncCLibCrypto('SHA224_Init');
			@SHA224_Update:= LoadFuncCLibCrypto('SHA224_Update');
			@SHA224_Final:= LoadFuncCLibCrypto('SHA224_Final');
			@SHA224:= LoadFuncCLibCrypto('SHA224');
			@SHA256_Init:= LoadFuncCLibCrypto('SHA256_Init');
			@SHA256_Update:= LoadFuncCLibCrypto('SHA256_Update');
			@SHA256_Final:= LoadFuncCLibCrypto('SHA256_Final');
			@SHA256:= LoadFuncCLibCrypto('SHA256');
			@SHA256_Transform:= LoadFuncCLibCrypto('SHA256_Transform');
			@SHA384_Init:= LoadFuncCLibCrypto('SHA384_Init');
			@SHA384_Update:= LoadFuncCLibCrypto('SHA384_Update');
			@SHA384_Final:= LoadFuncCLibCrypto('SHA384_Final');
			@SHA384:= LoadFuncCLibCrypto('SHA384');
			@SHA512_Init:= LoadFuncCLibCrypto('SHA512_Init');
			@SHA512_Update:= LoadFuncCLibCrypto('SHA512_Update');
			@SHA512_Final:= LoadFuncCLibCrypto('SHA512_Final');
			@SHA512:= LoadFuncCLibCrypto('SHA512');
			@SHA512_Transform:= LoadFuncCLibCrypto('SHA512_Transform');
		end;
	
end;

end.

