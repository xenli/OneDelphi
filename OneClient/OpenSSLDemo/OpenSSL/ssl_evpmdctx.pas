unit ssl_evpmdctx;

interface

uses ssl_types,ssl_typepointers;

var
  EVP_MD_CTX_md_data: function(const ctx: PTEVP_MD_CTX): Pointer; cdecl=nil;
  EVP_MD_CTX_new: function():PTEVP_MD_CTX;cdecl=nil;
  EVP_MD_CTX_free:procedure(ctx:PTEVP_MD_CTX);cdecl=nil;

procedure SSL_InitEVPMDCTX;

implementation
uses ssl_lib;
procedure SSL_InitEVPMDCTX;
begin
  if @EVP_MD_CTX_md_data = nil then
  begin
    @EVP_MD_CTX_md_data := LoadFuncCLibCrypto('EVP_MD_CTX_md_data');
    @EVP_MD_CTX_new := LoadFuncCLibCrypto('EVP_MD_CTX_new');
    @EVP_MD_CTX_free := LoadFuncCLibCrypto('EVP_MD_CTX_free');
  end;
end;
end.
