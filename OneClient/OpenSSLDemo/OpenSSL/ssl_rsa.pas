unit ssl_rsa;

interface
uses ssl_types;

type
  TRSACallback = procedure(p1, p2: TC_INT; p3: Pointer); cdecl;

var
  RSA_new: function: PRSA; cdecl = nil;
  RSA_new_method: function(pengine: PENGINE): PRSA; cdecl = nil;
  RSA_size: function(pval: Pointer): TC_INT; cdecl = nil;
  RSA_generate_key: function(bits: TC_INT; e: TC_ULONG; callback: TRSACallback; cb_arg: Pointer): PRSA; cdecl = nil;
  RSA_generate_key_ex: function(rsa: PRSA; bits: TC_INT; e: PBIGNUM; cb: PBN_GENCB): TC_INT; cdecl = nil;
  RSA_check_key: function(rsa: PRSA): TC_INT; cdecl = nil;
  RSA_public_encrypt: function(flen: TC_INT; from: PByte; _to: PByte; rsa: PRSA; padding: TC_INT): TC_INT cdecl = nil;
  RSA_private_encrypt: function(flen: TC_INT; from: PByte; _to: PByte; rsa: PRSA; padding: TC_INT): TC_INT cdecl = nil;
  RSA_public_decrypt: function(flen: TC_INT; from: PByte; _to: PByte; rsa: PRSA; padding: TC_INT): TC_INT cdecl = nil;
  RSA_private_decrypt: function(flen: TC_INT; from: PByte; _to: PByte; rsa: PRSA; padding: TC_INT): TC_INT cdecl = nil;
  RSA_free : procedure(rsa: PRSA) cdecl = nil;
  RSA_up_ref: function(rsa: PRSA): TC_INT; cdecl = nil;
  RSA_flags: function(rsa: PRSA): TC_INT; cdecl = nil;
  ERR_load_RSA_strings: procedure; cdecl = nil;


	RSA_set_default_method: procedure(const _meth: PRSA_METHOD); cdecl = nil;
	RSA_get_default_method: function: PRSA_METHOD; cdecl = nil;
	RSA_get_method: function(const _rsa: PRSA): PRSA_METHOD; cdecl = nil;
	RSA_set_method: function(_rsa: PRSA; const _meth: PRSA_METHOD): TC_INT; cdecl = nil;

	RSA_memory_lock: function(_r: PRSA): TC_INT; cdecl = nil;
	RSA_PKCS1_SSLeay: function: PRSA_METHOD; cdecl = nil;
	RSA_null_method: function: PRSA_METHOD; cdecl = nil;

	d2i_RSAPublicKey: function(a: PPRSA; _in: PPAnsiChar; len: TC_LONG): PRSA; cdecl = nil;
	i2d_RSAPublicKey: function(a: PRSA; _out: PPAnsiChar): TC_INT; cdecl = nil;
	RSAPublicKey_it: function: PASN1_ITEM; cdecl = nil;
	d2i_RSAPrivateKey: function(a: PPRSA; _in: PPAnsiChar; len: TC_LONG): PRSA; cdecl = nil;
	i2d_RSAPrivateKey: function(a: PRSA; _out: PPAnsiChar): TC_INT; cdecl = nil;
	RSAPrivateKey_it: function: PASN1_ITEM; cdecl = nil;


	RSA_PSS_PARAMS_new: function: PRSA_PSS_PARAMS; cdecl = nil;
	RSA_PSS_PARAMS_free: procedure(a: PRSA_PSS_PARAMS); cdecl = nil;
	d2i_RSA_PSS_PARAMS: function(a: PPRSA_PSS_PARAMS; _in: PPAnsiChar; len: TC_LONG): PRSA_PSS_PARAMS; cdecl = nil;
	i2d_RSA_PSS_PARAMS: function(a: PRSA_PSS_PARAMS; _out: PPAnsiChar): TC_INT; cdecl = nil;
	RSA_PSS_PARAMS_it: function: PASN1_ITEM; cdecl = nil;

	RSA_print: function(_bp: PBIO; const _r: PRSA; _offset: TC_INT): TC_INT; cdecl = nil;

	i2d_RSA_NET: function(const _a: PRSA; _pp: PPAnsiChar; _cb: RSA_NET_CALLBACK_FUNC; _sgckey: TC_INT): TC_INT; cdecl = nil;
	d2i_RSA_NET: function(_a: PPRSA; const _pp: PPAnsiChar; _length: TC_LONG; _cb: RSA_NET_CALLBACK_FUNC; _sgckey: TC_INT): PRSA; cdecl = nil;

	i2d_Netscape_RSA: function(const _a: PRSA; _pp: PPAnsiChar; _cb: RSA_NET_CALLBACK_FUNC): TC_INT; cdecl = nil;
	d2i_Netscape_RSA: function(_a: PPRSA ; const _pp: PPAnsiChar; _length: TC_LONG; _cb: RSA_NET_CALLBACK_FUNC): PRSA; cdecl = nil;

	RSA_sign: function(_type: TC_INT; const _m: PAnsiChar; _m_length: TC_UINT; _sigret: PAnsiChar; var _siglen: TC_UINT; _rsa: PRSA): TC_INT; cdecl = nil;
	RSA_verify: function(_type: TC_INT; const _m: PAnsiChar; _m_length: TC_UINT; const _sigbuf: PAnsiChar; _siglen: TC_UINT; _rsa: PRSA): TC_INT; cdecl = nil;

	RSA_sign_ASN1_OCTET_STRING: function(_type: TC_INT;const _m: PAnsiChar; _m_length: TC_UINT; _sigret: PAnsiChar; var _siglen: TC_UINT; _rsa: PRSA): TC_INT; cdecl = nil;
	RSA_verify_ASN1_OCTET_STRING: function(_type: TC_INT; const _m: PAnsiChar; _m_length: TC_UINT; _sigbuf: PAnsiChar; _siglen: TC_UINT; _rsa: PRSA): TC_INT; cdecl = nil;

	RSA_blinding_on: function(_rsa: PRSA; _ctx: PBN_CTX): TC_INT; cdecl = nil;
	RSA_blinding_off: procedure(_rsa: PRSA); cdecl = nil;
	RSA_setup_blinding: function(_rsa: PRSA; _ctx: PBN_CTX): PBN_BLINDING; cdecl = nil;

	RSA_padding_add_PKCS1_type_1: function(_to: PAnsiChar;_tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_check_PKCS1_type_1: function(_to: PAnsiChar; _tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; _rsa_len: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_add_PKCS1_type_2: function(_to: PAnsiChar;_tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_check_PKCS1_type_2: function(_to: PAnsiChar; _tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; _rsa_len: TC_INT): TC_INT; cdecl = nil;
	PKCS1_MGF1: function(_mask: PAnsiChar; _len: TC_LONG; const _seed: PAnsiChar; _seedlen: TC_LONG; const _dgst: PEVP_MD): TC_INT; cdecl = nil;
	RSA_padding_add_PKCS1_OAEP: function(_to: PAnsiChar;_tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; const _p: PAnsiChar; _pl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_check_PKCS1_OAEP: function(_to: PAnsiChar; _tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; _rsa_len: TC_INT; const _p: PAnsiChar; _pl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_add_SSLv23: function(_to: PAnsiChar;_tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_check_SSLv23: function(_to: PAnsiChar; _tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; _rsa_len: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_add_none: function(_to: PAnsiChar;_tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_check_none: function(_to: PAnsiChar; _tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; _rsa_len: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_add_X931: function(_to: PAnsiChar;_tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_check_X931: function(_to: PAnsiChar; _tlen: TC_INT; const _f: PAnsiChar; _fl: TC_INT; _rsa_len: TC_INT): TC_INT; cdecl = nil;
	RSA_X931_hash_id: function(_nid: TC_INT): TC_INT; cdecl = nil;

	RSA_verify_PKCS1_PSS: function(_rsa: PRSA; const _mHash: PAnsiChar; const _Hash: PEVP_MD; const _EM: PAnsiChar; _sLen: TC_INT): TC_INT; cdecl = nil;
	RSA_padding_add_PKCS1_PSS: function(_rsa: PRSA; _EM: PAnsiChar; const _mHash: PAnsiChar; const _Hash: PEVP_MD; _sLen: TC_INT): TC_INT; cdecl = nil;

	RSA_verify_PKCS1_PSS_mgf1: function(_rsa: PRSA; const _mHash: PAnsiChar; const _Hash: PEVP_MD; const _mgf1Hash: PEVP_MD; const _EM: PAnsiChar; _sLen: TC_INT): TC_INT; cdecl = nil;

	RSA_padding_add_PKCS1_PSS_mgf1: function(_rsa: PRSA; _EM: PAnsiChar; const _mHash: PAnsiChar; const _Hash: PEVP_MD; const _mgf1Hash: PEVP_MD; _sLen: TC_INT): TC_INT; cdecl = nil;

	RSA_get_ex_new_index: function(_argl: TC_LONG; _argp: Pointer; _new_func: CRYPTO_EX_new; _dup_func: CRYPTO_EX_dup; _free_func: CRYPTO_EX_free): TC_INT; cdecl = nil;
	RSA_set_ex_data: function(_r: PRSA; _idx: TC_INT; _arg: Pointer): TC_INT; cdecl = nil;
	RSA_get_ex_data: function(const _r: PRSA; _idx: TC_INT): Pointer; cdecl = nil;

	RSAPublicKey_dup: function(_rsa: PRSA): PRSA; cdecl = nil;
	RSAPrivateKey_dup: function(_rsa: PRSA): PRSA; cdecl = nil;


procedure EVP_PKEY_assign_RSA(key: PEVP_PKEY; rsa: PRSA); inline;

procedure EVP_PKEY_CTX_set_rsa_padding(ctx: PEVP_PKEY_CTX; pad: TC_INT); inline;
function EVP_PKEY_CTX_get_rsa_padding(ctx: PEVP_PKEY_CTX): TC_INT; inline;
procedure EVP_PKEY_CTX_set_rsa_pss_saltlen(ctx: PEVP_PKEY_CTX; len: TC_INT); inline;
function EVP_PKEY_CTX_get_rsa_pss_saltlen(ctx: PEVP_PKEY_CTX): TC_INT; inline;
procedure EVP_PKEY_CTX_set_rsa_keygen_bits(ctx: PEVP_PKEY_CTX; bits: TC_INT); inline;
procedure EVP_PKEY_CTX_set_rsa_keygen_pubexp(ctx: PEVP_PKEY_CTX; pubexp: Pointer); inline;
procedure EVP_PKEY_CTX_set_rsa_mgf1_md(ctx: PEVP_PKEY_CTX; md: PEVP_MD); inline;
procedure EVP_PKEY_CTX_get_rsa_mgf1_md(ctx: PEVP_PKEY_CTX; pmd: PPEVP_MD); inline;

procedure SSL_InitRSA;

implementation

uses ssl_lib, ssl_evphis, ssl_const;

procedure EVP_PKEY_assign_RSA(key: PEVP_PKEY; rsa: PRSA); inline;
begin
  EVP_PKEY_assign(key, EVP_PKEY_RSA, rsa);
end;

procedure EVP_PKEY_CTX_set_rsa_padding(ctx: PEVP_PKEY_CTX; pad: TC_INT); inline;
begin
  EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, -1, EVP_PKEY_CTRL_RSA_PADDING, pad, nil);
end;

function EVP_PKEY_CTX_get_rsa_padding(ctx: PEVP_PKEY_CTX): TC_INT; inline;
var ppad: TC_INT;
begin
	EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, -1, EVP_PKEY_CTRL_GET_RSA_PADDING, 0, @ppad);
  Result := ppad;
end;

procedure EVP_PKEY_CTX_set_rsa_pss_saltlen(ctx: PEVP_PKEY_CTX; len: TC_INT); inline;
begin
	EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, (EVP_PKEY_OP_SIGN or EVP_PKEY_OP_VERIFY), EVP_PKEY_CTRL_RSA_PSS_SALTLEN, len, nil);
end;

function EVP_PKEY_CTX_get_rsa_pss_saltlen(ctx: PEVP_PKEY_CTX): TC_INT; inline;
var plen: TC_INT;
begin
	EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, (EVP_PKEY_OP_SIGN or EVP_PKEY_OP_VERIFY), EVP_PKEY_CTRL_GET_RSA_PSS_SALTLEN, 0, @plen);
  Result := plen;
end;

procedure EVP_PKEY_CTX_set_rsa_keygen_bits(ctx: PEVP_PKEY_CTX; bits: TC_INT); inline;
begin
	EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, EVP_PKEY_OP_KEYGEN, EVP_PKEY_CTRL_RSA_KEYGEN_BITS, bits, nil);
end;

procedure EVP_PKEY_CTX_set_rsa_keygen_pubexp(ctx: PEVP_PKEY_CTX; pubexp: Pointer); inline;
begin
	EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, EVP_PKEY_OP_KEYGEN, EVP_PKEY_CTRL_RSA_KEYGEN_PUBEXP, 0, pubexp);
end;

procedure EVP_PKEY_CTX_set_rsa_mgf1_md(ctx: PEVP_PKEY_CTX; md: PEVP_MD); inline;
begin
		EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, EVP_PKEY_OP_TYPE_SIG, EVP_PKEY_CTRL_RSA_MGF1_MD, 0, md);
end;

procedure EVP_PKEY_CTX_get_rsa_mgf1_md(ctx: PEVP_PKEY_CTX; pmd: PPEVP_MD); inline;
begin
	EVP_PKEY_CTX_ctrl(ctx, EVP_PKEY_RSA, EVP_PKEY_OP_TYPE_SIG, EVP_PKEY_CTRL_GET_RSA_MGF1_MD, 0, @pmd);
end;


procedure SSL_InitRSA;
begin
 if @RSA_new = nil then
  begin
    @RSA_new := LoadFuncCLibCrypto('RSA_new');
    @RSA_new_method := LoadFuncCLibCrypto('RSA_new_method');
    @RSA_size := LoadFuncCLibCrypto('RSA_size');
    @RSA_generate_key := LoadFuncCLibCrypto('RSA_generate_key');
    @RSA_generate_key_ex := LoadFuncCLibCrypto('RSA_generate_key_ex');
    @RSA_check_key := LoadFuncCLibCrypto('RSA_check_key');
    @RSA_public_encrypt := LoadFuncCLibCrypto('RSA_public_encrypt');
    @RSA_private_encrypt := LoadFuncCLibCrypto('RSA_private_encrypt');
    @RSA_public_decrypt := LoadFuncCLibCrypto('RSA_public_decrypt');
    @RSA_private_decrypt := LoadFuncCLibCrypto('RSA_private_decrypt');
    @RSA_free := LoadFuncCLibCrypto('RSA_free');
    @RSA_up_ref := LoadFuncCLibCrypto('RSA_up_ref');
    @RSA_flags := LoadFuncCLibCrypto('RSA_flags');
    @ERR_load_RSA_strings := LoadFuncCLibCrypto('ERR_load_RSA_strings');
    @RSA_set_default_method:= LoadFuncCLibCrypto('RSA_set_default_method');
    @RSA_get_default_method:= LoadFuncCLibCrypto('RSA_get_default_method');
    @RSA_get_method:= LoadFuncCLibCrypto('RSA_get_method');
    @RSA_set_method:= LoadFuncCLibCrypto('RSA_set_method');
    @RSA_memory_lock:= LoadFuncCLibCrypto('RSA_memory_lock');
    @RSA_PKCS1_SSLeay:= LoadFuncCLibCrypto('RSA_PKCS1_SSLeay');
    @RSA_null_method:= LoadFuncCLibCrypto('RSA_null_method');
    @RSA_PSS_PARAMS_new:= LoadFuncCLibCrypto('RSA_PSS_PARAMS_new');
    @RSA_PSS_PARAMS_free:= LoadFuncCLibCrypto('RSA_PSS_PARAMS_free');
    @d2i_RSA_PSS_PARAMS:= LoadFuncCLibCrypto('d2i_RSA_PSS_PARAMS');
    @i2d_RSA_PSS_PARAMS:= LoadFuncCLibCrypto('i2d_RSA_PSS_PARAMS');
    @RSA_PSS_PARAMS_it:= LoadFuncCLibCrypto('RSA_PSS_PARAMS_it');
    @RSA_print:= LoadFuncCLibCrypto('RSA_print');
    @i2d_RSA_NET:= LoadFuncCLibCrypto('i2d_RSA_NET');
    @d2i_RSA_NET:= LoadFuncCLibCrypto('d2i_RSA_NET');
    @i2d_Netscape_RSA:= LoadFuncCLibCrypto('i2d_Netscape_RSA');
    @d2i_Netscape_RSA:= LoadFuncCLibCrypto('d2i_Netscape_RSA');
    @RSA_sign:= LoadFuncCLibCrypto('RSA_sign');
    @RSA_verify:= LoadFuncCLibCrypto('RSA_verify');
    @RSA_sign_ASN1_OCTET_STRING:= LoadFuncCLibCrypto('RSA_sign_ASN1_OCTET_STRING');
    @RSA_verify_ASN1_OCTET_STRING:= LoadFuncCLibCrypto('RSA_verify_ASN1_OCTET_STRING');
    @RSA_blinding_on:= LoadFuncCLibCrypto('RSA_blinding_on');
    @RSA_blinding_off:= LoadFuncCLibCrypto('RSA_blinding_off');
    @RSA_setup_blinding:= LoadFuncCLibCrypto('RSA_setup_blinding');
    @RSA_padding_add_PKCS1_type_1:= LoadFuncCLibCrypto('RSA_padding_add_PKCS1_type_1');
    @RSA_padding_check_PKCS1_type_1:= LoadFuncCLibCrypto('RSA_padding_check_PKCS1_type_1');
    @RSA_padding_add_PKCS1_type_2:= LoadFuncCLibCrypto('RSA_padding_add_PKCS1_type_2');
    @RSA_padding_check_PKCS1_type_2:= LoadFuncCLibCrypto('RSA_padding_check_PKCS1_type_2');
    @PKCS1_MGF1:= LoadFuncCLibCrypto('PKCS1_MGF1');
    @RSA_padding_add_PKCS1_OAEP:= LoadFuncCLibCrypto('RSA_padding_add_PKCS1_OAEP');
    @RSA_padding_check_PKCS1_OAEP:= LoadFuncCLibCrypto('RSA_padding_check_PKCS1_OAEP');
    @RSA_padding_add_SSLv23:= LoadFuncCLibCrypto('RSA_padding_add_SSLv23');
    @RSA_padding_check_SSLv23:= LoadFuncCLibCrypto('RSA_padding_check_SSLv23');
    @RSA_padding_add_none:= LoadFuncCLibCrypto('RSA_padding_add_none');
    @RSA_padding_check_none:= LoadFuncCLibCrypto('RSA_padding_check_none');
    @RSA_padding_add_X931:= LoadFuncCLibCrypto('RSA_padding_add_X931');
    @RSA_padding_check_X931:= LoadFuncCLibCrypto('RSA_padding_check_X931');
    @RSA_X931_hash_id:= LoadFuncCLibCrypto('RSA_X931_hash_id');
    @RSA_verify_PKCS1_PSS:= LoadFuncCLibCrypto('RSA_verify_PKCS1_PSS');
    @RSA_padding_add_PKCS1_PSS:= LoadFuncCLibCrypto('RSA_padding_add_PKCS1_PSS');
    @RSA_verify_PKCS1_PSS_mgf1:= LoadFuncCLibCrypto('RSA_verify_PKCS1_PSS_mgf1');
    @RSA_padding_add_PKCS1_PSS_mgf1:= LoadFuncCLibCrypto('RSA_padding_add_PKCS1_PSS_mgf1');
    @RSA_get_ex_new_index:= LoadFuncCLibCrypto('RSA_get_ex_new_index');
    @RSA_set_ex_data:= LoadFuncCLibCrypto('RSA_set_ex_data');
    @RSA_get_ex_data:= LoadFuncCLibCrypto('RSA_get_ex_data');
    @RSAPublicKey_dup:= LoadFuncCLibCrypto('RSAPublicKey_dup');
    @RSAPrivateKey_dup:= LoadFuncCLibCrypto('RSAPrivateKey_dup');
    @d2i_RSAPublicKey:= LoadFuncCLibCrypto('d2i_RSAPublicKey');
    @i2d_RSAPublicKey:= LoadFuncCLibCrypto('i2d_RSAPublicKey');
    @RSAPublicKey_it:= LoadFuncCLibCrypto('RSAPublicKey_it');
    @d2i_RSAPrivateKey:= LoadFuncCLibCrypto('d2i_RSAPrivateKey');
    @i2d_RSAPrivateKey:= LoadFuncCLibCrypto('i2d_RSAPrivateKey');
    @RSAPrivateKey_it:= LoadFuncCLibCrypto('RSAPrivateKey_it');

  end;
end;

end.
