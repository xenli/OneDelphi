unit ssl_evp;

interface
uses ssl_types,ssl_typepointers;
var
  EVP_DigestInit_ex: function(ctx: PTEVP_MD_CTX; const _type: PEVP_MD; impl: PENGINE): TC_INT; cdecl = nil;
  EVP_DigestUpdate: function(ctx: PTEVP_MD_CTX;const d: Pointer; cnt: TC_SIZE_T): TC_INT; cdecl = nil;
  EVP_DigestFinal_ex: function(ctx: PTEVP_MD_CTX;md: PByte;size: PCardinal): TC_INT; cdecl = nil;
  //
  EVP_CIPHER_CTX_new: function:PTEVP_CIPHER_CTX; cdecl = nil;
  EVP_CIPHER_CTX_free: procedure(a: PTEVP_CIPHER_CTX); cdecl = nil;
  //
  EVP_EncryptInit_ex: function(ctx: PTEVP_CIPHER_CTX;const cipher: PEVP_CIPHER; impl: PENGINE;
    const key: PByte; const iv: PByte): TC_INT; cdecl = nil;
  EVP_EncryptUpdate: function(ctx: PTEVP_CIPHER_CTX; _out: PByte;outl: PInteger;
    const _in: PByte; inl: TC_INT): TC_INT; cdecl = nil;
  EVP_EncryptFinal_ex: function(ctx: PTEVP_CIPHER_CTX; _out: PByte;outl: PInteger): TC_INT; cdecl = nil;
  //
  EVP_DecryptInit_ex: function(ctx: PTEVP_CIPHER_CTX;const cipher: PEVP_CIPHER; impl: PENGINE;
    const key: PByte; const iv: PByte): TC_INT; cdecl = nil;
  EVP_DecryptUpdate: function(ctx: PTEVP_CIPHER_CTX; _out: PByte;outl: PInteger;
    const _in: PByte; inl: TC_INT): TC_INT; cdecl = nil;
  EVP_DecryptFinal_ex: function(ctx: PTEVP_CIPHER_CTX; _out: PByte;outl: PInteger): TC_INT; cdecl = nil;
  //
  EVP_CIPHER_CTX_set_padding: function(ctx:PTEVP_CIPHER_CTX; pad:TC_INT): TC_INT; cdecl = nil;
  EVP_CIPHER_block_size:function (e:PTEVP_CIPHER): TC_INT; cdecl = nil;
procedure SSL_InitEVP;
implementation
uses ssl_lib;
procedure SSL_InitEVP;
begin
  if @EVP_DigestInit_ex = nil then
  begin
    @EVP_DigestInit_ex := LoadFuncCLibCrypto('EVP_DigestInit_ex');
    @EVP_DigestUpdate := LoadFuncCLibCrypto('EVP_DigestUpdate');
    @EVP_DigestFinal_ex  := LoadFuncCLibCrypto('EVP_DigestFinal_ex');
    @EVP_CIPHER_CTX_new  := LoadFuncCLibCrypto('EVP_CIPHER_CTX_new');
    @EVP_CIPHER_CTX_free  := LoadFuncCLibCrypto('EVP_CIPHER_CTX_free');
    //
    @EVP_EncryptInit_ex  := LoadFuncCLibCrypto('EVP_EncryptInit_ex');
    @EVP_EncryptUpdate  := LoadFuncCLibCrypto('EVP_EncryptUpdate');
    @EVP_EncryptFinal_ex  := LoadFuncCLibCrypto('EVP_EncryptFinal_ex');

    @EVP_DecryptInit_ex  := LoadFuncCLibCrypto('EVP_DecryptInit_ex');
    @EVP_DecryptUpdate  := LoadFuncCLibCrypto('EVP_DecryptUpdate');
    @EVP_DecryptFinal_ex  := LoadFuncCLibCrypto('EVP_DecryptFinal_ex');

    //
    @EVP_CIPHER_CTX_set_padding  := LoadFuncCLibCrypto('EVP_CIPHER_CTX_set_padding');
    @EVP_CIPHER_block_size  := LoadFuncCLibCrypto('EVP_CIPHER_block_size');
  end;
end;
end.
