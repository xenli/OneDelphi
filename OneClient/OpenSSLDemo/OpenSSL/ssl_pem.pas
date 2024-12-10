unit ssl_pem;

interface
uses ssl_typepointers;

var
  PEM_read_PUBKEY: function (var fp: FILE; x: pointer; cb: pointer; u: pointer): PTEVP_PKEY; cdecl = nil;
procedure SSL_InitPEM;

implementation
uses ssl_lib;

procedure SSL_InitPEM;
begin
  if @PEM_read_PUBKEY = nil then
  begin
    @PEM_read_PUBKEY := LoadFuncCLibCrypto('PEM_read_PUBKEY');
  end;
end;

end.
