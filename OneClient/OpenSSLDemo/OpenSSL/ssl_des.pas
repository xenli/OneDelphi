unit ssl_des;

interface
uses ssl_types;

var

  DES_options: function: PAnsiChar; cdecl = nil;

  DES_ecb3_encrypt: procedure(input: Pconst_DES_cblock; output: PDES_cblock; ks1: PDES_key_schedule;ks2: PDES_key_schedule; ks3: PDES_key_schedule; enc: TC_INT); cdecl = nil;
  DES_cbc_cksum: function(input: PAnsiChar;output: PDES_cblock; _length: TC_LONG;schedule: PDES_key_schedule; ivec: Pconst_DES_cblock): DES_LONG; cdecl = nil;

  DES_cbc_encrypt: procedure(input: PAnsiChar;output: PAnsiChar; _length: TC_LONG;schedule: PDES_key_schedule;ivec: PDES_cblock; enc: TC_INT); cdecl = nil;
  DES_ncbc_encrypt: procedure(input: PAnsiChar;output: PAnsiChar; _length: TC_LONG;schedule: PDES_key_schedule;ivec: PDES_cblock; enc: TC_INT); cdecl = nil;
  DES_xcbc_encrypt: procedure(input: PAnsiChar;output: PAnsiChar; _length: TC_LONG;schedule: PDES_key_schedule;ivec: PDES_cblock; inw: Pconst_DES_cblock;outw: Pconst_DES_cblock;enc: TC_INT); cdecl = nil;
  DES_cfb_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar;numbits: TC_INT; _length: TC_LONG;schedule: PDES_key_schedule;ivec: PDES_cblock; enc: TC_INT); cdecl = nil;
  DES_ecb_encrypt: procedure(input: Pconst_DES_cblock;output: PDES_cblock; ks: PDES_key_schedule;enc: TC_INT); cdecl = nil;


  DES_encrypt2: procedure(data: PDES_LONG;ks: PDES_key_schedule; enc: TC_INT); cdecl = nil;
  DES_encrypt3: procedure(data: PDES_LONG; ks1: PDES_key_schedule; ks2: PDES_key_schedule; ks3: PDES_key_schedule); cdecl = nil;
  DES_decrypt3: procedure(data: PDES_LONG; ks1: PDES_key_schedule; ks2: PDES_key_schedule; ks3: PDES_key_schedule); cdecl = nil;
  DES_ede3_cbc_encrypt: procedure(input: PAnsiChar;output: PAnsiChar; _length: TC_LONG; ks1: PDES_key_schedule;ks2: PDES_key_schedule;	ks3: PDES_key_schedule;ivec: PDES_cblock;enc: TC_INT); cdecl = nil;
  DES_ede3_cbcm_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar;  _length: TC_LONG;  ks1: PDES_key_schedule;ks2: PDES_key_schedule; ks3: PDES_key_schedule; ivec1: PDES_cblock; ivec2: PDES_cblock; enc: TC_INT); cdecl = nil;
  DES_ede3_cfb64_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar; _length: TC_LONG;ks1: PDES_key_schedule; ks2: PDES_key_schedule;ks3: PDES_key_schedule; ivec: PDES_cblock;var num: TC_INT;enc: TC_INT); cdecl = nil;
  DES_ede3_cfb_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar; numbits: TC_INT;_length: TC_LONG;ks1: PDES_key_schedule; ks2: PDES_key_schedule;ks3: PDES_key_schedule; ivec: PDES_cblock;enc: TC_INT); cdecl = nil;
  DES_ede3_ofb64_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar;  _length: TC_LONG;ks1: PDES_key_schedule;  ks2: PDES_key_schedule;ks3: PDES_key_schedule; ivec: PDES_cblock;var num: TC_INT); cdecl = nil;

  DES_xwhite_in2out: procedure(DES_key : Pconst_DES_cblock;in_white: Pconst_DES_cblock; out_white: PDES_cblock); cdecl = nil;

  DES_enc_read: function(fd: TC_INT;buf: Pointer;len: TC_INT;sched: PDES_key_schedule; iv: PDES_cblock): TC_INT; cdecl = nil;
  DES_enc_write: function(fd: TC_INT;const buf: Pointer;len: TC_INT;sched: PDES_key_schedule; iv: PDES_cblock): TC_INT; cdecl = nil;
  DES_fcrypt: function(buf: PAnsiChar;salt: PAnsiChar; ret: PAnsiChar): PAnsiChar; cdecl = nil;
  DES_crypt: function(buf: PAnsiChar;salt: PAnsiChar): PAnsiChar; cdecl = nil;
  DES_ofb_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar;numbits: TC_INT;  _length: TC_LONG;schedule: PDES_key_schedule;ivec: PDES_cblock); cdecl = nil;
  DES_pcbc_encrypt: procedure(input: PAnsiChar;output: PAnsiChar; _length: TC_LONG;schedule: PDES_key_schedule;ivec: PDES_cblock; enc: TC_INT); cdecl = nil;

  DES_quad_cksum: function(input: PAnsiChar; output: DES_cblock_array; _length: TC_LONG;out_count: TC_INT;seed: PDES_cblock): DES_LONG; cdecl = nil;

  DES_random_key: function(ret: PDES_cblock): TC_INT; cdecl = nil;
  DES_set_odd_parity: procedure(key: PDES_cblock); cdecl = nil;
  DES_check_key_parity: function(const_key: PDES_cblock): TC_INT; cdecl = nil;
  DES_is_weak_key: function(const_key: PDES_cblock): TC_INT; cdecl = nil;

  DES_set_key: function(const_key: PDES_cblock;schedule: PDES_key_schedule): TC_INT; cdecl = nil;
  DES_key_sched: function(const_key: PDES_cblock;schedule: PDES_key_schedule): TC_INT; cdecl = nil;
  DES_set_key_checked: function(const_key: PDES_cblock;schedule: PDES_key_schedule): TC_INT; cdecl = nil;
  DES_set_key_unchecked: procedure(const_key: PDES_cblock;schedule: PDES_key_schedule); cdecl = nil;

  private_DES_set_key_unchecked: procedure(const_key: PDES_cblock;schedule: PDES_key_schedule); cdecl = nil;

  DES_string_to_key: procedure(str: PAnsiChar;var key: DES_cblock); cdecl = nil;
  DES_string_to_2keys: procedure(str: PAnsiChar;var key1: DES_cblock; var key2: DES_cblock); cdecl = nil;
  DES_cfb64_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar;_length: TC_LONG;  schedule: PDES_key_schedule;ivec: PDES_cblock;var num: TC_INT; enc: TC_INT); cdecl = nil;
  DES_ofb64_encrypt: procedure(_in: PAnsiChar;_out: PAnsiChar;_length: TC_LONG; schedule: PDES_key_schedule;ivec: PDES_cblock;var num: TC_INT); cdecl = nil;

  DES_read_password: function(key: PDES_cblock; prompt: PAnsiChar; verify: TC_INT): TC_INT; cdecl = nil;
  DES_read_2passwords: function(key1: PDES_cblock; key2: PDES_cblock; prompt: PAnsiChar; verify: TC_INT): TC_INT; cdecl = nil;


procedure SSL_InitDES;

implementation
uses ssl_lib;

procedure SSL_InitDES;
begin
  if @DES_options = nil then
   begin
     @DES_options:= LoadFuncCLibCrypto('DES_options');
     @DES_ecb3_encrypt:= LoadFuncCLibCrypto('DES_ecb3_encrypt');
     @DES_cbc_cksum:= LoadFuncCLibCrypto('DES_cbc_cksum');
     @DES_cbc_encrypt:= LoadFuncCLibCrypto('DES_cbc_encrypt');
     @DES_ncbc_encrypt:= LoadFuncCLibCrypto('DES_ncbc_encrypt');
     @DES_xcbc_encrypt:= LoadFuncCLibCrypto('DES_xcbc_encrypt');
     @DES_cfb_encrypt:= LoadFuncCLibCrypto('DES_cfb_encrypt');
     @DES_ecb_encrypt:= LoadFuncCLibCrypto('DES_ecb_encrypt');
     @DES_encrypt2:= LoadFuncCLibCrypto('DES_encrypt2');
     @DES_encrypt3:= LoadFuncCLibCrypto('DES_encrypt3');
     @DES_decrypt3:= LoadFuncCLibCrypto('DES_decrypt3');
     @DES_ede3_cbc_encrypt:= LoadFuncCLibCrypto('DES_ede3_cbc_encrypt');
     @DES_ede3_cbcm_encrypt:= LoadFuncCLibCrypto('DES_ede3_cbcm_encrypt');
     @DES_ede3_cfb64_encrypt:= LoadFuncCLibCrypto('DES_ede3_cfb64_encrypt');
     @DES_ede3_cfb_encrypt:= LoadFuncCLibCrypto('DES_ede3_cfb_encrypt');
     @DES_ede3_ofb64_encrypt:= LoadFuncCLibCrypto('DES_ede3_ofb64_encrypt');
     @DES_xwhite_in2out:= LoadFuncCLibCrypto('DES_xwhite_in2out', false);
     @DES_enc_read:= LoadFuncCLibCrypto('DES_enc_read');
     @DES_enc_write:= LoadFuncCLibCrypto('DES_enc_write');
     @DES_fcrypt:= LoadFuncCLibCrypto('DES_fcrypt');
     @DES_crypt:= LoadFuncCLibCrypto('DES_crypt');
     @DES_ofb_encrypt:= LoadFuncCLibCrypto('DES_ofb_encrypt');
     @DES_pcbc_encrypt:= LoadFuncCLibCrypto('DES_pcbc_encrypt');
     @DES_quad_cksum:= LoadFuncCLibCrypto('DES_quad_cksum');
     @DES_random_key:= LoadFuncCLibCrypto('DES_random_key');
     @DES_set_odd_parity:= LoadFuncCLibCrypto('DES_set_odd_parity');
     @DES_check_key_parity:= LoadFuncCLibCrypto('DES_check_key_parity');
     @DES_is_weak_key:= LoadFuncCLibCrypto('DES_is_weak_key');
     @DES_set_key:= LoadFuncCLibCrypto('DES_set_key');
     @DES_key_sched:= LoadFuncCLibCrypto('DES_key_sched');
     @DES_set_key_checked:= LoadFuncCLibCrypto('DES_set_key_checked');
     @DES_set_key_unchecked:= LoadFuncCLibCrypto('DES_set_key_unchecked', false);
     @private_DES_set_key_unchecked:= LoadFuncCLibCrypto('private_DES_set_key_unchecked', false);
     @DES_string_to_key:= LoadFuncCLibCrypto('DES_string_to_key');
     @DES_string_to_2keys:= LoadFuncCLibCrypto('DES_string_to_2keys');
     @DES_cfb64_encrypt:= LoadFuncCLibCrypto('DES_cfb64_encrypt');
     @DES_ofb64_encrypt:= LoadFuncCLibCrypto('DES_ofb64_encrypt');
     @DES_read_password:= LoadFuncCLibCrypto('DES_read_password');
     @DES_read_2passwords:= LoadFuncCLibCrypto('DES_read_2passwords');

   end;
end;

end.
