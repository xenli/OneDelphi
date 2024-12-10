unit ssl_comp;
interface
uses ssl_types;
var
    COMP_CTX_new: function(meth: PCOMP_METHOD): PCOMP_CTX; cdecl = nil;
    COMP_CTX_free: procedure(ctx: PCOMP_CTX); cdecl = nil;
    COMP_compress_block: function(ctx: PCOMP_CTX; _out: PAnsiChar; olen: TC_INT;_in: PAnsiChar; ilen: TC_INT): TC_INT; cdecl = nil;
    COMP_expand_block:function(ctx: PCOMP_CTX; _out: PAnsiChar; olen: TC_INT;_in: PAnsiChar; ilen: TC_INT): TC_INT; cdecl = nil;
    COMP_rle: function: PCOMP_METHOD; cdecl = nil;
    COMP_zlib: function: PCOMP_METHOD; cdecl = nil;
    COMP_zlib_cleanup: procedure; cdecl = nil;
    BIO_f_zlib: function: PBIO_METHOD; cdecl = nil;

procedure SSL_InitCOMP;
    
implementation
uses ssl_lib;

procedure SSL_InitCOMP;
begin
  if @COMP_CTX_new = nil then
  begin
    @COMP_CTX_new:= LoadFuncCLibCrypto('COMP_CTX_new');
    @COMP_CTX_free:= LoadFuncCLibCrypto('COMP_CTX_free');
    @COMP_compress_block:= LoadFuncCLibCrypto('COMP_compress_block');
    @COMP_expand_block:= LoadFuncCLibCrypto('COMP_expand_block');
    @COMP_rle:= LoadFuncCLibCrypto('COMP_rle');
    @COMP_zlib:= LoadFuncCLibCrypto('COMP_zlib');
    @COMP_zlib_cleanup:= LoadFuncCLibCrypto('COMP_zlib_cleanup');
    @BIO_f_zlib:= LoadFuncCLibCrypto('BIO_f_zlib', false);
  end;
end;

end.