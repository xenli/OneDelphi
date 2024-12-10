unit ssl_sm4;

interface
uses ssl_types,ssl_typepointers, SysUtils,math;

const SM4_KEY_SCHEDULE=32;
type
  PSM4_KEY = ^SM4_KEY;
  SM4_KEY = record
    rk: array[0..SM4_KEY_SCHEDULE-1] of Cardinal; // Cardinal通常对应于C中的uint32_t
  end;

  sm4_encrypt_mode = (CBC,ECB);
  sm4_padding_mode = (PKCS7,ZERO);
var
 EVP_sm4_ctr: function():PTEVP_CIPHER;cdecl=nil;
 EVP_sm4_ecb: function():PTEVP_CIPHER;cdecl=nil;
 EVP_sm4_cbc: function():PTEVP_CIPHER;cdecl=nil;
 EVP_sm4_cfb128: function():PTEVP_CIPHER;cdecl=nil;
 EVP_sm4_ofb: function():PTEVP_CIPHER;cdecl=nil;


function SM4Encrypt(inputs: TBytes;key:TBytes;iv:TBytes;var outPut: TBytes;
  encryptMode:sm4_encrypt_mode=sm4_encrypt_mode.CBC;paddingMode:sm4_padding_mode=sm4_padding_mode.PKCS7
  ): boolean;
function SM4Decrypt(inputs: TBytes;key:TBytes;iv:TBytes;var outPut: TBytes;
  encryptMode:sm4_encrypt_mode=sm4_encrypt_mode.CBC): boolean;

procedure SSL_InitSM4;
implementation
uses ssl_lib,ssl_evp;
procedure SSL_InitSM4;
begin
  if @EVP_sm4_ctr=nil then
  begin
    @EVP_sm4_ctr  := LoadFuncCLibCrypto('EVP_sm4_ctr');
    @EVP_sm4_ecb  := LoadFuncCLibCrypto('EVP_sm4_ecb');
    @EVP_sm4_cbc  := LoadFuncCLibCrypto('EVP_sm4_cbc');
    @EVP_sm4_cfb128  := LoadFuncCLibCrypto('EVP_sm4_cfb128');
    @EVP_sm4_ofb  := LoadFuncCLibCrypto('EVP_sm4_ofb');
  end;
  SSL_InitEVP();
end;
function SM4Encrypt(inputs: TBytes; key: TBytes; iv: TBytes; var outPut: TBytes;
  encryptMode: sm4_encrypt_mode = sm4_encrypt_mode.CBC; paddingMode: sm4_padding_mode = sm4_padding_mode.PKCS7
  ): boolean;
var
  ctx, evpSM4: Pointer;
  outLen, outLen2: Integer;
  iInLen: Integer;
  temI: Integer;
begin
  Result := false;
  ctx := nil;
  evpSM4 := nil;
  outLen := 0;
  outLen2 := 0;
  setLength(key, 16);
  setLength(iv, 16);
  iInLen := length(inputs);
  ctx := EVP_CIPHER_CTX_new();
  try
    if encryptMode = sm4_encrypt_mode.ECB then
    begin
      evpSM4 := EVP_sm4_ecb();
    end
    else
    begin
      evpSM4 := EVP_sm4_cbc();
    end;
    outLen := Ceil(EVP_CIPHER_block_size(evpSM4) * ((iInLen + EVP_CIPHER_block_size(evpSM4) - 1) / EVP_CIPHER_block_size(evpSM4) + 1));
    // 分配大一点预防
    setLength(outPut, outLen + 100);
    //
    temI := EVP_EncryptInit_ex(ctx, evpSM4, nil, @key[0], @iv[0]);
    if temI <> 1 then
    begin
      raise Exception.Create('EVP_EncryptInit_ex fail');
      exit;
    end;
    // 关闭填充
    if (paddingMode = sm4_padding_mode.PKCS7) then
    begin
      EVP_CIPHER_CTX_set_padding(ctx, 1);
    end
    else
    begin
      EVP_CIPHER_CTX_set_padding(ctx, 0);
    end;
    // 获取加密后数据的长度
    outLen := 0;
    temI := EVP_EncryptUpdate(ctx, @outPut[0], @outLen, @inputs[0], iInLen);
    if temI <> 1 then
    begin
      raise Exception.Create('EVP_EncryptUpdate fail');
      exit;
    end;
    // 完成加密
    temI := EVP_EncryptFinal_ex(ctx, @outPut[outLen], @outLen2);
    if temI <> 1 then
    begin
      raise Exception.Create('EVP_EncryptFinal_ex fail');
      exit;
    end;
    setLength(outPut, outLen + outLen2);
    Result := true;
  finally
    EVP_CIPHER_CTX_free(ctx);
  end;
end;

function SM4Decrypt(inputs: TBytes; key: TBytes; iv: TBytes; var outPut: TBytes;
  encryptMode: sm4_encrypt_mode = sm4_encrypt_mode.CBC): boolean;
var
  ctx, evpSM4: Pointer;
  outLen, outLen2,paddingLen: Integer;
  iInLen: Integer;
  temI,i: Integer;
begin
  Result := false;
  ctx := nil;
  evpSM4 := nil;
  outLen := 0;
  outLen2 := 0;
  setLength(key, 16);
  setLength(iv, 16);
  iInLen := length(inputs);
  ctx := EVP_CIPHER_CTX_new();
  try
    if encryptMode = sm4_encrypt_mode.ECB then
    begin
      evpSM4 := EVP_sm4_ecb();
    end
    else
    begin
      evpSM4 := EVP_sm4_cbc();
    end;
    // 分配大一点预防
    setLength(outPut, iInLen);
    //
    temI := EVP_DecryptInit_ex(ctx, evpSM4, nil, @key[0], @iv[0]);
    if temI <> 1 then
    begin
      raise Exception.Create('EVP_DecryptInit_ex fail');
      exit;
    end;
    // 获取加密后数据的长度
    outLen := iInLen;
    temI := EVP_DecryptUpdate(ctx, @outPut[0], @outLen, @inputs[0], iInLen);
    if temI <> 1 then
    begin
      raise Exception.Create('EVP_DecryptUpdate fail');
      exit;
    end;
    // 完成加密
    temI := EVP_DecryptFinal_ex(ctx, @outPut[outLen], @outLen2);
    if temI <> 1 then
    begin
      raise Exception.Create('EVP_DecryptFinal_ex fail');
      exit;
    end;
    outLen := outLen+outLen2;
        // 去除PKCS7填充
     // 检查PKCS7填充
    if (outLen > 0) and (outPut[outLen - 1] <= 16) and (outPut[outLen - 1] > 0) then
    begin
      paddingLen := outPut[outLen - 1];
      for i := 1 to paddingLen do
      begin
        if outPut[outLen - paddingLen + i] <> paddingLen then
        begin
          raise Exception.Create('Invalid padding detected');
        end;
      end;
      outLen := outLen - paddingLen;
    end;

    setLength(outPut, outLen);
    Result := true;
  finally
    EVP_CIPHER_CTX_free(ctx);
  end;

end;

end.
