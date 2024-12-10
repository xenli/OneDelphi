unit ssl_dsa;

interface
uses ssl_types;

type TDSACallback = procedure(p1, p2: TC_INT; p3: Pointer); cdecl;

var
  DSA_new: function: PDSA; cdecl = nil;
  DSA_new_method: function(engine: PENGINE): PDSA; cdecl = nil;
  DSA_size: function(dsa: Pointer): TC_INT; cdecl = nil;
  DSA_free: procedure(dsa: PDSA); cdecl = nil;
  DSA_generate_parameters: function(bits: TC_INT; seed: PByte; seed_len: TC_INT; counter_ret: PC_INT; h_ret: PC_ULONG; callback: TDSACallback; cb_agr: Pointer): PDSA; cdecl = nil;
  DSA_generate_parameters_ex: function(dsa: PDSA; bits: TC_INT; seed: PByte; seed_len: TC_INT; counter_ret: PC_INT; h_ret: PC_ULONG; cb: BN_GENCB): TC_INT; cdecl = nil;
  DSA_generate_key: function (a: PDSA): TC_INT; cdecl = nil;
  DSA_up_ref: function(dsa: PDSA): TC_INT; cdecl = nil;

  DSAparams_dup: function(x: PDSA): PDSA; cdecl = nil;
  DSA_SIG_new: function: PDSA_SIG; cdecl = nil;
  DSA_SIG_free: procedure(a: PDSA_SIG); cdecl = nil;
  i2d_DSA_SIG: function(v: PPDSA_SIG; pp: PPAnsiChar): TC_INT;cdecl = nil;
  d2i_DSA_SIG: function(v: PPDSA_SIG; pp: PPAnsiChar; _length: TC_LONG): PDSA_SIG; cdecl = nil;
  DSA_do_sign: function(dgst: PAnsiChar; dlen: TC_INT; dsa: PDSA): PDSA_SIG; cdecl = nil;
  DSA_do_verify: function(dgst: PAnsiChar; dgst_len: TC_INT; sig: PDSA_SIG; dsa: PDSA): TC_INT; cdecl = nil;
  DSA_OpenSSL: function: PDSA_METHOD; cdecl = nil;
  DSA_set_default_method: function: PDSA_METHOD; cdecl = nil;
  DSA_set_method: function(dsa: PDSA; _method: PDSA_METHOD): TC_INT; cdecl = nil;
  DSA_sign_setup: function(dsa: PDSA; cxt_in: PBN_CTX; kinvp: PPBIGNUM; rp: PPBIGNUM): TC_INT; cdecl = nil;
  DSA_sign: function(_type: TC_INT; dgst: PAnsiChar; dlen: TC_INT; sig: PAnsiChar; siglen: TC_INT; dsa: PDSA): TC_INT; cdecl = nil;
  DSA_verify: function(_type: TC_INT; dgst: PAnsiChar; dgst_len: TC_INT; sigbuf: PAnsiChar; siglen: TC_INT; dsa: PDSA): TC_INT; cdecl = nil;
  DSA_get_ex_new_index: function(argl: TC_LONG; argp: Pointer; new_func: CRYPTO_EX_new; dup_func: CRYPTO_EX_dup; free_func: CRYPTO_EX_free): TC_INT; cdecl = nil;
  DSA_set_ex_data: function(d: PDSA; idx: TC_INT; arg: Pointer): TC_INT; cdecl = nil;
  DSA_get_ex_data: function(d: PDSA; idx: TC_INT): Pointer; cdecl = nil;

  d2i_DSAPublicKey: function(a: PPDSA; pp: PPAnsiChar; _length: TC_LONG): PDSA; cdecl = nil;
  d2i_DSAPrivateKey: function(a: PPDSA; pp: PPAnsiChar; _length: TC_LONG): PDSA; cdecl = nil;
  d2i_DSAparams: function(a: PPDSA; pp: PPAnsiChar; _length: TC_LONG): PDSA; cdecl = nil;
  i2d_DSAPublicKey: function(a: PDSA; pp: PPAnsiChar): TC_INT; cdecl = nil;
  i2d_DSAPrivateKey: function(a: PDSA; pp: PPAnsiChar): TC_INT; cdecl = nil;
  i2d_DSAparams: function(a: PDSA; pp: PPAnsiChar): TC_INT; cdecl = nil;

  DSAparams_print: function(bp: PBIO; x: PDSA): TC_INT; cdecl = nil;
  DSA_print: function(bp: PBIO; x: PDSA; off: TC_INT): TC_INT;

  DSAparams_print_fp: function(var fp: FILE; x: PDSA): TC_INT; cdecl = nil;
  DSA_print_fp: function(var fp: FILE; x: PDSA; off: TC_INT): TC_INT;

  ERR_load_DSA_strings: procedure; cdecl = nil;

procedure EVP_PKEY_assign_DSA(key: PEVP_PKEY; dsa: PDSA); inline;

procedure SSL_InitDSA;

implementation
uses ssl_lib, ssl_evphis, ssl_const;

procedure EVP_PKEY_assign_DSA(key: PEVP_PKEY; dsa: PDSA); inline;
begin
  EVP_PKEY_assign(key, EVP_PKEY_DSA, dsa);
end;


procedure SSL_InitDSA;
begin
 if @DSA_new = nil then
  begin
    @DSA_new := LoadFuncCLibCrypto('DSA_new');
    @DSA_new_method := LoadFuncCLibCrypto('DSA_new_method');
    @DSA_size := LoadFuncCLibCrypto('DSA_size');
    @DSA_generate_key := LoadFuncCLibCrypto('DSA_generate_key');
    @DSA_generate_parameters := LoadFuncCLibCrypto('DSA_generate_parameters');
    @DSA_generate_parameters_ex := LoadFuncCLibCrypto('DSA_generate_parameters_ex');
    @DSA_free := LoadFuncCLibCrypto('DSA_free');
    @DSA_up_ref := LoadFuncCLibCrypto('DSA_up_ref');
       
    @DSAparams_dup:= LoadFuncCLibCrypto('DSAparams_dup');
    @DSA_SIG_new:= LoadFuncCLibCrypto('DSA_SIG_new');
    @DSA_SIG_free:= LoadFuncCLibCrypto('DSA_SIG_free');
    @i2d_DSA_SIG:= LoadFuncCLibCrypto('i2d_DSA_SIG');
    @d2i_DSA_SIG:= LoadFuncCLibCrypto('d2i_DSA_SIG');
    @DSA_do_sign:= LoadFuncCLibCrypto('DSA_do_sign');
    @DSA_do_verify:= LoadFuncCLibCrypto('DSA_do_verify');
    @DSA_OpenSSL:= LoadFuncCLibCrypto('DSA_OpenSSL');
    @DSA_set_default_method:= LoadFuncCLibCrypto('DSA_set_default_method');
    @DSA_set_method:= LoadFuncCLibCrypto('DSA_set_method');
    @DSA_sign_setup:= LoadFuncCLibCrypto('DSA_sign_setup');
    @DSA_sign:= LoadFuncCLibCrypto('DSA_sign');
    @DSA_verify:= LoadFuncCLibCrypto('DSA_verify');
    @DSA_get_ex_new_index:= LoadFuncCLibCrypto('DSA_get_ex_new_index');
    @DSA_set_ex_data:= LoadFuncCLibCrypto('DSA_set_ex_data');
    @DSA_get_ex_data:= LoadFuncCLibCrypto('DSA_get_ex_data');
    @d2i_DSAPublicKey:= LoadFuncCLibCrypto('d2i_DSAPublicKey');
    @d2i_DSAPrivateKey:= LoadFuncCLibCrypto('d2i_DSAPrivateKey');
    @d2i_DSAparams:= LoadFuncCLibCrypto('d2i_DSAparams');
    @i2d_DSAPublicKey:= LoadFuncCLibCrypto('i2d_DSAPublicKey');
    @i2d_DSAPrivateKey:= LoadFuncCLibCrypto('i2d_DSAPrivateKey');
    @i2d_DSAparams:= LoadFuncCLibCrypto('i2d_DSAparams');
    @DSAparams_print:= LoadFuncCLibCrypto('DSAparams_print');
    @DSA_print:= LoadFuncCLibCrypto('DSA_print');
    @DSAparams_print_fp:= LoadFuncCLibCrypto('DSAparams_print_fp');
    @DSA_print_fp:= LoadFuncCLibCrypto('DSA_print_fp');
    @ERR_load_DSA_strings:= LoadFuncCLibCrypto('ERR_load_DSA_strings');
  end;
end;


end.
