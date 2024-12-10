unit ssl_encode;
//base64相关加解密
interface
uses ssl_types;
var
  EVP_EncodeInit: procedure(ctx: PEVP_ENCODE_CTX); cdecl = nil;
  EVP_EncodeUpdate: procedure(ctx: PEVP_ENCODE_CTX;_out: PAnsiChar;var outl: TC_INT; const _in: PAnsiChar;var inl: TC_INT); cdecl = nil;
  EVP_EncodeFinal: procedure(ctx: PEVP_ENCODE_CTX;_out: PAnsiChar;var outl: TC_INT); cdecl = nil;
  EVP_EncodeBlock: function(t: PByte; f: PByte; n: TC_INT): TC_INT; cdecl = nil;
  //
  EVP_DecodeInit: procedure(ctx: PEVP_ENCODE_CTX); cdecl = nil;
  EVP_DecodeUpdate: function(ctx: PEVP_ENCODE_CTX;_out: PAnsiChar;var outl: TC_INT; const _in: PAnsiChar; var inl: TC_INT): TC_INT; cdecl = nil;
  EVP_DecodeFinal: function(ctx: PEVP_ENCODE_CTX; _out: PAnsiChar; var outl: TC_INT): TC_INT; cdecl = nil;
  EVP_DecodeBlock: function(t: PByte; f: PByte; n: TC_INT): TC_INT; cdecl = nil;

procedure SSL_InitEncode;
implementation
uses ssl_lib;
procedure SSL_InitEncode;
begin
  if @EVP_EncodeInit = nil then
  begin
    @EVP_EncodeInit := LoadFuncCLibCrypto('EVP_EncodeInit');
    @EVP_EncodeUpdate := LoadFuncCLibCrypto('EVP_EncodeUpdate');
    @EVP_EncodeFinal := LoadFuncCLibCrypto('EVP_EncodeFinal');
    @EVP_EncodeBlock := LoadFuncCLibCrypto('EVP_EncodeBlock');
    @EVP_DecodeInit := LoadFuncCLibCrypto('EVP_DecodeInit');
    @EVP_DecodeUpdate := LoadFuncCLibCrypto('EVP_DecodeUpdate');
    @EVP_DecodeFinal := LoadFuncCLibCrypto('EVP_DecodeFinal');
    @EVP_DecodeBlock := LoadFuncCLibCrypto('EVP_DecodeBlock');
  end;
end;
end.
