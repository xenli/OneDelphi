unit ssl_bf;

interface
uses ssl_types;

var
  private_BF_set_key: procedure(key: PBF_KEY; len: TC_INT; data: PAnsiChar); cdecl = nil;
  BF_set_key: procedure(key: PBF_KEY; len: TC_INT; data: PAnsiChar); cdecl = nil;
  BF_encrypt: procedure(data: PBF_LONG; key: PBF_KEY); cdecl = nil;
  BF_decrypt: procedure(data: PBF_LONG; key: PBF_KEY); cdecl = nil;

  BF_ecb_encrypt: procedure(_in: PAnsiChar; _out: PAnsiChar; key: PBF_KEY; enc: TC_INT); cdecl = nil;
  BF_cbc_encrypt: procedure(_in: PAnsiChar; _out: PAnsiChar; _length: TC_LONG; schedule: PBF_KEY; ivec: PAnsiChar; enc: TC_INT); cdecl = nil;
  BF_cfb64_encrypt: procedure(_in: PAnsiChar; _out: PAnsiChar; _length: TC_LONG; schedule: PBF_KEY; ivec: PAnsiChar; num: PC_INT; enc: TC_INT); cdecl = nil;
  BF_ofb64_encrypt: procedure(_in: PAnsiChar; _out: PAnsiChar; _length: TC_LONG; schedule: PBF_KEY; ivec: PAnsiChar; num: PC_INT); cdecl = nil;
  BF_options: function: PAnsiChar; cdecl = nil;

procedure SSL_InitBF;

implementation
uses ssl_lib;

procedure SSL_InitBF;
begin
  if @BF_options = nil then
   begin
        
      @private_BF_set_key:= LoadFuncCLibCrypto('private_BF_set_key', false);
      @BF_set_key:= LoadFuncCLibCrypto('BF_set_key');
      @BF_encrypt:= LoadFuncCLibCrypto('BF_encrypt');
      @BF_decrypt:= LoadFuncCLibCrypto('BF_decrypt');
      @BF_ecb_encrypt:= LoadFuncCLibCrypto('BF_ecb_encrypt');
      @BF_cbc_encrypt:= LoadFuncCLibCrypto('BF_cbc_encrypt');
      @BF_cfb64_encrypt:= LoadFuncCLibCrypto('BF_cfb64_encrypt');
      @BF_ofb64_encrypt:= LoadFuncCLibCrypto('BF_ofb64_encrypt');
      @BF_options:= LoadFuncCLibCrypto('BF_options');

   end;
end;

end.
