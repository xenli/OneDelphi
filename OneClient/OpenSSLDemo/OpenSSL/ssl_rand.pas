unit ssl_rand;
interface
uses ssl_types;
var 
    RAND_set_rand_method: function(const meth: PRAND_METHOD): TC_INT; cdecl = nil;
    RAND_get_rand_method: function: PRAND_METHOD; cdecl = nil;
    RAND_set_rand_engine: function(engine: PENGINE): TC_INT; cdecl = nil;
    RAND_SSLeay: function: PRAND_METHOD; cdecl = nil;
    RAND_cleanup: procedure; cdecl = nil;
    RAND_bytes: function(buf: PAnsiChar; num: TC_INT): TC_INT; cdecl = nil;
    RAND_pseudo_bytes: function(buf: PAnsiChar; num: TC_INT): TC_INT; cdecl = nil;
    RAND_seed: procedure(buf: Pointer; num: TC_INT); cdecl = nil;
    RAND_add: procedure(buf: Pointer; num: TC_INT; entropy: double); cdecl = nil;
    RAND_load_file: function(_file: PAnsiChar; max_bytes: TC_LONG): TC_INT; cdecl = nil;
    RAND_write_file: function(_file: PAnsiChar): TC_INT; cdecl = nil;
    RAND_file_name: function(_file: PAnsiChar; num: TC_size_t ): PAnsiChar; cdecl = nil;
    RAND_status: function: TC_INT; cdecl = nil;
    RAND_query_egd_bytes: function(path: PAnsiChar; buf: PAnsiChar; bytes: TC_INT): TC_INT; cdecl = nil;
    RAND_egd: function(path: PAnsiChar): TC_INT; cdecl = nil;
    RAND_egd_bytes: function(path: PAnsiChar; bytes: TC_INT): TC_INT; cdecl = nil;
    RAND_poll: function: TC_INT; cdecl = nil;

    RAND_screen: procedure; cdecl;
//int RAND_event(UINT, WPARAM, LPARAM);

    RAND_set_fips_drbg_type: procedure(_type: TC_INT; flags: TC_INT); cdecl = nil;
    RAND_init_fips: function: TC_INT; cdecl = nil;
    ERR_load_RAND_strings: procedure; cdecl = nil;

procedure SSL_InitRAND; 
    
implementation
uses ssl_lib;

procedure SSL_InitRAND;
begin
  if @RAND_set_rand_method = nil then
   begin 
    @RAND_set_rand_method:= LoadFuncCLibCrypto('RAND_set_rand_method');
    @RAND_get_rand_method:= LoadFuncCLibCrypto('RAND_get_rand_method');
    @RAND_set_rand_engine:= LoadFuncCLibCrypto('RAND_set_rand_engine');
    @RAND_SSLeay:= LoadFuncCLibCrypto('RAND_SSLeay');
    @RAND_cleanup:= LoadFuncCLibCrypto('RAND_cleanup');
    @RAND_bytes:= LoadFuncCLibCrypto('RAND_bytes');
    @RAND_pseudo_bytes:= LoadFuncCLibCrypto('RAND_pseudo_bytes');
    @RAND_seed:= LoadFuncCLibCrypto('RAND_seed');
    @RAND_add:= LoadFuncCLibCrypto('RAND_add');
    @RAND_load_file:= LoadFuncCLibCrypto('RAND_load_file');
    @RAND_write_file:= LoadFuncCLibCrypto('RAND_write_file');
    @RAND_file_name:= LoadFuncCLibCrypto('RAND_file_name');
    @RAND_status:= LoadFuncCLibCrypto('RAND_status');
    @RAND_query_egd_bytes:= LoadFuncCLibCrypto('RAND_query_egd_bytes');
    @RAND_egd:= LoadFuncCLibCrypto('RAND_egd');
    @RAND_egd_bytes:= LoadFuncCLibCrypto('RAND_egd_bytes');
    @RAND_poll:= LoadFuncCLibCrypto('RAND_poll');
    @RAND_screen:= LoadFuncCLibCrypto('RAND_screen');
    @RAND_set_fips_drbg_type:= LoadFuncCLibCrypto('RAND_set_fips_drbg_type', false);
    @RAND_init_fips:= LoadFuncCLibCrypto('RAND_init_fips', false);
    @ERR_load_RAND_strings:= LoadFuncCLibCrypto('ERR_load_RAND_strings');
   end;   
end;

end.
