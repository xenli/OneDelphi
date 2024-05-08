unit ssl_aes;

interface
uses ssl_types;

var
  AES_options: function: PByte; cdecl = nil;
  AES_set_encrypt_key : function(userKey: PByte; bits: TC_INT; key: PAES_KEY): TC_INT; cdecl = nil;
  AES_set_decrypt_key: function(userKey: PByte; bits: TC_INT; key: PAES_KEY): TC_INT; cdecl = nil;
  AES_encrypt: procedure(_in: PByte; _out: PByte; key: PAES_KEY); cdecl = nil;
  AES_decrypt: procedure(_in: PByte; _out: PByte; key: PAES_KEY); cdecl = nil;
  AES_ecb_encrypt: procedure(_in: PByte; _out: PByte; key: PAES_KEY; enc: TC_INT); cdecl = nil;
  AES_cbc_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; ivec: PByte; enc: TC_INT); cdecl = nil;
  AES_cfb128_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; ivec: PByte; num: PC_INT; enc: TC_INT); cdecl = nil;
  AES_cfb1_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; ivec: PByte; num: PC_INT; enc: TC_INT); cdecl = nil;
  AES_cfb8_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; ivec: PByte; num: PC_INT; enc: TC_INT); cdecl = nil;
  AES_ofb128_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; ivec: PByte; num: PC_INT); cdecl = nil;
  AES_ige_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; ivec: PByte; enc: TC_INT); cdecl = nil;
  AES_bi_ige_encrypt: procedure(_in: PByte; _out: PByte; _length: TC_SIZE_T; key: PAES_KEY; key2: PAES_KEY; ivec: PByte; enc: TC_INT); cdecl = nil;
  AES_wrap_key: function(key: PAES_KEY; iv: PByte; _out: PByte; _in: PByte; inlen: TC_UINT): TC_INT; cdecl = nil;
  AES_unwrap_key: function(key: PAES_KEY; iv: PByte; _out: PByte; _in: PByte; inlen: TC_UINT): TC_INT; cdecl = nil;

procedure SSL_InitAES;

implementation
uses ssl_lib;
procedure SSL_InitAES;
begin
 if @AES_options = nil then
  begin
        
      @AES_options:= LoadFunctionCLib('AES_options');
      @AES_set_encrypt_key:= LoadFunctionCLib('AES_set_encrypt_key');
      @AES_set_decrypt_key:= LoadFunctionCLib('AES_set_decrypt_key');
      @AES_encrypt:= LoadFunctionCLib('AES_encrypt');
      @AES_decrypt:= LoadFunctionCLib('AES_decrypt');
      @AES_ecb_encrypt:= LoadFunctionCLib('AES_ecb_encrypt');
      @AES_cbc_encrypt:= LoadFunctionCLib('AES_cbc_encrypt');
      @AES_cfb128_encrypt:= LoadFunctionCLib('AES_cfb128_encrypt');
      @AES_cfb1_encrypt:= LoadFunctionCLib('AES_cfb1_encrypt');
      @AES_cfb8_encrypt:= LoadFunctionCLib('AES_cfb8_encrypt');
      @AES_ofb128_encrypt:= LoadFunctionCLib('AES_ofb128_encrypt');
      @AES_ige_encrypt:= LoadFunctionCLib('AES_ige_encrypt');
      @AES_bi_ige_encrypt:= LoadFunctionCLib('AES_bi_ige_encrypt');
      @AES_wrap_key:= LoadFunctionCLib('AES_wrap_key');
      @AES_unwrap_key:= LoadFunctionCLib('AES_unwrap_key');

  end;
end;

end.
