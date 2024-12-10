unit ssl_sm3;

interface

uses ssl_types, SysUtils,ssl_typepointers;

const
  SM3_DIGEST_LENGTH = 32;
  SM3_CBLOCK = 64;
  SM3_LBLOCK = 16;

type
  SM3_WORD = Cardinal;

  PSM3_CTX = ^SM3_CTX;

  SM3_CTX = record
    A, B, C, D, E, F, G, H: SM3_WORD;
    Nl, Nh: SM3_WORD;
    data: array [0 .. SM3_LBLOCK - 1] of SM3_WORD; // 假设SM3_LBLOCK是常量或已知的数组长度
    num: Integer; // 将unsigned int转换为Integer，因为Pascal没有unsigned int
  end;
var
 EVP_sm3: function():PTEVP_MD;cdecl=nil;

function SM3Encrypt(inputs: TBytes; var outPut: TBytes): boolean;
procedure SSL_InitSM3;

implementation

uses ssl_lib, ssl_evpmdctx, ssl_evp;

procedure SSL_InitSM3;
begin
  if @EVP_sm3=nil then
  begin
    @EVP_sm3  := LoadFuncCLibCrypto('EVP_sm3');
  end;
  SSL_InitEVP();
  SSL_InitEVPMDCTX();
end;

function SM3Encrypt(inputs: TBytes; var outPut: TBytes): boolean;
var
  lMDCTXPoint, lSM3MdPoint: Pointer;
  cipherBytes: TBytes;
  outLen: TC_INT;
begin
  Result := false;
  lMDCTXPoint := nil;
  lSM3MdPoint := nil;
  outLen := 0;
  setLength(outPut, SM3_DIGEST_LENGTH);
  lMDCTXPoint := EVP_MD_CTX_new();
  if lMDCTXPoint = nil then
    exit;
  lSM3MdPoint := EVP_sm3();
  if lSM3MdPoint = nil then
    exit;
  try
    EVP_DigestInit_ex(lMDCTXPoint, lSM3MdPoint, nil);
    EVP_DigestUpdate(lMDCTXPoint, inputs, length(inputs));
    EVP_DigestFinal_ex(lMDCTXPoint, @outPut[0], nil);
    Result := true;
  finally
    EVP_MD_CTX_free(lMDCTXPoint);
  end;
end;

end.
