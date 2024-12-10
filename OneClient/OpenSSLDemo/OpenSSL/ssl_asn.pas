unit ssl_asn;

interface
uses ssl_types;
var
  ASN_ANY_it: function: PASN1_ITEM;

  ASN1_PCTX_new: function: PASN1_PCTX; cdecl = nil;
  ASN1_PCTX_free: procedure(p: PASN1_PCTX); cdecl = nil;
  ASN1_PCTX_get_flags: function(p: PASN1_PCTX): TC_ULONG; cdecl = nil;
  ASN1_PCTX_set_flags: procedure(p: PASN1_PCTX; flags: TC_ULONG); cdecl = nil;
  ASN1_PCTX_get_nm_flags: function(p : PASN1_PCTX): TC_ULONG; cdecl = nil;
  ASN1_PCTX_set_nm_flags: procedure(p: PASN1_PCTX; flags: TC_ULONG); cdecl = nil;
  ASN1_PCTX_get_cert_flags: function(p: PASN1_PCTX): TC_ULONG; cdecl = nil;
  ASN1_PCTX_set_cert_flags: procedure(p : PASN1_PCTX; flags: TC_ULONG); cdecl = nil;
  ASN1_PCTX_get_oid_flags: function(p: PASN1_PCTX): TC_ULONG; cdecl = nil;
  ASN1_PCTX_set_oid_flags: procedure(p :ASN1_PCTX; flags: TC_ULONG);
  ASN1_PCTX_get_str_flags: function(p : PASN1_PCTX): TC_ULONG; cdecl = nil;
  ASN1_PCTX_set_str_flags: procedure(p: PASN1_PCTX; flags: TC_ULONG); cdecl = nil;

  ASN1_SEQUENCE_ANY_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_SEQUENCE_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_SET_ANY_it: function: PASN1_ITEM; cdecl = nil;

  ASN1_STRING_TABLE_get: function(nid: TC_INT): PASN1_STRING_TABLE; cdecl = nil;
  ASN1_STRING_TABLE_add: function(_par1: TC_INT; _par2: TC_LONG; _par3: TC_LONG; _par4: TC_ULONG; _par5: TC_ULONG): TC_INT; cdecl = nil;
  ASN1_STRING_TABLE_cleanup: procedure; cdecl = nil;


  ASN1_TYPE_get: function(a: PASN1_TYPE): TC_INT; cdecl = nil;
  ASN1_TYPE_set: procedure(a: PASN1_TYPE; _type: TC_INT; value: Pointer); cdecl = nil;
  ASN1_TYPE_set1: function(a: PASN1_TYPE; _type: TC_INT; value: Pointer): TC_INT; cdecl = nil;
  ASN1_TYPE_cmp: function (a: PASN1_TYPE; b: PASN1_TYPE): TC_INT; cdecl = nil;
  ASN1_TYPE_free: procedure(a: PASN1_TYPE); cdecl = nil;
  ASN1_TYPE_set_octetstring: function(a: PASN1_TYPE; data: PAnsiChar; len: TC_INT): TC_INT; cdecl = nil;
  ASN1_TYPE_get_octetstring: function(a: PASN1_TYPE; data: PAnsiChar; max_len: TC_INT): TC_INT; cdecl = nil;
  ASN1_TYPE_set_int_octetstring: function(a: PASN1_TYPE; num: TC_LONG; data: PAnsiChar; len: TC_INT): TC_INT; cdecl = nil;
  ASN1_TYPE_get_int_octetstring: function(a: PASN1_TYPE; num: PC_LONG; data: PAnsiChar; len: TC_INT): TC_INT; cdecl = nil;
  ASN1_TYPE_new: function: PASN1_TYPE; cdecl = nil;

  ASN1_OBJECT_new: function: PASN1_OBJECT; cdecl = nil;
  ASN1_OBJECT_free: procedure(a: PASN1_OBJECT); cdecl = nil;
  ASN1_OBJECT_create: function(nid: TC_INT; data: PAnsiChar; len: TC_INT;	sn: PAnsiChar; ln: PAnsiChar): ASN1_OBJECT; cdecl = nil;
  i2d_ASN1_OBJECT: function(a: PASN1_OBJECT; pp: PPAnsiChar): TC_INT; cdecl = nil;
  c2i_ASN1_OBJECT: function(a: PPASN1_OBJECT; pp: PPAnsiChar; _length: TC_LONG): PASN1_OBJECT; cdecl = nil;
  d2i_ASN1_OBJECT: function(a: PPASN1_OBJECT; pp: PPAnsiChar; _length: TC_LONG): PASN1_OBJECT; cdecl = nil;
  ASN1_OBJECT_it: function: PASN1_ITEM;
  i2t_ASN1_OBJECT: function(buf: PAnsiChar;buf_len: TC_INT; a: PASN1_OBJECT): TC_INT; cdecl = nil;
  a2d_ASN1_OBJECT: function(_out: PAnsiChar; olen: TC_INT; buf: PAnsiChar;num: TC_INT): TC_INT; cdecl = nil;
  i2a_ASN1_OBJECT: function(bp: PBIO; a: PASN1_OBJECT): TC_INT; cdecl = nil;


  ASN1_STRING_new: function: PASN1_STRING; cdecl = nil;
  ASN1_STRING_free : procedure(a: PASN1_STRING) cdecl = nil;
  ASN1_STRING_copy: function(dst: PASN1_STRING; str: PASN1_STRING): TC_INT; cdecl = nil;
  ASN1_STRING_dup: function(a: PASN1_STRING): PASN1_STRING; cdecl = nil;
  ASN1_STRING_type_new : function(_type: TC_INT): PASN1_STRING cdecl = nil;
  ASN1_STRING_cmp: function(a: PASN1_STRING; b: PASN1_STRING): TC_INT; cdecl = nil;
  ASN1_STRING_set: function(str: PASN1_STRING; data: Pointer; len: TC_INT): TC_INT; cdecl = nil;
  ASN1_STRING_set0: procedure(str: PASN1_STRING; data: Pointer; len: TC_INT); cdecl = nil;
  ASN1_STRING_length: function(x: PASN1_STRING): TC_INT; cdecl = nil;
  ASN1_STRING_length_set: procedure(x: PASN1_STRING; n: TC_INT); cdecl = nil;
  ASN1_STRING_type: function (x: PASN1_STRING): TC_INT; cdecl = nil;
  ASN1_STRING_data: function(x: PASN1_STRING): PAnsiChar; cdecl = nil;
  ASN1_STRING_set_default_mask: procedure(mask: TC_ULONG); cdecl = nil;
  ASN1_STRING_set_default_mask_asc: function(p: PAnsiChar): TC_INT;cdecl = nil;
  ASN1_STRING_get_default_mask: function: TC_ULONG; cdecl = nil;
  ASN1_STRING_print_ex_fp: function(var fp: FILE; str: PASN1_STRING; flags: TC_ULONG): TC_INT; cdecl = nil;
  ASN1_STRING_print: function (bp: PBIO; v: PASN1_STRING): TC_INT; cdecl = nil;
  ASN1_STRING_print_ex: function(_out: PBIO; str: PASN1_STRING; flags: TC_ULONG): TC_INT; cdecl = nil;
  ASN1_STRING_set_by_NID: function(_out: PPASN1_STRING; _in: PAnsiChar; inlen: TC_INT; inform: TC_INT; nid: TC_INT): PASN1_STRING; cdecl = nil;
  ASN1_STRING_to_UTF8: function(_out: PPAnsiChar; _in: PASN1_STRING): TC_INT; cdecl = nil;
  i2a_ASN1_STRING: function(bp: PBIO; a: PASN1_STRING): TC_INT; cdecl = nil;
  a2i_ASN1_STRING: function(bp: PBIO; bs: PASN1_STRING; buf: PAnsiChar;size: TC_INT): TC_INT;

  ASN1_OCTET_STRING_NDEF_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_OCTET_STRING_new: function: PASN1_OCTET_STRING;
  ASN1_OCTET_STRING_free : procedure(a: PASN1_OCTET_STRING) cdecl = nil;
  ASN1_OCTET_STRING_cmp: function(a: PASN1_OCTET_STRING; b: PASN1_OCTET_STRING): TC_INT; cdecl = nil;
  ASN1_OCTET_STRING_dup: function(a: PASN1_OCTET_STRING): PASN1_OCTET_STRING; cdecl = nil;
  ASN1_OCTET_STRING_set: function(str: PASN1_OCTET_STRING; data: Pointer; len: TC_INT): TC_INT; cdecl = nil;
  ASN1_OCTET_STRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_OCTET_STRING: function(a: PASN1_OCTET_STRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_OCTET_STRING: function(a: PPASN1_OCTET_STRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_OCTET_STRING; cdecl = nil;

  ASN1_BIT_STRING_new: function: PASN1_BIT_STRING; cdecl = nil;
  ASN1_BIT_STRING_free: procedure(a: PASN1_BIT_STRING); cdecl = nil;
  ASN1_BIT_STRING_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_BIT_STRING_dup: function(a: PASN1_BIT_STRING): PASN1_BIT_STRING; cdecl = nil;
  ASN1_BIT_STRING_cmp: function(a: PASN1_BIT_STRING; b: PASN1_BIT_STRING): TC_INT; cdecl = nil;
  ASN1_BIT_STRING_set: function(str: PASN1_BIT_STRING; data: Pointer; len: TC_INT): TC_INT; cdecl = nil;
  ASN1_BIT_STRING_check: function (a: PASN1_BIT_STRING; flags: PAnsiChar; flags_len: TC_INT): TC_INT; cdecl = nil;
  ASN1_BIT_STRING_get_bit: function(a: PASN1_BIT_STRING; n: TC_INT): TC_INT; cdecl = nil;
  ASN1_BIT_STRING_name_print: function(_out: PBIO; bs: PASN1_BIT_STRING; tbl: PBIT_STRING_BITNAME; indend: TC_INT): TC_INT; cdecl = nil;
  ASN1_BIT_STRING_num_asc: function(name: PAnsiChar; tbl: PBIT_STRING_BITNAME): TC_INT; cdecl = nil;
  ASN1_BIT_STRING_set_asc: function(bs: PASN1_BIT_STRING; name: PAnsiChar;value: TC_INT; tbl: PBIT_STRING_BITNAME): TC_INT; cdecl = nil;

  i2d_ASN1_BIT_STRING: function(a: PASN1_BIT_STRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_BIT_STRING: function(a: PPASN1_BIT_STRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_BIT_STRING; cdecl = nil;
  c2i_ASN1_BIT_STRING: function(a: PPASN1_BIT_STRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_BIT_STRING; cdecl = nil;

  ASN1_BMPSTRING_new: function: PASN1_BMPSTRING; cdecl = nil;
  ASN1_BMPSTRING_free: procedure(a: PASN1_BMPSTRING); cdecl = nil;
  ASN1_BMPSTRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_BMPSTRING: function(a: PASN1_BMPSTRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_BMPSTRING: function(a: PPASN1_BMPSTRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_BMPSTRING; cdecl = nil;

  i2d_ASN1_BOOLEAN: function(a: TC_INT; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_BOOLEAN: function(var a: TC_INT; pp: PPAnsiChar; _length: TC_LONG): TC_INT; cdecl = nil;
  ASN1_BOOLEAN_it: function: PASN1_ITEM;
  ASN1_FBOOLEAN_it: function: PASN1_ITEM;
  ASN1_TBOOLEAN_it: function: PASN1_ITEM;

  ASN1_ENUMERATED_new: function: PASN1_ENUMERATED; cdecl = nil;
  ASN1_ENUMERATED_free: procedure(a: PASN1_ENUMERATED); cdecl = nil;
  ASN1_ENUMERATED_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_ENUMERATED_set: function(a: PASN1_ENUMERATED; v: TC_LONG): ASN1_ENUMERATED; cdecl = nil;
  ASN1_ENUMERATED_get: function(a: PASN1_ENUMERATED): TC_LONG; cdecl = nil;
  BN_to_ASN1_ENUMERATED: function (bn: PBIGNUM; ai: PASN1_ENUMERATED): ASN1_ENUMERATED; cdecl = nil;
  ASN1_ENUMERATED_to_BN: function(ai: PASN1_ENUMERATED; bn: PBIGNUM): PBIGNUM; cdecl = nil;
  i2d_ASN1_ENUMERATED: function(a: PASN1_ENUMERATED; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_ENUMERATED: function(a: PPASN1_ENUMERATED; pp: PPAnsiChar; _length: TC_LONG): PASN1_ENUMERATED; cdecl = nil;
  i2a_ASN1_ENUMERATED: function(bp: PBIO; a: PASN1_ENUMERATED): TC_INT; cdecl = nil;
  a2i_ASN1_ENUMERATED: function(bp: PBIO; bs: PASN1_ENUMERATED; buf: PAnsiChar;size: TC_INT): TC_INT;

  ASN1_INTEGER_new: function: PASN1_INTEGER; cdecl = nil;
  ASN1_INTEGER_free : procedure(a: PASN1_INTEGER) cdecl = nil;
  ASN1_INTEGER_dup: function(a: PASN1_INTEGER): PASN1_INTEGER; cdecl = nil;
  ASN1_INTEGER_cmp: function(x: PASN1_INTEGER; y: PASN1_INTEGER): TC_INT; cdecl = nil;
  ASN1_INTEGER_set : function(a: PASN1_INTEGER; v: TC_LONG): TC_INT cdecl = nil;
  ASN1_INTEGER_get : function(a: PASN1_INTEGER) : TC_LONG cdecl = nil;
  ASN1_INTEGER_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_INTEGER_to_BN: function (ai: PASN1_INTEGER; bn: PBIGNUM): PBIGNUM; cdecl = nil;
  BN_to_ASN1_INTEGER: function(bn: PBIGNUM; ai: PASN1_INTEGER): PASN1_INTEGER; cdecl = nil;
  i2c_ASN1_INTEGER: function (a: PASN1_INTEGER; pp: PPAnsiChar): TC_INT; cdecl = nil;
  c2i_ASN1_INTEGER: function (a: PPASN1_INTEGER; pp: PPAnsiChar; _length: TC_LONG): PASN1_INTEGER; cdecl = nil;
  d2i_ASN1_UINTEGER: function (a: PPASN1_INTEGER; pp: PPAnsiChar; _length: TC_LONG): PASN1_INTEGER; cdecl = nil;
  i2a_ASN1_INTEGER: function(bp: PBIO; a: PASN1_INTEGER): TC_INT; cdecl = nil;
  a2i_ASN1_INTEGER: function(bp: PBIO; bs: PASN1_INTEGER; buf: PAnsiChar;size: TC_INT): TC_INT;



  ASN1_GENERALIZEDTIME_new: function: PASN1_GENERALIZEDTIME; cdecl = nil;
  ASN1_GENERALIZEDTIME_free: procedure(a: PASN1_GENERALIZEDTIME); cdecl = nil;
  ASN1_GENERALIZEDTIME_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_GENERALIZEDTIME_print: function(fp: PBIO; a: PASN1_GENERALIZEDTIME): TC_INT; cdecl = nil;
  ASN1_GENERALIZEDTIME_check: function(a: PASN1_GENERALIZEDTIME): TC_INT; cdecl = nil;
  ASN1_GENERALIZEDTIME_set: function(s: PASN1_GENERALIZEDTIME; t: TC_time_t): PASN1_GENERALIZEDTIME; cdecl = nil;
  ASN1_GENERALIZEDTIME_adj: function(s: PASN1_GENERALIZEDTIME;t: TC_time_t; offset_day: TC_INT; offset_sec: TC_INT): ASN1_GENERALIZEDTIME; cdecl = nil;
  ASN1_GENERALIZEDTIME_set_string: function(s: PASN1_GENERALIZEDTIME; str: PAnsiChar): TC_INT; cdecl = nil;
  i2d_ASN1_GENERALIZEDTIME: function(a: PASN1_GENERALIZEDTIME; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_GENERALIZEDTIME: function(a: PPASN1_GENERALIZEDTIME; pp: PPAnsiChar; _length: TC_LONG): PASN1_GENERALIZEDTIME; cdecl = nil;

  ASN1_GENERALSTRING_new: function: PASN1_GENERALSTRING; cdecl = nil;
  ASN1_GENERALSTRING_free: procedure(a: PASN1_GENERALSTRING); cdecl = nil;
  ASN1_GENERALSTRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_GENERALSTRING: function(a: PASN1_GENERALSTRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_GENERALSTRING: function(a: PPASN1_GENERALSTRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_GENERALSTRING; cdecl = nil;

  ASN1_IA5STRING_new: function: PASN1_IA5STRING; cdecl = nil;
  ASN1_IA5STRING_free: procedure(a: PASN1_IA5STRING); cdecl = nil;
  ASN1_IA5STRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_IA5STRING: function(a: PASN1_IA5STRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_IA5STRING: function(a: PPASN1_IA5STRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_IA5STRING; cdecl = nil;

  ASN1_NULL_new: function: PASN1_NULL; cdecl = nil;
  ASN1_NULL_free: procedure(a: PASN1_NULL); cdecl = nil;
  ASN1_NULL_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_NULL: function(a: PASN1_NULL; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_NULL: function(a: PPASN1_NULL; pp: PPAnsiChar; _length: TC_LONG): PASN1_NULL; cdecl = nil;

  ASN1_PRINTABLESTRING_new: function: PASN1_PRINTABLESTRING; cdecl = nil;
  ASN1_PRINTABLESTRING_free: procedure(a: PASN1_PRINTABLESTRING); cdecl = nil;
  ASN1_PRINTABLESTRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_PRINTABLESTRING: function(a: PASN1_PRINTABLESTRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_PRINTABLESTRING: function(a: PPASN1_PRINTABLESTRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_PRINTABLESTRING; cdecl = nil;

  ASN1_PRINTABLE_type: function(s: PAnsiChar; max: TC_INT): TC_INT; cdecl = nil;
  ASN1_PRINTABLE_new: function: PASN1_T61STRING; cdecl = nil;
  ASN1_PRINTABLE_free: procedure(a: PASN1_T61STRING); cdecl = nil;
  ASN1_PRINTABLE_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_PRINTABLE: function(a: PASN1_T61STRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_PRINTABLE: function(a: PPASN1_T61STRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_T61STRING; cdecl = nil;

  ASN1_T61STRING_new: function: PASN1_T61STRING; cdecl = nil;
  ASN1_T61STRING_free: procedure(a: PASN1_T61STRING); cdecl = nil;
  ASN1_T61STRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_T61STRING: function(a: PASN1_T61STRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_T61STRING: function(a: PPASN1_T61STRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_T61STRING; cdecl = nil;

  ASN1_TIME_adj: function(s: PASN1_TIME; t: TC_time_t): PASN1_TIME;cdecl = nil;
  ASN1_TIME_set: function(s: PASN1_TIME; t: TC_time_t): PASN1_TIME;cdecl = nil;
  ASN1_TIME_check: function(t: PASN1_TIME): TC_INT;cdecl = nil;
  ASN1_TIME_set_string: function(s: PASN1_TIME; str: PAnsiChar): TC_INT; cdecl = nil;
  ASN1_TIME_new: function: PASN1_TIME; cdecl = nil;
  ASN1_TIME_free: procedure(a: PASN1_TIME); cdecl = nil;
  ASN1_TIME_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_TIME_print: function(fp: PBIO; a: PASN1_TIME): TC_INT; cdecl = nil;
  ASN1_TIME_to_generalizedtime: function(t: PASN1_TIME; _out: PPASN1_GENERALIZEDTIME): PASN1_GENERALIZEDTIME;
  i2d_ASN1_TIME: function(a: PASN1_TIME; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_TIME: function(a: PPASN1_TIME; pp: PPAnsiChar; _length: TC_LONG): PASN1_TIME; cdecl = nil;

  ASN1_UTCTIME_check: function(a: PASN1_UTCTIME): TC_INT; cdecl = nil;
  ASN1_UTCTIME_set: function(s: PASN1_UTCTIME; t : TC_time_t): PASN1_UTCTIME; cdecl = nil;
  ASN1_UTCTIME_adj: function(s: PASN1_UTCTIME; t : TC_time_t;offset_day: TC_INT; offset_sec: TC_LONG): PASN1_UTCTIME; cdecl = nil;
  ASN1_UTCTIME_set_string: function(s: PASN1_UTCTIME; str: PPAnsiChar): TC_INT; cdecl = nil;
  ASN1_UTCTIME_cmp_time_t: function(s: PASN1_UTCTIME; t: TC_time_t): TC_INT; cdecl = nil;
  ASN1_UTCTIME_new: function: PASN1_UTCTIME; cdecl = nil;
  ASN1_UTCTIME_free: procedure(a: PASN1_UTCTIME); cdecl = nil;
  ASN1_UTCTIME_it: function: PASN1_ITEM; cdecl = nil;
  ASN1_UTCTIME_print: function(fp: PBIO; a: PASN1_UTCTIME): TC_INT; cdecl = nil;
  i2d_ASN1_UTCTIME: function(a: PASN1_UTCTIME; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_UTCTIME: function(a: PPASN1_UTCTIME; pp: PPAnsiChar; _length: TC_LONG): PASN1_UTCTIME; cdecl = nil;

  ASN1_UNIVERSALSTRING_to_string: function(s: PASN1_UNIVERSALSTRING): TC_INT; cdecl = nil;
  ASN1_UNIVERSALSTRING_new: function: PASN1_UNIVERSALSTRING; cdecl = nil;
  ASN1_UNIVERSALSTRING_free: procedure(a: PASN1_UNIVERSALSTRING); cdecl = nil;
  ASN1_UNIVERSALSTRING_it: function: PASN1_ITEM; cdecl = nil;
  i2d_ASN1_UNIVERSALSTRING: function(a: PASN1_UNIVERSALSTRING; pp: PPAnsiChar): TC_INT; cdecl = nil;
  d2i_ASN1_UNIVERSALSTRING: function(a: PPASN1_UNIVERSALSTRING; pp: PPAnsiChar; _length: TC_LONG): PASN1_UNIVERSALSTRING; cdecl = nil;

  ASN1_UTF8STRING_new: function: PASN1_UTF8STRING; cdecl = nil;
  ASN1_UTF8STRING_free: procedure(a: PASN1_UTF8STRING); cdecl = nil;
  ASN1_UTF8STRING_it: function: PASN1_ITEM; cdecl = nil;

  ASN1_VISIBLESTRING_new: function: PASN1_VISIBLESTRING; cdecl = nil;
  ASN1_VISIBLESTRING_free: procedure(a: PASN1_VISIBLESTRING); cdecl = nil;
  ASN1_VISIBLESTRING_it: function: PASN1_ITEM; cdecl = nil;

  ASN1_d2i_bio: function(xnew: void_func; d2i: D2I_OF_void; _in: PBIO; var x: Pointer): pointer; cdecl = nil;
  ASN1_d2i_fp: function(xnew: void_func; d2i: D2I_OF_void; var _in: FILE; var x: Pointer): Pointer; cdecl = nil;

   (*
      STACK_OF(OPENSSL_BLOCK) *ASN1_seq_unpack(const unsigned char *buf, int len,
				 d2i_of_void *d2i, void (*free_func)(OPENSSL_BLOCK));
   *)


  ASN1_add_oid_module: procedure; cdecl = nil;
  ASN1_bn_print: function(bp: PBIO; number: PAnsiChar; num: PBIGNUM;buf: PAnsiChar; off: TC_INT): TC_INT; cdecl = nil;
  ASN1_check_infinite_end: function(p: PPAnsiChar; len: TC_LONG): TC_INT; cdecl = nil;
  ASN1_const_check_infinite_end: function(p: PPAnsiChar; len: TC_LONG): TC_INT; cdecl = nil;
  ASN1_digest: function(i2d: I2D_OF_void; _type: PEVP_MD; data: PAnsiChar; md: PAnsiChar; len:TC_UINT): TC_INT; cdecl = nil;
  ASN1_dup: function(i2d: I2D_OF_void; d2i: D2I_OF_void; x: pointer): Pointer; cdecl = nil;
  ASN1_generate_nconf: function(str: PAnsiChar; nconf: PCONF): PASN1_TYPE; cdecl = nil;
  ASN1_generate_v3: function(str: PAnsiChar; cnf: PX509V3_CTX): PASN1_TYPE; cdecl = nil;
  ASN1_get_object: function(pp: PPAnsiChar; plength: PC_LONG; ptag: PC_INT; pclass: PC_INT; omax: TC_LONG): TC_INT; cdecl = nil;
  ASN1_i2d_bio: function(i2d: I2D_OF_void; _out: PBIO; x: PAnsiChar): TC_INT;
  ASN1_i2d_fp: function(i2d: I2D_OF_void; var _out: FILE; x: PAnsiChar): TC_INT;
  ASN1_item_d2i: function(val: PPASN1_VALUE; _in: PPAnsiChar; len: TC_LONG; it: PASN1_ITEM): PASN1_VALUE; cdecl = nil;
  ASN1_item_d2i_bio: function(it: PASN1_ITEM; _in: PBIO; x: PAnsiChar): Pointer; cdecl = nil;
  ASN1_item_d2i_fp: function(it: PASN1_ITEM; var _in: FILE; x: PAnsiChar): Pointer; cdecl = nil;
  ASN1_item_digest: function(it: PASN1_ITEM; _type: PEVP_MD; asn: Pointer; md: PAnsiChar; len: PC_INT): TC_INT; cdecl = nil;
  ASN1_item_dup: function(it: PASN1_ITEM; x: pointer): pointer; cdecl = nil;
  ASN1_item_ex_d2i: function(pVal: PPASN1_VALUE;  _in: PPAnsiChar; len: TC_LONG; it: PASN1_ITEM; tag: TC_INT; aclass: TC_INT; opt: AnsiChar; ctx: PASN1_TLC): TC_INT; cdecl = nil;
  ASN1_item_ex_free:procedure(pval: PPASN1_VALUE; it: PASN1_ITEM); cdecl = nil;
  ASN1_item_ex_i2d: function(pval: PPASN1_VALUE; _out: PPAnsiChar; it: PASN1_ITEM; tag: TC_INT;aclass: TC_INT): TC_INT; cdecl = nil;
  ASN1_item_ex_new: function(pval: PPASN1_VALUE; it: PASN1_ITEM): TC_INT;cdecl = nil;
  ASN1_item_free: procedure(val: PASN1_VALUE; it: PASN1_ITEM); cdecl = nil;
  ASN1_item_i2d: function(val: PASN1_VALUE; _out: PPAnsiChar; it: PASN1_ITEM): TC_INT; cdecl = nil;
  ASN1_item_i2d_bio: function(it: PASN1_ITEM; _out: PBIO; x: Pointer): TC_INT; cdecl = nil;
  ASN1_item_i2d_fp: function(it: PASN1_ITEM; var _out: FILE; x: Pointer): TC_INT; cdecl = nil;
  ASN1_item_ndef_i2d: function(val: PASN1_VALUE; _out: PPAnsiChar; it: PASN1_ITEM): TC_INT; cdecl = nil;
  ASN1_item_new: function(it: PASN1_ITEM): PASN1_VALUE; cdecl = nil;
  ASN1_item_pack: function(obj: Pointer; it: PASN1_ITEM; oct: PPASN1_OCTET_STRING): PASN1_STRING; cdecl = nil;
  ASN1_item_print: function(_out: PBIO; ifld: PASN1_VALUE; indent: TC_INT; it: PASN1_ITEM; pctx: PASN1_PCTX): TC_INT; cdecl = nil;
  ASN1_item_sign: function(it: PASN1_ITEM; algor1: PX509_ALGOR; algro2: PX509_ALGOR; signature: PASN1_BIT_STRING; asn: Pointer; pkey: PEVP_PKEY; _type: PEVP_MD): TC_INT; cdecl = nil;
  ASN1_item_sign_ctx: function(it: PASN1_ITEM; algor1: PX509_ALGOR; algro2: PX509_ALGOR; signature: PASN1_BIT_STRING; asn: Pointer; ctx: PEVP_MD_CTX): TC_INT; cdecl = nil;
  ASN1_item_unpack: function(oct: PASN1_STRING; it: PASN1_ITEM): Pointer; cdecl = nil;
  ASN1_item_verify: function(it: PASN1_ITEM; a: PX509_ALGOR; signature: PASN1_BIT_STRING; asn: pointer; pkey: PEVP_PKEY): TC_INT; cdecl = nil;
  ASN1_mbstring_copy: function(_out: PPASN1_STRING; _in: PAnsiChar; len: TC_INT;	inform: TC_INT; mask: TC_ULONG): TC_INT; cdecl = nil;
  ASN1_mbstring_ncopy: function(_out: PPASN1_STRING; _in: PAnsiChar; len: TC_INT; inform: TC_INT; mask: TC_ULONG; minsize: TC_LONG; maxsize: TC_LONG): TC_INT; cdecl = nil;
  ASN1_object_size: function(constructed: TC_INT; _length: TC_INT; tag: TC_INT): TC_INT; cdecl = nil;
  ASN1_pack_string: function(obj: pointer; i2d: i2d_of_void; oct: PPASN1_OCTET_STRING): PASN1_STRING; cdecl = nil;
  ASN1_parse: function(bp: PBIO; pp: PAnsiChar; len: TC_LONG; indent: TC_INT): TC_INT; cdecl = nil;
  ASN1_parse_dump: function(bp: PBIO; pp: PAnsiChar; len: TC_LONG; indent: TC_INT; dump: TC_INT): TC_INT; cdecl = nil;
  ASN1_primitive_free: procedure(pval: PPASN1_VALUE; it: PASN1_ITEM); cdecl = nil;
  ASN1_primitive_new: function(pval: PPASN1_VALUE; it: PASN1_ITEM): TC_INT; cdecl = nil;
  ASN1_put_eoc: function(pp: PPAnsiChar): TC_INT; cdecl = nil;
  ASN1_put_object: procedure(pp: PPAnsiChar; constructed: TC_INT; _length: TC_INT; tag: TC_INT; xclass: TC_INT); cdecl = nil;
  ASN1_unpack_string: function(oct: PASN1_STRING; d2i: D2I_OF_void): Pointer; cdecl = nil;
  ASN1_verify: function(i2d: I2D_OF_void; a: PX509_ALGOR; signature: PASN1_BIT_STRING; data: PAnsiChar; pkey: PEVP_PKEY): TC_INT; cdecl = nil;
  ASN1_sign: function (i2d: I2D_OF_void; algro1: PX509_ALGOR; algor2: PX509_ALGOR; signature: PASN1_BIT_STRING; data: PAnsiChar; pkey: PEVP_PKEY; _type: PEVP_MD): TC_INT; cdecl = nil;
  ASN1_seq_pack: function(safes: PSTACK; i2d: I2D_OF_void; buf: PPAnsiChar; var len:TC_INT): PAnsiChar; cdecl = nil;
  ASN1_tag2bit: function(tag: TC_INT): TC_ULONG; cdecl = nil;
  ASN1_tag2str: function(tag: TC_INT): PAnsiChar;cdecl = nil;
  ASN1_template_d2i: function(pval: PPASN1_VALUE; _in: PPAnsiChar; len: TC_LONG; tt: PASN1_TEMPLATE): TC_INT; cdecl = nil;
  ASN1_template_free: procedure(pval: PPASN1_VALUE; tt: PASN1_TEMPLATE); cdecl = nil;
  ASN1_template_i2d: function(pval: PPASN1_VALUE; _out: PPAnsiChar; tt: PASN1_TEMPLATE): TC_INT; cdecl = nil;
  ASN1_template_new: function(pval: PPASN1_VALUE; tt: PASN1_TEMPLATE): TC_INT; cdecl = nil;

function M_ASN1_STRING_length(x : PASN1_STRING): TC_INT;
procedure M_ASN1_STRING_length_set(x : PASN1_STRING; n : TC_INT);
function M_ASN1_STRING_type(x : PASN1_STRING) : TC_INT;
function M_ASN1_STRING_data(x : PASN1_STRING) : PAnsiChar;


procedure SSL_InitASN1;

implementation
uses ssl_lib;



procedure SSL_InitASN1;
begin
  if @ASN1_STRING_new = nil then
  begin
      @ASN1_dup := LoadFuncCLibCrypto('ASN1_dup');
      @ASN_ANY_it := LoadFuncCLibCrypto('ASN_ANY_it', false);

      @ASN1_PCTX_new := LoadFuncCLibCrypto('ASN1_PCTX_new');
      @ASN1_PCTX_free:= LoadFuncCLibCrypto('ASN1_PCTX_free');
      @ASN1_PCTX_get_flags:= LoadFuncCLibCrypto('ASN1_PCTX_get_flags');
      @ASN1_PCTX_set_flags:= LoadFuncCLibCrypto('ASN1_PCTX_set_flags');
      @ASN1_PCTX_get_nm_flags:= LoadFuncCLibCrypto('ASN1_PCTX_get_nm_flags');
      @ASN1_PCTX_set_nm_flags:= LoadFuncCLibCrypto('ASN1_PCTX_set_nm_flags');
      @ASN1_PCTX_get_cert_flags:= LoadFuncCLibCrypto('ASN1_PCTX_get_cert_flags');
      @ASN1_PCTX_set_cert_flags:= LoadFuncCLibCrypto('ASN1_PCTX_set_cert_flags');
      @ASN1_PCTX_get_oid_flags:= LoadFuncCLibCrypto('ASN1_PCTX_get_oid_flags');
      @ASN1_PCTX_set_oid_flags:= LoadFuncCLibCrypto('ASN1_PCTX_set_oid_flags');
      @ASN1_PCTX_get_str_flags:= LoadFuncCLibCrypto('ASN1_PCTX_get_str_flags');
      @ASN1_PCTX_set_str_flags:= LoadFuncCLibCrypto('ASN1_PCTX_set_str_flags');
           
      @ASN1_SEQUENCE_ANY_it:= LoadFuncCLibCrypto('ASN1_SEQUENCE_ANY_it');
      @ASN1_SEQUENCE_it:= LoadFuncCLibCrypto('ASN1_SEQUENCE_it');
      @ASN1_SET_ANY_it:= LoadFuncCLibCrypto('ASN1_SET_ANY_it');
			
      @ASN1_STRING_TABLE_get:= LoadFuncCLibCrypto('ASN1_STRING_TABLE_get');
      @ASN1_STRING_TABLE_add:= LoadFuncCLibCrypto('ASN1_STRING_TABLE_add');
      @ASN1_STRING_TABLE_cleanup:= LoadFuncCLibCrypto('ASN1_STRING_TABLE_cleanup');


      @ASN1_TYPE_get := LoadFuncCLibCrypto('ASN1_TYPE_get');
      @ASN1_TYPE_set:= LoadFuncCLibCrypto('ASN1_TYPE_set');
      @ASN1_TYPE_set1 := LoadFuncCLibCrypto('ASN1_TYPE_set1');
      @ASN1_TYPE_cmp:= LoadFuncCLibCrypto('ASN1_TYPE_cmp');
      @ASN1_TYPE_free:= LoadFuncCLibCrypto('ASN1_TYPE_free');
      @ASN1_TYPE_set_octetstring:= LoadFuncCLibCrypto('ASN1_TYPE_set_octetstring');
      @ASN1_TYPE_get_octetstring:= LoadFuncCLibCrypto('ASN1_TYPE_get_octetstring');
      @ASN1_TYPE_set_int_octetstring:= LoadFuncCLibCrypto('ASN1_TYPE_set_int_octetstring');
      @ASN1_TYPE_get_int_octetstring:= LoadFuncCLibCrypto('ASN1_TYPE_get_int_octetstring');
      @ASN1_TYPE_new:= LoadFuncCLibCrypto('ASN1_TYPE_new');

      @ASN1_OBJECT_new:= LoadFuncCLibCrypto('ASN1_OBJECT_new');
      @ASN1_OBJECT_free:= LoadFuncCLibCrypto('ASN1_OBJECT_free');
      @ASN1_OBJECT_create:= LoadFuncCLibCrypto('ASN1_OBJECT_create');
      @i2d_ASN1_OBJECT:= LoadFuncCLibCrypto('i2d_ASN1_OBJECT');
      @c2i_ASN1_OBJECT:= LoadFuncCLibCrypto('c2i_ASN1_OBJECT');
      @d2i_ASN1_OBJECT:= LoadFuncCLibCrypto('d2i_ASN1_OBJECT');
      @ASN1_OBJECT_it:= LoadFuncCLibCrypto('ASN1_OBJECT_it');
      @i2t_ASN1_OBJECT:= LoadFuncCLibCrypto('i2t_ASN1_OBJECT');
      @a2d_ASN1_OBJECT:= LoadFuncCLibCrypto('a2d_ASN1_OBJECT');
      @i2a_ASN1_OBJECT:= LoadFuncCLibCrypto('i2a_ASN1_OBJECT');

      @ASN1_STRING_new:= LoadFuncCLibCrypto('ASN1_STRING_new');
      @ASN1_STRING_free:= LoadFuncCLibCrypto('ASN1_STRING_free');
      @ASN1_STRING_copy:= LoadFuncCLibCrypto('ASN1_STRING_copy');
      @ASN1_STRING_dup:= LoadFuncCLibCrypto('ASN1_STRING_dup');
      @ASN1_STRING_type_new:= LoadFuncCLibCrypto('ASN1_STRING_type_new');
      @ASN1_STRING_cmp:= LoadFuncCLibCrypto('ASN1_STRING_cmp');
      @ASN1_STRING_set:= LoadFuncCLibCrypto('ASN1_STRING_set');
      @ASN1_STRING_set0:= LoadFuncCLibCrypto('ASN1_STRING_set0');
      @ASN1_STRING_length:= LoadFuncCLibCrypto('ASN1_STRING_length');
      @ASN1_STRING_length_set:= LoadFuncCLibCrypto('ASN1_STRING_length_set');
      @ASN1_STRING_type:= LoadFuncCLibCrypto('ASN1_STRING_type');
      @ASN1_STRING_data:= LoadFuncCLibCrypto('ASN1_STRING_data');
      @ASN1_STRING_set_default_mask:= LoadFuncCLibCrypto('ASN1_STRING_set_default_mask');
      @ASN1_STRING_set_default_mask_asc:= LoadFuncCLibCrypto('ASN1_STRING_set_default_mask_asc');
      @ASN1_STRING_get_default_mask:= LoadFuncCLibCrypto('ASN1_STRING_get_default_mask');
      @ASN1_STRING_print_ex_fp:= LoadFuncCLibCrypto('ASN1_STRING_print_ex_fp');
      @ASN1_STRING_print:= LoadFuncCLibCrypto('ASN1_STRING_print');
      @ASN1_STRING_print_ex:= LoadFuncCLibCrypto('ASN1_STRING_print_ex');
      @ASN1_STRING_set_by_NID:= LoadFuncCLibCrypto('ASN1_STRING_set_by_NID');
      @ASN1_STRING_to_UTF8:= LoadFuncCLibCrypto('ASN1_STRING_to_UTF8');
      @i2a_ASN1_STRING:= LoadFuncCLibCrypto('i2a_ASN1_STRING');
      @a2i_ASN1_STRING:= LoadFuncCLibCrypto('a2i_ASN1_STRING');

      @ASN1_OCTET_STRING_NDEF_it:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_NDEF_it');
      @ASN1_OCTET_STRING_new:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_new');
      @ASN1_OCTET_STRING_free:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_free');
      @ASN1_OCTET_STRING_cmp:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_cmp');
      @ASN1_OCTET_STRING_dup:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_dup');
      @ASN1_OCTET_STRING_set:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_set');
      @ASN1_OCTET_STRING_it:= LoadFuncCLibCrypto('ASN1_OCTET_STRING_it');
      @i2d_ASN1_OCTET_STRING:= LoadFuncCLibCrypto('i2d_ASN1_OCTET_STRING');
      @d2i_ASN1_OCTET_STRING:= LoadFuncCLibCrypto('d2i_ASN1_OCTET_STRING');

      @ASN1_BIT_STRING_new:= LoadFuncCLibCrypto('ASN1_BIT_STRING_new');
      @ASN1_BIT_STRING_free:= LoadFuncCLibCrypto('ASN1_BIT_STRING_free');
      @ASN1_BIT_STRING_dup:= LoadFuncCLibCrypto('ASN1_BIT_STRING_dup', false);
      @ASN1_BIT_STRING_cmp:= LoadFuncCLibCrypto('ASN1_BIT_STRING_cmp', false);
      @ASN1_BIT_STRING_set:= LoadFuncCLibCrypto('ASN1_BIT_STRING_set');
      @ASN1_BIT_STRING_check:= LoadFuncCLibCrypto('ASN1_BIT_STRING_check');
      @ASN1_BIT_STRING_get_bit:= LoadFuncCLibCrypto('ASN1_BIT_STRING_get_bit');
      @ASN1_BIT_STRING_name_print:= LoadFuncCLibCrypto('ASN1_BIT_STRING_name_print');
      @ASN1_BIT_STRING_num_asc:= LoadFuncCLibCrypto('ASN1_BIT_STRING_num_asc');
      @ASN1_BIT_STRING_set_asc:= LoadFuncCLibCrypto('ASN1_BIT_STRING_set_asc');
      @ASN1_BIT_STRING_it:= LoadFuncCLibCrypto('ASN1_BIT_STRING_it');
      @i2d_ASN1_BIT_STRING:= LoadFuncCLibCrypto('i2d_ASN1_BIT_STRING');
      @d2i_ASN1_BIT_STRING:= LoadFuncCLibCrypto('d2i_ASN1_BIT_STRING');
      @c2i_ASN1_BIT_STRING:= LoadFuncCLibCrypto('c2i_ASN1_BIT_STRING');

      @ASN1_BMPSTRING_new:= LoadFuncCLibCrypto('ASN1_BMPSTRING_new');
      @ASN1_BMPSTRING_free:= LoadFuncCLibCrypto('ASN1_BMPSTRING_free');
      @ASN1_BMPSTRING_it:= LoadFuncCLibCrypto('ASN1_BMPSTRING_it');
      @i2d_ASN1_BMPSTRING:= LoadFuncCLibCrypto('i2d_ASN1_BMPSTRING');
      @d2i_ASN1_BMPSTRING:= LoadFuncCLibCrypto('d2i_ASN1_BMPSTRING');

      @i2d_ASN1_BOOLEAN:= LoadFuncCLibCrypto('i2d_ASN1_BOOLEAN');
      @d2i_ASN1_BOOLEAN:= LoadFuncCLibCrypto('d2i_ASN1_BOOLEAN');
      @ASN1_BOOLEAN_it:= LoadFuncCLibCrypto('ASN1_BOOLEAN_it');
      @ASN1_FBOOLEAN_it:= LoadFuncCLibCrypto('ASN1_FBOOLEAN_it');
      @ASN1_TBOOLEAN_it:= LoadFuncCLibCrypto('ASN1_TBOOLEAN_it');


      @ASN1_ENUMERATED_new:= LoadFuncCLibCrypto('ASN1_ENUMERATED_new');
      @ASN1_ENUMERATED_free:= LoadFuncCLibCrypto('ASN1_ENUMERATED_free');
      @ASN1_ENUMERATED_it:= LoadFuncCLibCrypto('ASN1_ENUMERATED_it');
      @ASN1_ENUMERATED_set:= LoadFuncCLibCrypto('ASN1_ENUMERATED_set');
      @ASN1_ENUMERATED_get:= LoadFuncCLibCrypto('ASN1_ENUMERATED_get');
      @BN_to_ASN1_ENUMERATED:= LoadFuncCLibCrypto('BN_to_ASN1_ENUMERATED');
      @ASN1_ENUMERATED_to_BN:= LoadFuncCLibCrypto('ASN1_ENUMERATED_to_BN');
      @i2d_ASN1_ENUMERATED:= LoadFuncCLibCrypto('i2d_ASN1_ENUMERATED');
      @d2i_ASN1_ENUMERATED:= LoadFuncCLibCrypto('d2i_ASN1_ENUMERATED');
      @i2a_ASN1_ENUMERATED:= LoadFuncCLibCrypto('i2a_ASN1_ENUMERATED');
      @a2i_ASN1_ENUMERATED:= LoadFuncCLibCrypto('a2i_ASN1_ENUMERATED');

      @ASN1_INTEGER_new:= LoadFuncCLibCrypto('ASN1_INTEGER_new');
      @ASN1_INTEGER_free:= LoadFuncCLibCrypto('ASN1_INTEGER_free');
      @ASN1_INTEGER_dup:= LoadFuncCLibCrypto('ASN1_INTEGER_dup');
      @ASN1_INTEGER_cmp:= LoadFuncCLibCrypto('ASN1_INTEGER_cmp');
      @ASN1_INTEGER_set:= LoadFuncCLibCrypto('ASN1_INTEGER_set');
      @ASN1_INTEGER_get:= LoadFuncCLibCrypto('ASN1_INTEGER_get');
      @ASN1_INTEGER_it:= LoadFuncCLibCrypto('ASN1_INTEGER_it');
      @ASN1_INTEGER_to_BN:= LoadFuncCLibCrypto('ASN1_INTEGER_to_BN');
      @BN_to_ASN1_INTEGER:= LoadFuncCLibCrypto('BN_to_ASN1_INTEGER');
      @i2c_ASN1_INTEGER:= LoadFuncCLibCrypto('i2c_ASN1_INTEGER');
      @c2i_ASN1_INTEGER:= LoadFuncCLibCrypto('c2i_ASN1_INTEGER');
      @d2i_ASN1_UINTEGER:= LoadFuncCLibCrypto('d2i_ASN1_UINTEGER');
      @i2a_ASN1_INTEGER:= LoadFuncCLibCrypto('i2a_ASN1_INTEGER');
      @a2i_ASN1_INTEGER:= LoadFuncCLibCrypto('a2i_ASN1_INTEGER');

      @ASN1_GENERALIZEDTIME_new:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_new');
      @ASN1_GENERALIZEDTIME_free:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_free');
      @ASN1_GENERALIZEDTIME_it:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_it');
      @ASN1_GENERALIZEDTIME_print:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_print');
      @ASN1_GENERALIZEDTIME_check:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_check');
      @ASN1_GENERALIZEDTIME_set:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_set');
      @ASN1_GENERALIZEDTIME_adj:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_adj');
      @ASN1_GENERALIZEDTIME_set_string:= LoadFuncCLibCrypto('ASN1_GENERALIZEDTIME_set_string');
      @i2d_ASN1_GENERALIZEDTIME:= LoadFuncCLibCrypto('i2d_ASN1_GENERALIZEDTIME');
      @d2i_ASN1_GENERALIZEDTIME:= LoadFuncCLibCrypto('d2i_ASN1_GENERALIZEDTIME');

      @ASN1_GENERALSTRING_new:= LoadFuncCLibCrypto('ASN1_GENERALSTRING_new');
      @ASN1_GENERALSTRING_free:= LoadFuncCLibCrypto('ASN1_GENERALSTRING_free');
      @ASN1_GENERALSTRING_it:= LoadFuncCLibCrypto('ASN1_GENERALSTRING_it');
      @i2d_ASN1_GENERALSTRING:= LoadFuncCLibCrypto('i2d_ASN1_GENERALSTRING');
      @d2i_ASN1_GENERALSTRING:= LoadFuncCLibCrypto('d2i_ASN1_GENERALSTRING');

      @ASN1_IA5STRING_new:= LoadFuncCLibCrypto('ASN1_IA5STRING_new');
      @ASN1_IA5STRING_free:= LoadFuncCLibCrypto('ASN1_IA5STRING_free');
      @ASN1_IA5STRING_it:= LoadFuncCLibCrypto('ASN1_IA5STRING_it');
      @i2d_ASN1_IA5STRING:= LoadFuncCLibCrypto('i2d_ASN1_IA5STRING');
      @d2i_ASN1_IA5STRING:= LoadFuncCLibCrypto('d2i_ASN1_IA5STRING');

      @ASN1_NULL_new:= LoadFuncCLibCrypto('ASN1_NULL_new');
      @ASN1_NULL_free:= LoadFuncCLibCrypto('ASN1_NULL_free');
      @ASN1_NULL_it:= LoadFuncCLibCrypto('ASN1_NULL_it');
      @i2d_ASN1_NULL:= LoadFuncCLibCrypto('i2d_ASN1_NULL');
      @d2i_ASN1_NULL:= LoadFuncCLibCrypto('d2i_ASN1_NULL');

      @ASN1_PRINTABLESTRING_new:= LoadFuncCLibCrypto('ASN1_PRINTABLESTRING_new');
      @ASN1_PRINTABLESTRING_free:= LoadFuncCLibCrypto('ASN1_PRINTABLESTRING_free');
      @ASN1_PRINTABLESTRING_it:= LoadFuncCLibCrypto('ASN1_PRINTABLESTRING_it');
      @i2d_ASN1_PRINTABLESTRING:= LoadFuncCLibCrypto('i2d_ASN1_PRINTABLESTRING');
      @d2i_ASN1_PRINTABLESTRING:= LoadFuncCLibCrypto('d2i_ASN1_PRINTABLESTRING');

      @ASN1_PRINTABLE_type:= LoadFuncCLibCrypto('ASN1_PRINTABLE_type');
      @ASN1_PRINTABLE_new:= LoadFuncCLibCrypto('ASN1_PRINTABLE_new');
      @ASN1_PRINTABLE_free:= LoadFuncCLibCrypto('ASN1_PRINTABLE_free');
      @ASN1_PRINTABLE_it:= LoadFuncCLibCrypto('ASN1_PRINTABLE_it');
      @i2d_ASN1_PRINTABLE:= LoadFuncCLibCrypto('i2d_ASN1_PRINTABLE');
      @d2i_ASN1_PRINTABLE:= LoadFuncCLibCrypto('d2i_ASN1_PRINTABLE');

      @ASN1_T61STRING_new:= LoadFuncCLibCrypto('ASN1_T61STRING_new');
      @ASN1_T61STRING_free:= LoadFuncCLibCrypto('ASN1_T61STRING_free');
      @ASN1_T61STRING_it:= LoadFuncCLibCrypto('ASN1_T61STRING_it');
      @i2d_ASN1_T61STRING:= LoadFuncCLibCrypto('i2d_ASN1_T61STRING');
      @d2i_ASN1_T61STRING:= LoadFuncCLibCrypto('d2i_ASN1_T61STRING');
                                  
      @ASN1_TIME_adj:= LoadFuncCLibCrypto('ASN1_TIME_adj');
      @ASN1_TIME_set:= LoadFuncCLibCrypto('ASN1_TIME_set');
      @ASN1_TIME_check:= LoadFuncCLibCrypto('ASN1_TIME_check');
      @ASN1_TIME_set_string:= LoadFuncCLibCrypto('ASN1_TIME_set_string');
      @ASN1_TIME_new:= LoadFuncCLibCrypto('ASN1_TIME_new');
      @ASN1_TIME_free:= LoadFuncCLibCrypto('ASN1_TIME_free');
      @ASN1_TIME_it:= LoadFuncCLibCrypto('ASN1_TIME_it');
      @ASN1_TIME_print:= LoadFuncCLibCrypto('ASN1_TIME_print');
      @ASN1_TIME_to_generalizedtime:= LoadFuncCLibCrypto('ASN1_TIME_to_generalizedtime');
      @i2d_ASN1_TIME:= LoadFuncCLibCrypto('i2d_ASN1_TIME');
      @d2i_ASN1_TIME:= LoadFuncCLibCrypto('d2i_ASN1_TIME');
                                
      @ASN1_UTCTIME_set:= LoadFuncCLibCrypto('ASN1_UTCTIME_set');
      @ASN1_UTCTIME_check:= LoadFuncCLibCrypto('ASN1_UTCTIME_check');
      @ASN1_UTCTIME_adj:= LoadFuncCLibCrypto('ASN1_UTCTIME_adj');
      @ASN1_UTCTIME_set_string:= LoadFuncCLibCrypto('ASN1_UTCTIME_set_string');
      @ASN1_UTCTIME_cmp_time_t:= LoadFuncCLibCrypto('ASN1_UTCTIME_cmp_time_t');
      @ASN1_UTCTIME_new:= LoadFuncCLibCrypto('ASN1_UTCTIME_new');
      @ASN1_UTCTIME_free:= LoadFuncCLibCrypto('ASN1_UTCTIME_free');
      @ASN1_UTCTIME_it:= LoadFuncCLibCrypto('ASN1_UTCTIME_it');
      @ASN1_UTCTIME_print:= LoadFuncCLibCrypto('ASN1_UTCTIME_print');
      @i2d_ASN1_UTCTIME:= LoadFuncCLibCrypto('i2d_ASN1_UTCTIME');
      @d2i_ASN1_UTCTIME:= LoadFuncCLibCrypto('d2i_ASN1_UTCTIME');

      @ASN1_UNIVERSALSTRING_to_string:= LoadFuncCLibCrypto('ASN1_UNIVERSALSTRING_to_string');
      @ASN1_UNIVERSALSTRING_new:= LoadFuncCLibCrypto('ASN1_UNIVERSALSTRING_new');
      @ASN1_UNIVERSALSTRING_free:= LoadFuncCLibCrypto('ASN1_UNIVERSALSTRING_free');
      @ASN1_UNIVERSALSTRING_it:= LoadFuncCLibCrypto('ASN1_UNIVERSALSTRING_it');
      @i2d_ASN1_UNIVERSALSTRING:= LoadFuncCLibCrypto('i2d_ASN1_UNIVERSALSTRING');
      @d2i_ASN1_UNIVERSALSTRING:= LoadFuncCLibCrypto('d2i_ASN1_UNIVERSALSTRING');
		
      @ASN1_UTF8STRING_new:= LoadFuncCLibCrypto('ASN1_UTF8STRING_new');
      @ASN1_UTF8STRING_free:= LoadFuncCLibCrypto('ASN1_UTF8STRING_free');
      @ASN1_UTF8STRING_it:= LoadFuncCLibCrypto('ASN1_UTF8STRING_it');
		
      @ASN1_VISIBLESTRING_new:= LoadFuncCLibCrypto('ASN1_VISIBLESTRING_new');
      @ASN1_VISIBLESTRING_free:= LoadFuncCLibCrypto('ASN1_VISIBLESTRING_free');
      @ASN1_VISIBLESTRING_it:= LoadFuncCLibCrypto('ASN1_VISIBLESTRING_it');
			
      @ASN1_add_oid_module:= LoadFuncCLibCrypto('ASN1_add_oid_module');
      @ASN1_bn_print:= LoadFuncCLibCrypto('ASN1_bn_print');
      @ASN1_check_infinite_end:= LoadFuncCLibCrypto('ASN1_check_infinite_end');
      @ASN1_const_check_infinite_end:= LoadFuncCLibCrypto('ASN1_const_check_infinite_end');
      @ASN1_digest:= LoadFuncCLibCrypto('ASN1_digest');
      @ASN1_dup:= LoadFuncCLibCrypto('ASN1_dup');
      @ASN1_generate_nconf:= LoadFuncCLibCrypto('ASN1_generate_nconf');
      @ASN1_generate_v3:= LoadFuncCLibCrypto('ASN1_generate_v3');
      @ASN1_get_object:= LoadFuncCLibCrypto('ASN1_get_object');
      @ASN1_i2d_bio:= LoadFuncCLibCrypto('ASN1_i2d_bio');
      @ASN1_i2d_fp:= LoadFuncCLibCrypto('ASN1_i2d_fp');
      @ASN1_item_d2i:= LoadFuncCLibCrypto('ASN1_item_d2i');
      @ASN1_item_d2i_bio:= LoadFuncCLibCrypto('ASN1_item_d2i_bio');
      @ASN1_item_d2i_fp:= LoadFuncCLibCrypto('ASN1_item_d2i_fp');
      @ASN1_item_digest:= LoadFuncCLibCrypto('ASN1_item_digest');
      @ASN1_item_dup:= LoadFuncCLibCrypto('ASN1_item_dup');
      @ASN1_item_ex_d2i:= LoadFuncCLibCrypto('ASN1_item_ex_d2i');
      @ASN1_item_ex_free:= LoadFuncCLibCrypto('ASN1_item_ex_free');
      @ASN1_item_ex_i2d:= LoadFuncCLibCrypto('ASN1_item_ex_i2d');
      @ASN1_item_ex_new:= LoadFuncCLibCrypto('ASN1_item_ex_new');
      @ASN1_item_free:= LoadFuncCLibCrypto('ASN1_item_free');
      @ASN1_item_i2d:= LoadFuncCLibCrypto('ASN1_item_i2d');
      @ASN1_item_i2d_bio:= LoadFuncCLibCrypto('ASN1_item_i2d_bio');
      @ASN1_item_i2d_fp:= LoadFuncCLibCrypto('ASN1_item_i2d_fp');
      @ASN1_item_ndef_i2d:= LoadFuncCLibCrypto('ASN1_item_ndef_i2d');
      @ASN1_item_new:= LoadFuncCLibCrypto('ASN1_item_new');
      @ASN1_item_pack:= LoadFuncCLibCrypto('ASN1_item_pack');
      @ASN1_item_print:= LoadFuncCLibCrypto('ASN1_item_print');
      @ASN1_item_sign:= LoadFuncCLibCrypto('ASN1_item_sign');
      @ASN1_item_sign_ctx:= LoadFuncCLibCrypto('ASN1_item_sign_ctx');
      @ASN1_item_unpack:= LoadFuncCLibCrypto('ASN1_item_unpack');
      @ASN1_item_verify:= LoadFuncCLibCrypto('ASN1_item_verify');
      @ASN1_mbstring_copy:= LoadFuncCLibCrypto('ASN1_mbstring_copy');
      @ASN1_mbstring_ncopy:= LoadFuncCLibCrypto('ASN1_mbstring_ncopy');
      @ASN1_object_size:= LoadFuncCLibCrypto('ASN1_object_size');
      @ASN1_pack_string:= LoadFuncCLibCrypto('ASN1_pack_string');
      @ASN1_parse:= LoadFuncCLibCrypto('ASN1_parse');
      @ASN1_parse_dump:= LoadFuncCLibCrypto('ASN1_parse_dump');
      @ASN1_primitive_free:= LoadFuncCLibCrypto('ASN1_primitive_free');
      @ASN1_primitive_new:= LoadFuncCLibCrypto('ASN1_primitive_new');
      @ASN1_put_eoc:= LoadFuncCLibCrypto('ASN1_put_eoc');
      @ASN1_put_object:= LoadFuncCLibCrypto('ASN1_put_object');
      @ASN1_unpack_string:= LoadFuncCLibCrypto('ASN1_unpack_string');
      @ASN1_verify:= LoadFuncCLibCrypto('ASN1_verify');
      @ASN1_sign:= LoadFuncCLibCrypto('ASN1_sign');
      @ASN1_seq_pack:= LoadFuncCLibCrypto('ASN1_seq_pack');
      @ASN1_tag2bit:= LoadFuncCLibCrypto('ASN1_tag2bit');
      @ASN1_tag2str:= LoadFuncCLibCrypto('ASN1_tag2str');
      @ASN1_template_d2i:= LoadFuncCLibCrypto('ASN1_template_d2i');
      @ASN1_template_free:= LoadFuncCLibCrypto('ASN1_template_free');
      @ASN1_template_i2d:= LoadFuncCLibCrypto('ASN1_template_i2d');
      @ASN1_template_new:= LoadFuncCLibCrypto('ASN1_template_new');

      @ASN1_d2i_bio:= LoadFuncCLibCrypto('ASN1_d2i_bio');
      @ASN1_d2i_fp:= LoadFuncCLibCrypto('ASN1_d2i_fp');


  end;
end;

function M_ASN1_STRING_length(x : PASN1_STRING): TC_INT; inline;
begin
  Result := x^.length;
end;

procedure M_ASN1_STRING_length_set(x : PASN1_STRING; n : TC_INT); inline;
begin
  x^.length := n;
end;

function M_ASN1_STRING_type(x : PASN1_STRING) : TC_INT; inline;
begin
  Result := x^._type;
end;

function M_ASN1_STRING_data(x : PASN1_STRING) : PAnsiChar; inline;
begin
  Result := x^.data;
end;


end.
