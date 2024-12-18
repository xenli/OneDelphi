{$R-}
unit ssl_ec;

interface
uses ssl_types;

var
  EC_Curves: PEC_builtin_curves = nil;
  EC_NumCurves: Integer = 0;

  EC_get_builtin_curves: function (r: PEC_builtin_curves; nItems: TC_INT): TC_INT; cdecl = nil;
  EC_GROUP_new_by_curve_name: function(nid: TC_INT): PEC_GROUP; cdecl = nil;
  EC_GROUP_free: procedure (group: PEC_GROUP); cdecl = nil;
  EC_GROUP_set_asn1_flag: procedure(group: PEC_GROUP; flag: TC_INT); cdecl = nil;
  EC_GROUP_get_curve_name: function(group: PEC_GROUP): TC_INT; cdecl = nil;

  EC_KEY_new: function: PEC_KEY; cdecl = nil;
  EC_KEY_set_group: function(key: PEC_KEY; group: PEC_GROUP): TC_INT; cdecl = nil;
  EC_KEY_generate_key: function(key: PEC_KEY): TC_INT; cdecl = nil;
  EC_KEY_check_key: function(key: PEC_KEY): TC_INT; cdecl = nil;
  EC_KEY_free: procedure(key: PEC_KEY); cdecl = nil;

  EC_GFp_simple_method: function: PEC_METHOD; cdecl = nil;
  EC_GFp_mont_method: function: PEC_METHOD; cdecl = nil;
  EC_GFp_nist_method: function: PEC_METHOD; cdecl = nil;
  EC_GFp_nistp224_method: function: PEC_METHOD; cdecl = nil;
  EC_GFp_nistp256_method: function: PEC_METHOD; cdecl = nil;
  EC_GFp_nistp521_method: function: PEC_METHOD; cdecl = nil;
  EC_GF2m_simple_method: function: PEC_METHOD; cdecl = nil;

  EC_EX_DATA_set_data: function(par: PPEC_EXTRA_DATA; data: Pointer;	dup_func: EC_dup_func; free_func: EC_free_func; clear_free_func: EC_clear_free_func): TC_INT; cdecl = nil;
  EC_EX_DATA_get_data: function(par: PEC_EXTRA_DATA; dup_func: EC_dup_func; free_func: EC_free_func; clear_free_func: EC_clear_free_func): Pointer; cdecl = nil;
  EC_EX_DATA_free_data: procedure(par: PPEC_EXTRA_DATA; dup_func: EC_dup_func; free_func: EC_free_func; clear_free_func: EC_clear_free_func);cdecl = nil;
  EC_EX_DATA_clear_free_data: procedure(par: PPEC_EXTRA_DATA; dup_func: EC_dup_func; free_func: EC_free_func; clear_free_func: EC_clear_free_func);cdecl = nil;
  EC_EX_DATA_free_all_data: procedure(par: PPEC_EXTRA_DATA);cdecl = nil;
  EC_EX_DATA_clear_free_all_data: procedure(par: PPEC_EXTRA_DATA);cdecl = nil;

  EC_GROUP_clear_free: procedure(group: PEC_GROUP); cdecl = nil;
  EC_GROUP_set_curve_name: procedure(group: PEC_GROUP; nid: TC_INT); cdecl = nil;
  EC_GROUP_set_point_conversion_form: procedure(group: PEC_GROUP; t: point_conversion_form_t); cdecl = nil;

  EC_GROUP_new: function(meth: PEC_METHOD): PEC_GROUP; cdecl = nil;
  EC_GROUP_copy: function(dst: PEC_GROUP; const src: PEC_GROUP): TC_INT; cdecl = nil;
  EC_GROUP_dup: function(const src: PEC_GROUP): PEC_GROUP; cdecl = nil;
  EC_GROUP_method_of: function(const group: PEC_GROUP): PEC_METHOD; cdecl = nil;
  EC_METHOD_get_field_type: function(meth: PEC_METHOD): TC_INT;
  EC_GROUP_set_generator: function(group: PEC_GROUP; const generator: PEC_POINT; const order: PBIGNUM; const cofactor: PBIGNUM): TC_INT; cdecl = nil;
  EC_GROUP_get0_generator: function(const group: PEC_GROUP): PEC_POINT;cdecl = nil;
  EC_GROUP_get_order: function(const group: PEC_GROUP; order: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_get_cofactor: function(const group: PEC_GROUP; cofactor: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;

  EC_GROUP_get_asn1_flag: function(const group: PEC_GROUP): TC_INT; cdecl = nil;

  EC_GROUP_get_point_conversion_form: function(const group: PEC_GROUP): point_conversion_form_t; cdecl = nil;
  EC_GROUP_get0_seed: function(const group: PEC_GROUP): PAnsiChar; cdecl = nil;
  EC_GROUP_get_seed_len: function(const group: PEC_GROUP): TC_SIZE_T; cdecl = nil;
  EC_GROUP_set_seed: function(group: PEC_GROUP; buf: PAnsiChar; len: TC_SIZE_T): TC_SIZE_T;cdecl = nil;
  EC_GROUP_set_curve_GFp: function(group: PEC_GROUP; const p: PBIGNUM; const a: PBIGNUM; const b: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_get_curve_GFp: function(const group: PEC_GROUP; p: PBIGNUM; a: PBIGNUM; b: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_set_curve_GF2m: function(group: PEC_GROUP; const p: PBIGNUM; const a: PBIGNUM; const b: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_get_curve_GF2m: function(const group: PEC_GROUP; p: PBIGNUM; a: PBIGNUM; b: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_get_degree: function(const group: PEC_GROUP): TC_INT; cdecl = nil;
  EC_GROUP_check: function(const group: PEC_GROUP; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_check_discriminant: function(const group: PEC_GROUP; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_cmp: function(a: PEC_GROUP; b: PEC_GROUP; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_new_curve_GFp: function(const p: PBIGNUM; const a: PBIGNUM; const b: PBIGNUM; ctx: PBN_CTX): PEC_GROUP; cdecl = nil;
  EC_GROUP_new_curve_GF2m: function(const p: PBIGNUM; const a: PBIGNUM; const b: PBIGNUM; ctx: PBN_CTX): PEC_GROUP; cdecl = nil;
  d2i_ECPKParameters: function(group: PPEC_GROUP; _in: PPAnsiChar; len: TC_LONG): PEC_GROUP; cdecl = nil;
  i2d_ECPKParameters: function(group: PEC_GROUP; _out: PPAnsiChar): TC_INT; cdecl = nil;
  ECPKParameters_print: function(bp: PBIO; x: PEC_GROUP; off: TC_INT): TC_INT; cdecl = nil;
  ECPKParameters_print_fp: function(var fp: FILE; x: PEC_GROUP; off: TC_INT): TC_INT; cdecl = nil;

  EC_POINT_new: function(const group: PEC_GROUP): PEC_POINT; cdecl = nil;
  EC_POINT_free: procedure(point: PEC_POINT); cdecl = nil;
  EC_POINT_clear_free: procedure(point: PEC_POINT); cdecl = nil;
  EC_POINT_copy: function(dst: PEC_POINT; src: PEC_POINT): TC_INT; cdecl = nil;
  EC_POINT_dup: function(src: PEC_POINT; group: PEC_GROUP): PEC_POINT; cdecl = nil;
  EC_POINT_method_of: function(const point: PEC_POINT): PEC_METHOD; cdecl = nil;
  EC_POINT_set_to_infinity: function(const group: PEC_GROUP; point: PEC_POINT): TC_INT;
  EC_POINT_set_Jprojective_coordinates_GFp: function( group: PEC_GROUP; p: PEC_POINT;	 x: PBIGNUM; y: PBIGNUM;  z: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_get_Jprojective_coordinates_GFp: function( group: PEC_GROUP; p: PEC_POINT; x: PBIGNUM; y: PBIGNUM; z: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_set_affine_coordinates_GFp: function( group: PEC_GROUP; p: PEC_POINT;	 x: PBIGNUM;  y: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_get_affine_coordinates_GFp: function( group: PEC_GROUP;	 p: PEC_POINT; x: PBIGNUM; y: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_set_compressed_coordinates_GFp: function( group: PEC_GROUP; p: PEC_POINT;  x: PBIGNUM; y_bit: TC_INT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_set_affine_coordinates_GF2m: function( group: PEC_GROUP; p: PEC_POINT;	 x: PBIGNUM;  y: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_get_affine_coordinates_GF2m: function( group: PEC_GROUP; p: PEC_POINT; x: PBIGNUM; y: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_set_compressed_coordinates_GF2m: function( group: PEC_GROUP; p: PEC_POINT;	 x: PBIGNUM; y_bit: TC_INT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_point2oct: function( group: PEC_GROUP;  p: PEC_POINT; form: point_conversion_form_t; buf: PAnsiChar; len: TC_SIZE_T; ctx: PBN_CTX): TC_SIZE_T; cdecl = nil;
  EC_POINT_oct2point: function( group: PEC_GROUP; p: PEC_POINT;  buf: PAnsiChar; len: TC_SIZE_T; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_point2bn: function( group: PEC_GROUP;  point: PEC_POINT; form: point_conversion_form_t; b: PBIGNUM; ctx: PBN_CTX): PBIGNUM; cdecl = nil;
  EC_POINT_bn2point: function( group: PEC_GROUP;  b: PBIGNUM;	point: PEC_POINT; ctx: PBN_CTX): PEC_POINT; cdecl = nil;
  EC_POINT_point2hex: function( group: PEC_GROUP;  point: PEC_POINT; form: point_conversion_form_t; ctx: PBN_CTX): PAnsiChar;
  EC_POINT_hex2point: function( group: PEC_GROUP;  buf: PAnsiChar; point: PEC_POINT; ctx: PBN_CTX): PEC_POINT; cdecl = nil;
  EC_POINT_add: function( group: PEC_GROUP; r: PEC_POINT;  a: PEC_POINT;  b: PEC_POINT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_dbl: function( group: PEC_GROUP; r: PEC_POINT;  a: PEC_POINT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_invert: function( group: PEC_GROUP; a: PEC_POINT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_is_at_infinity: function( group: PEC_GROUP;  p: PEC_POINT): TC_INT; cdecl = nil;
  EC_POINT_is_on_curve: function( group: PEC_GROUP;  point: PEC_POINT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_cmp: function( group: PEC_GROUP;  a: PEC_POINT;  b: PEC_POINT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_make_affine: function( group: PEC_GROUP; point: PEC_POINT; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINTs_make_affine: function( group: PEC_GROUP; num: TC_SIZE_T; points: PEC_POINT_ARR; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINTs_mul: function( group: PEC_GROUP; r: PEC_POINT;  bn: PBIGNUM; num: TC_SIZE_T;  points: PEC_POINT_ARR;  bm: PBIGNUM_ARR; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_POINT_mul: function( group: PEC_GROUP; r: PEC_POINT;  bn: PBIGNUM;  pq: PEC_POINT;  bm: PBIGNUM; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_precompute_mult: function(group: PEC_GROUP; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_GROUP_have_precompute_mult: function( group: PEC_GROUP): TC_INT; cdecl = nil;
  EC_GROUP_get_basis_type: function( group: PEC_GROUP): TC_INT; cdecl = nil;
  EC_GROUP_get_trinomial_basis: function( group: PEC_GROUP; var k: TC_UINT): TC_INT; cdecl = nil;
  EC_GROUP_get_pentanomial_basis: function( group: PEC_GROUP; var k1: TC_UINT; var k2: TC_UINT; var k3: TC_UINT): TC_INT; cdecl = nil;

  EC_KEY_set_flags: procedure(key: PEC_KEY; flags: TC_INT); cdecl = nil;
  EC_KEY_clear_flags: procedure(key: PEC_KEY; flags: TC_INT); cdecl = nil;
  EC_KEY_get_flags: function(const key: PEC_KEY): TC_INT; cdecl = nil;

  EC_KEY_new_by_curve_name: function(nid: TC_INT): PEC_KEY; cdecl = nil;
  EC_KEY_copy: function(dst: PEC_KEY; const src: PEC_KEY): PEC_KEY; cdecl = nil;
  EC_KEY_dup: function(const src: PEC_KEY): PEC_KEY; cdecl = nil;
  EC_KEY_up_ref: function(key: PEC_KEY): TC_INT; cdecl = nil;
  EC_KEY_get0_group: function(const key: PEC_KEY): PEC_GROUP; cdecl = nil;
  EC_KEY_get0_private_key: function(const key: PEC_KEY): PBIGNUM; cdecl = nil;
  EC_KEY_set_private_key: function(key: PEC_KEY; const prv: PBIGNUM): TC_INT; cdecl = nil;
  EC_KEY_get0_public_key: function(const key: PEC_KEY): PEC_POINT; cdecl = nil;
  EC_KEY_set_public_key: function(key: PEC_KEY; const pub: PEC_POINT): TC_INT; cdecl = nil;
  EC_KEY_get_enc_flags: function(const key: PEC_KEY): TC_UINT; cdecl = nil;

  EC_KEY_set_enc_flags: procedure(key: PEC_KEY; flags: TC_UINT); cdecl =  nil;
  EC_KEY_set_conv_form: procedure(key: PEC_KEY; form: point_conversion_form_t); cdecl = nil;
  EC_KEY_get_conv_form: function(key: PEC_KEY): point_conversion_form_t; cdecl = nil;
  EC_KEY_set_asn1_flag: procedure(key: PEC_KEY; flags: TC_INT); cdecl = nil;

  EC_KEY_get_key_method_data: function(key: PEC_KEY;	dup_func: EC_dup_func; free_func: EC_free_func; clear_free_func: EC_clear_free_func): Pointer; cdecl = nil;
  EC_KEY_insert_key_method_data: procedure(key: PEC_KEY; data: Pointer;	dup_func: EC_dup_func; free_func: EC_free_func; clear_free_func: EC_clear_free_func); cdecl = nil;

  EC_KEY_precompute_mult: function(key: PEC_KEY; ctx: PBN_CTX): TC_INT; cdecl = nil;
  EC_KEY_set_public_key_affine_coordinates: function(key: PEC_KEY; x: PBIGNUM; y: PBIGNUM): TC_INT; cdecl = nil;
  d2i_ECPrivateKey: function(key: PPEC_KEY; _in: PPAnsiChar; len: TC_LONG): PEC_KEY;
  i2d_ECPrivateKey: function(key: PEC_KEY; _out: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ECParameters: function(key: PPEC_KEY; _in: PPAnsiChar; len: TC_LONG): PEC_KEY;
  i2d_ECParameters: function(key: PEC_KEY; _out: PPAnsiChar): TC_INT; cdecl = nil;
  o2i_ECPublicKey: function(key: PPEC_KEY; _in: PPAnsiChar; len: TC_LONG): PEC_KEY;
  i2o_ECPublicKey: function(key: PEC_KEY; _out: PPAnsiChar): TC_INT; cdecl = nil;
  ECParameters_print: function(bp: PBIO; const key: PEC_KEY): TC_INT; cdecl = nil;
  EC_KEY_print: function(bp: PBIO; const key: PEC_KEY; off: TC_INT): TC_INT; cdecl = nil;
  ECParameters_print_fp: function(var fp: FILE; const key: PEC_KEY): TC_INT; cdecl = nil;
  EC_KEY_print_fp: function(var fp: FILE; const key: PEC_KEY; off: TC_INT): TC_INT; cdecl = nil;

  ERR_load_EC_strings: procedure; cdecl = nil;


procedure EVP_PKEY_assign_EC_KEY(key: PEVP_PKEY; eckey: PEC_KEY); inline;

procedure SSL_InitEC;

implementation

uses ssl_util, ssl_lib, ssl_evphis, ssl_const;


procedure LoadCurves;
var BufSize: Integer;
begin
  if EC_Curves <> nil then
  begin
   OpenSSL_free(EC_Curves);
   EC_Curves := nil;
   EC_NumCurves := 0;
  end;

  if @EC_get_builtin_curves <> nil then
  begin
    EC_NumCurves := EC_get_builtin_curves(nil, 0);
    BufSize := SizeOf(EC_builtin_curve) * EC_NumCurves;
    EC_Curves := OpenSSL_malloc(BufSize);
    EC_get_builtin_curves(EC_Curves, EC_NumCurves);
  end;
end;

procedure SSL_InitEC;
begin
 if CLibCryptoHandle <> 0 then
   begin
    SSL_InitUtil;
    @EC_get_builtin_curves  :=LoadFuncCLibCrypto('EC_get_builtin_curves');
    @EC_GROUP_new_by_curve_name := LoadFuncCLibCrypto('EC_GROUP_new_by_curve_name');
    @EC_KEY_new := LoadFuncCLibCrypto('EC_KEY_new');
    @EC_GROUP_free := LoadFuncCLibCrypto('EC_GROUP_free');
    @EC_GROUP_set_asn1_flag := LoadFuncCLibCrypto('EC_GROUP_set_asn1_flag');
    @EC_GROUP_get_curve_name := LoadFuncCLibCrypto('EC_GROUP_get_curve_name');
    @EC_KEY_set_group := LoadFuncCLibCrypto('EC_KEY_set_group');
    @EC_KEY_generate_key := LoadFuncCLibCrypto('EC_KEY_generate_key');
    @EC_KEY_check_key := LoadFuncCLibCrypto('EC_KEY_check_key');
    @EC_KEY_free := LoadFuncCLibCrypto('EC_KEY_free');
    @EC_GFp_simple_method:= LoadFuncCLibCrypto('EC_GFp_simple_method');
    @EC_GFp_mont_method:= LoadFuncCLibCrypto('EC_GFp_mont_method');
    @EC_GFp_nist_method:= LoadFuncCLibCrypto('EC_GFp_nist_method');
    @EC_GFp_nistp224_method:= LoadFuncCLibCrypto('EC_GFp_nistp224_method', false);
    @EC_GFp_nistp256_method:= LoadFuncCLibCrypto('EC_GFp_nistp256_method', false);
    @EC_GFp_nistp521_method:= LoadFuncCLibCrypto('EC_GFp_nistp521_method', false);
    @EC_GF2m_simple_method:= LoadFuncCLibCrypto('EC_GF2m_simple_method');    
    @EC_GROUP_new:= LoadFuncCLibCrypto('EC_GROUP_new');
    @EC_GROUP_copy:= LoadFuncCLibCrypto('EC_GROUP_copy');
    @EC_GROUP_dup:= LoadFuncCLibCrypto('EC_GROUP_dup');
    @EC_GROUP_method_of:= LoadFuncCLibCrypto('EC_GROUP_method_of');
    @EC_METHOD_get_field_type:= LoadFuncCLibCrypto('EC_METHOD_get_field_type');
    @EC_GROUP_set_generator:= LoadFuncCLibCrypto('EC_GROUP_set_generator');
    @EC_GROUP_get0_generator:= LoadFuncCLibCrypto('EC_GROUP_get0_generator');
    @EC_GROUP_get_order:= LoadFuncCLibCrypto('EC_GROUP_get_order');
    @EC_GROUP_get_cofactor:= LoadFuncCLibCrypto('EC_GROUP_get_cofactor');
    @EC_GROUP_get_asn1_flag:= LoadFuncCLibCrypto('EC_GROUP_get_asn1_flag');
    @EC_GROUP_get_point_conversion_form:= LoadFuncCLibCrypto('EC_GROUP_get_point_conversion_form');
    @EC_GROUP_get0_seed:= LoadFuncCLibCrypto('EC_GROUP_get0_seed');
    @EC_GROUP_get_seed_len:= LoadFuncCLibCrypto('EC_GROUP_get_seed_len');
    @EC_GROUP_set_seed:= LoadFuncCLibCrypto('EC_GROUP_set_seed');
    @EC_GROUP_set_curve_GFp:= LoadFuncCLibCrypto('EC_GROUP_set_curve_GFp');
    @EC_GROUP_get_curve_GFp:= LoadFuncCLibCrypto('EC_GROUP_get_curve_GFp');
    @EC_GROUP_set_curve_GF2m:= LoadFuncCLibCrypto('EC_GROUP_set_curve_GF2m');
    @EC_GROUP_get_curve_GF2m:= LoadFuncCLibCrypto('EC_GROUP_get_curve_GF2m');
    @EC_GROUP_get_degree:= LoadFuncCLibCrypto('EC_GROUP_get_degree');
    @EC_GROUP_check:= LoadFuncCLibCrypto('EC_GROUP_check');
    @EC_GROUP_check_discriminant:= LoadFuncCLibCrypto('EC_GROUP_check_discriminant');
    @EC_GROUP_cmp:= LoadFuncCLibCrypto('EC_GROUP_cmp');
    @EC_GROUP_new_curve_GFp:= LoadFuncCLibCrypto('EC_GROUP_new_curve_GFp');
    @EC_GROUP_new_curve_GF2m:= LoadFuncCLibCrypto('EC_GROUP_new_curve_GF2m');
    @d2i_ECPKParameters:= LoadFuncCLibCrypto('d2i_ECPKParameters');
    @i2d_ECPKParameters:= LoadFuncCLibCrypto('i2d_ECPKParameters');
    @ECPKParameters_print:= LoadFuncCLibCrypto('ECPKParameters_print');
    @ECPKParameters_print_fp:= LoadFuncCLibCrypto('ECPKParameters_print_fp');
    @EC_POINT_new:= LoadFuncCLibCrypto('EC_POINT_new');
    @EC_POINT_free:= LoadFuncCLibCrypto('EC_POINT_free');
    @EC_POINT_clear_free:= LoadFuncCLibCrypto('EC_POINT_clear_free');
    @EC_POINT_copy:= LoadFuncCLibCrypto('EC_POINT_copy');
    @EC_POINT_dup:= LoadFuncCLibCrypto('EC_POINT_dup');
    @EC_POINT_method_of:= LoadFuncCLibCrypto('EC_POINT_method_of');
    @EC_POINT_set_to_infinity:= LoadFuncCLibCrypto('EC_POINT_set_to_infinity');
    @EC_POINT_set_Jprojective_coordinates_GFp:= LoadFuncCLibCrypto('EC_POINT_set_Jprojective_coordinates_GFp');
    @EC_POINT_get_Jprojective_coordinates_GFp:= LoadFuncCLibCrypto('EC_POINT_get_Jprojective_coordinates_GFp');
    @EC_POINT_set_affine_coordinates_GFp:= LoadFuncCLibCrypto('EC_POINT_set_affine_coordinates_GFp');
    @EC_POINT_get_affine_coordinates_GFp:= LoadFuncCLibCrypto('EC_POINT_get_affine_coordinates_GFp');
    @EC_POINT_set_compressed_coordinates_GFp:= LoadFuncCLibCrypto('EC_POINT_set_compressed_coordinates_GFp');
    @EC_POINT_set_affine_coordinates_GF2m:= LoadFuncCLibCrypto('EC_POINT_set_affine_coordinates_GF2m');
    @EC_POINT_get_affine_coordinates_GF2m:= LoadFuncCLibCrypto('EC_POINT_get_affine_coordinates_GF2m');
    @EC_POINT_set_compressed_coordinates_GF2m:= LoadFuncCLibCrypto('EC_POINT_set_compressed_coordinates_GF2m');
    @EC_POINT_point2oct:= LoadFuncCLibCrypto('EC_POINT_point2oct');
    @EC_POINT_oct2point:= LoadFuncCLibCrypto('EC_POINT_oct2point');
    @EC_POINT_point2bn:= LoadFuncCLibCrypto('EC_POINT_point2bn');
    @EC_POINT_bn2point:= LoadFuncCLibCrypto('EC_POINT_bn2point');
    @EC_POINT_point2hex:= LoadFuncCLibCrypto('EC_POINT_point2hex');
    @EC_POINT_hex2point:= LoadFuncCLibCrypto('EC_POINT_hex2point');
    @EC_POINT_add:= LoadFuncCLibCrypto('EC_POINT_add');
    @EC_POINT_dbl:= LoadFuncCLibCrypto('EC_POINT_dbl');
    @EC_POINT_invert:= LoadFuncCLibCrypto('EC_POINT_invert');
    @EC_POINT_is_at_infinity:= LoadFuncCLibCrypto('EC_POINT_is_at_infinity');
    @EC_POINT_is_on_curve:= LoadFuncCLibCrypto('EC_POINT_is_on_curve');
    @EC_POINT_cmp:= LoadFuncCLibCrypto('EC_POINT_cmp');
    @EC_POINT_make_affine:= LoadFuncCLibCrypto('EC_POINT_make_affine');
    @EC_POINTs_make_affine:= LoadFuncCLibCrypto('EC_POINTs_make_affine');
    @EC_POINTs_mul:= LoadFuncCLibCrypto('EC_POINTs_mul');
    @EC_POINT_mul:= LoadFuncCLibCrypto('EC_POINT_mul');
    @EC_GROUP_precompute_mult:= LoadFuncCLibCrypto('EC_GROUP_precompute_mult');
    @EC_GROUP_have_precompute_mult:= LoadFuncCLibCrypto('EC_GROUP_have_precompute_mult');
    @EC_GROUP_get_basis_type:= LoadFuncCLibCrypto('EC_GROUP_get_basis_type');
    @EC_GROUP_get_trinomial_basis:= LoadFuncCLibCrypto('EC_GROUP_get_trinomial_basis');
    @EC_GROUP_get_pentanomial_basis:= LoadFuncCLibCrypto('EC_GROUP_get_pentanomial_basis');
    @EC_KEY_set_flags:= LoadFuncCLibCrypto('EC_KEY_set_flags', false);
    @EC_KEY_clear_flags:= LoadFuncCLibCrypto('EC_KEY_clear_flags', false);
    @EC_KEY_get_flags:= LoadFuncCLibCrypto('EC_KEY_get_flags', false);
    @EC_KEY_new_by_curve_name:= LoadFuncCLibCrypto('EC_KEY_new_by_curve_name');
    @EC_KEY_copy:= LoadFuncCLibCrypto('EC_KEY_copy');
    @EC_KEY_dup:= LoadFuncCLibCrypto('EC_KEY_dup');
    @EC_KEY_up_ref:= LoadFuncCLibCrypto('EC_KEY_up_ref');
    @EC_KEY_get0_group:= LoadFuncCLibCrypto('EC_KEY_get0_group');
    @EC_KEY_get0_private_key:= LoadFuncCLibCrypto('EC_KEY_get0_private_key');
    @EC_KEY_set_private_key:= LoadFuncCLibCrypto('EC_KEY_set_private_key');
    @EC_KEY_get0_public_key:= LoadFuncCLibCrypto('EC_KEY_get0_public_key');
    @EC_KEY_set_public_key:= LoadFuncCLibCrypto('EC_KEY_set_public_key');
    @EC_KEY_get_enc_flags:= LoadFuncCLibCrypto('EC_KEY_get_enc_flags');
    @EC_KEY_set_enc_flags:= LoadFuncCLibCrypto('EC_KEY_set_enc_flags');
    @EC_KEY_set_conv_form:= LoadFuncCLibCrypto('EC_KEY_set_conv_form');
    @EC_KEY_get_conv_form:= LoadFuncCLibCrypto('EC_KEY_get_conv_form');
    @EC_KEY_set_asn1_flag:= LoadFuncCLibCrypto('EC_KEY_set_asn1_flag');
    @EC_KEY_get_key_method_data:= LoadFuncCLibCrypto('EC_KEY_get_key_method_data');
    @EC_KEY_insert_key_method_data:= LoadFuncCLibCrypto('EC_KEY_insert_key_method_data');
    @EC_KEY_precompute_mult:= LoadFuncCLibCrypto('EC_KEY_precompute_mult');
    @EC_KEY_set_public_key_affine_coordinates:= LoadFuncCLibCrypto('EC_KEY_set_public_key_affine_coordinates', false);
    @d2i_ECPrivateKey:= LoadFuncCLibCrypto('d2i_ECPrivateKey');
    @i2d_ECPrivateKey:= LoadFuncCLibCrypto('i2d_ECPrivateKey');
    @d2i_ECParameters:= LoadFuncCLibCrypto('d2i_ECParameters');
    @i2d_ECParameters:= LoadFuncCLibCrypto('i2d_ECParameters');
    @o2i_ECPublicKey:= LoadFuncCLibCrypto('o2i_ECPublicKey');
    @i2o_ECPublicKey:= LoadFuncCLibCrypto('i2o_ECPublicKey');
    @ECParameters_print:= LoadFuncCLibCrypto('ECParameters_print');
    @EC_KEY_print:= LoadFuncCLibCrypto('EC_KEY_print');
    @ECParameters_print_fp:= LoadFuncCLibCrypto('ECParameters_print_fp');
    @EC_KEY_print_fp:= LoadFuncCLibCrypto('EC_KEY_print_fp');
    @ERR_load_EC_strings:= LoadFuncCLibCrypto('ERR_load_EC_strings');

    if @EC_get_builtin_curves <> nil then
      LoadCurves;
  end;
end;

procedure EVP_PKEY_assign_EC_KEY(key: PEVP_PKEY; eckey: PEC_KEY);
begin
  EVP_PKEY_assign(key, EVP_PKEY_EC, eckey);
end;

initialization
finalization
 if (EC_Curves <> nil) then
 begin
   OpenSSL_free(EC_Curves);
   EC_Curves := nil;
   EC_NumCurves := 0;
 end;
end.

