unit ssl_evppkey;

interface
uses ssl_types,ssl_typepointers,system.SysUtils;
var
 EVP_PKEY_CTX_new: function(pkey: PTEVP_PKEY; e: PTENGINE): PTEVP_PKEY_CTX; cdecl = nil;
 EVP_PKEY_CTX_new_id: function(i:integer; e: PTENGINE): PTEVP_PKEY_CTX; cdecl = nil;
 EVP_PKEY_CTX_free:procedure(ctx:PTEVP_PKEY_CTX);cdecl = nil;
 //
 EVP_PKEY_encrypt_init:function(ctx:PTEVP_PKEY_CTX):integer;cdecl = nil;
 EVP_PKEY_encrypt:function(ctx:PTEVP_PKEY_CTX;_out:PByte;outlen:PCardinal;_in:PByte;inlen:Cardinal):integer;cdecl = nil;
 //
 EVP_PKEY_decrypt_init:function(ctx:PTEVP_PKEY_CTX):integer;cdecl = nil;
 EVP_PKEY_decrypt:function(ctx:PTEVP_PKEY_CTX;_out:PByte;outlen:PCardinal;_in:PByte;inlen:Cardinal):integer;cdecl = nil;

procedure SSL_InitEVP_PKEY;
implementation
uses ssl_lib;
procedure SSL_InitEVP_PKEY;
begin
  if @EVP_PKEY_CTX_new = nil then
  begin
    @EVP_PKEY_CTX_new := LoadFuncCLibCrypto('EVP_PKEY_CTX_new');
    @EVP_PKEY_CTX_new_id := LoadFuncCLibCrypto('EVP_PKEY_CTX_new_id');
    @EVP_PKEY_CTX_free := LoadFuncCLibCrypto('EVP_PKEY_CTX_free');
    @EVP_PKEY_encrypt_init := LoadFuncCLibCrypto('EVP_PKEY_encrypt_init');
    @EVP_PKEY_encrypt := LoadFuncCLibCrypto('EVP_PKEY_encrypt');
    @EVP_PKEY_decrypt_init := LoadFuncCLibCrypto('EVP_PKEY_decrypt_init');
    @EVP_PKEY_decrypt := LoadFuncCLibCrypto('EVP_PKEY_decrypt');
  end;
end;
end.
