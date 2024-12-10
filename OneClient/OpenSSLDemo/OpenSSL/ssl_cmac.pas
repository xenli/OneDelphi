unit ssl_cmac;

interface
uses ssl_types;
var
  CMAC_CTX_new: function: PCMAC_CTX; cdecl = nil;
  CMAC_CTX_cleanup: procedure(ctx: PCMAC_CTX); cdecl = nil;
  CMAC_CTX_free: procedure(ctx: PCMAC_CTX); cdecl = nil;
  CMAC_CTX_get0_cipher_ctx: function(ctx: PCMAC_CTX): PEVP_CIPHER_CTX; cdecl = nil;
  CMAC_CTX_copy: function(_out: PCMAC_CTX; _in: CMAC_CTX): TC_INT; cdecl = nil;
  CMAC_Init: function(ctx: PCMAC_CTX; key: Pointer; keylen: TC_SIZE_T; cipher: PEVP_CIPHER; impl: PENGINE): TC_INT; cdecl = nil;
  CMAC_Update: function(ctx: PCMAC_CTX; data: Pointer; dlen: TC_SIZE_T): TC_INT; cdecl = nil;
  CMAC_Final: function(ctx: PCMAC_CTX; _out: PAnsiChar; var poutlen: TC_SIZE_T): TC_INT; cdecl = nil;
  CMAC_resume: function(ctx: PCMAC_CTX): TC_INT; cdecl = nil;

procedure SSL_InitCMAC;

implementation
uses ssl_lib;

procedure SSL_InitCMAC;
begin

 if @CMAC_CTX_new = nil then
 begin
    @CMAC_CTX_new:= LoadFuncCLibCrypto('CMAC_CTX_new');
    @CMAC_CTX_cleanup:= LoadFuncCLibCrypto('CMAC_CTX_cleanup');
    @CMAC_CTX_free:= LoadFuncCLibCrypto('CMAC_CTX_free');
    @CMAC_CTX_get0_cipher_ctx:= LoadFuncCLibCrypto('CMAC_CTX_get0_cipher_ctx');
    @CMAC_CTX_copy:= LoadFuncCLibCrypto('CMAC_CTX_copy');
    @CMAC_Init:= LoadFuncCLibCrypto('CMAC_Init');
    @CMAC_Update:= LoadFuncCLibCrypto('CMAC_Update');
    @CMAC_Final:= LoadFuncCLibCrypto('CMAC_Final');
    @CMAC_resume:= LoadFuncCLibCrypto('CMAC_resume');
 end;
end;
end.
