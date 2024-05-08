unit ssl_sm4;

interface
const SM4_KEY_SCHEDULE=32;
type
  PSM4_KEY = ^SM4_KEY;
  SM4_KEY = record
    rk: array[0..SM4_KEY_SCHEDULE-1] of Cardinal; // Cardinal通常对应于C中的uint32_t
  end;
var
  SM4_set_key:function (key: PByte; ks: PSM4_KEY): Integer; cdecl = nil;
  SM4_encrypt:procedure (inData: PByte; outData: PByte; ks: PSM4_KEY); cdecl = nil;
  SM4_decrypt:procedure (inData: PByte; outData: PByte; ks: PSM4_KEY); cdecl = nil;

procedure SSL_InitSM4;
implementation
uses ssl_lib;
procedure SSL_InitSM4;
begin
  if @SM4_set_key = nil then
  begin
    @SM4_set_key := LoadFunctionCLib('SM4_set_key');
    @SM4_encrypt := LoadFunctionCLib('SM4_encrypt');
    @SM4_decrypt := LoadFunctionCLib('SM4_decrypt');
  end;
end;
end.
