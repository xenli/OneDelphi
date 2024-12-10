unit ssl_sm2;

interface
uses ssl_types,ssl_typepointers, SysUtils,math;

function SM2Encrypt(input: TBytes;publicKeyFile:string; var outPut: TBytes): boolean;

procedure SSL_InitSM2;
implementation
uses ssl_evppkey,ssl_pem;
procedure SSL_InitSM2;
begin
  SSL_InitEVP_PKEY();
  SSL_InitPEM();
end;
function SM2Encrypt(input: TBytes;publicKeyFile:string; var outPut: TBytes): boolean;
var
  iFileHand:integer;
  pub_key_file: File;
  pub_key: PTEVP_PKEY;
  ctx:PTEVP_PKEY_CTX;
  iInLen,iOutLen:Cardinal;
  tempI:Integer;
begin
  Result := false;
  ctx :=nil;
  AssignFile(pub_key_file, publicKeyFile);
  Reset(pub_key_file);
  try
    pub_key := PEM_read_PUBKEY(pub_key_file, nil, nil, nil);
    if pub_key=nil then
    begin
      raise Exception.Create('pub_key_file fail');
      exit;
    end;
    ctx := EVP_PKEY_CTX_new(pub_key, nil);
    if ctx=nil then
    begin
      raise Exception.Create('EVP_PKEY_CTX_new fail');
      exit;
    end;
    
    tempI := EVP_PKEY_encrypt_init(ctx);
    if tempI<=0 then
    begin
      raise Exception.Create('EVP_PKEY_encrypt_init fail');
      exit;
    end;
    iInLen := length(input);
    iOutLen := 0;
    tempI := EVP_PKEY_encrypt(ctx,@outPut[0],@iOutLen,@input[0],iInLen);
    if tempI<=0 then
    begin
       raise Exception.Create('EVP_PKEY_encrypt fail');
      exit;
    end;
    Result := true;
  finally
    if ctx<>nil then
     EVP_PKEY_CTX_free(ctx);
    Close(pub_key_file);
  end;
end;
end.
