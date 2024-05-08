unit FormOpenSSL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    editOut: TMemo;
    Label3: TLabel;
    tbMD5: TButton;
    editIn: TMemo;
    tbBase64Encode: TButton;
    tbBase64Decode: TButton;
    tbMD4: TButton;
    tbFileMD5: TButton;
    OpenDialog1: TOpenDialog;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    edAesInput: TMemo;
    Label5: TLabel;
    edAeskyeLen: TComboBox;
    Label6: TLabel;
    edAesMode: TComboBox;
    edAesKey: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edAesIV: TEdit;
    tbAesEncode: TButton;
    tbAesDecode: TButton;
    Label9: TLabel;
    edAesOut: TMemo;
    Label10: TLabel;
    edAesPadding: TComboBox;
    procedure tbMD5Click(Sender: TObject);
    procedure tbMD4Click(Sender: TObject);
    procedure tbBase64EncodeClick(Sender: TObject);
    procedure tbBase64DecodeClick(Sender: TObject);
    procedure tbFileMD5Click(Sender: TObject);
    procedure tbAesEncodeClick(Sender: TObject);
    procedure tbAesDecodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


uses ssl_md5, ssl_md4, ssl_encode, ssl_const, ssl_types, ssl_aes;

procedure TForm1.tbAesDecodeClick(Sender: TObject);
var
  keyBytes, ivBytes, plainBytes, cipherBytes: TBytes;
  lastByteValue:integer;
  i: Integer;
  aesKey: AES_KEY;
  keyLen: Integer;
  plainLen, cipherLen, Padding: Integer;
  tempStr: string;
begin
  editOut.Lines.Clear;
  keyBytes := TEncoding.UTF8.GetBytes(edAesKey.Text);
  ivBytes := TEncoding.UTF8.GetBytes(edAesIV.Text);
  cipherLen := length(edAesInput.Text);
  if cipherLen = 0 then
  begin
    showMessage('请输入要解密的字符串');
    exit;
  end;
  //预设长度
  setLength(cipherBytes,cipherLen);
  //得到密文实际长度,HEX转byte
  cipherLen := HexToBin(PWideChar(edAesInput.Text),@cipherBytes[0],cipherLen);
  //重新设置长度
  setLength(cipherBytes,cipherLen);
  setLength(plainBytes,cipherLen);
  // 128位密钥长度
  keyLen := 128;
  if edAeskyeLen.Text = '192' then
  begin
    keyLen := 192;
    setLength(keyBytes, 24);
  end
  else
    if edAeskyeLen.Text = '256' then
  begin
    keyLen := 256;
    setLength(keyBytes, 32);
  end
  else
  begin
    keyLen := 128;
    setLength(keyBytes, 16);
  end;
  if length(ivBytes) = 0 then
  begin
    setLength(ivBytes, 1);
    ivBytes[0] := 0;
  end;

  AES_set_decrypt_key(@keyBytes[0], keyLen, @aesKey);
  if edAesMode.Text = 'ECB' then
  begin
    i := 0;
    while i <= cipherLen - 1 do
    begin
      AES_decrypt(@cipherBytes[i],@plainBytes[i], @aesKey);
      i := i + AES_BLOCK_SIZE;
    end;
  end
  else
  begin
     AES_cbc_encrypt(@cipherBytes[0],@plainBytes[0],
      cipherLen, @aesKey, @ivBytes[0], ssl_const.AES_DECRYPT);
  end;
  plainLen :=  cipherLen;
  lastByteValue := plainBytes[plainLen-1];
  //修正长度
  if(lastByteValue>0) and (lastByteValue<=AES_BLOCK_SIZE) then
  begin
    for i := plainLen - 1  downto plainLen - lastByteValue do
    begin
       if plainBytes[i] <> lastByteValue then
       begin
          showMessage('填充不一至');
       end;
    end;
    //修正长度
    setLength(plainBytes, plainLen-lastByteValue);
  end;

  edAesOut.Text :=  TEncoding.UTF8.GetString(plainBytes);

end;

procedure TForm1.tbAesEncodeClick(Sender: TObject);
var
  keyBytes, ivBytes, plainBytes, cipherBytes: TBytes;
  i: Integer;
  aesKey: AES_KEY;
  keyLen: Integer;
  plainLen, Padding: Integer;
  tempStr: string;
begin
  //
  editOut.Lines.Clear;
  keyBytes := TEncoding.UTF8.GetBytes(edAesKey.Text);
  ivBytes := TEncoding.UTF8.GetBytes(edAesIV.Text);
  plainBytes := TEncoding.UTF8.GetBytes(edAesInput.Text);
  if length(plainBytes) = 0 then
  begin
    showMessage('请输入要加密的字符串');
    exit;
  end;
  SSL_InitAES();
  //
  plainLen := length(plainBytes);
  Padding := AES_BLOCK_SIZE - (plainLen mod AES_BLOCK_SIZE); // 计算padding长度
  if (Padding > 0) and (Padding < AES_BLOCK_SIZE) then
  begin
    setLength(plainBytes, plainLen + Padding); // 扩展明文缓冲区以容纳padding
    if edAesPadding.Text = 'PKCS7' then
    begin
      plainBytes[plainLen] := Byte(Padding); // 假设使用PKCS#7 padding，最后一个字节表示padding长度
      for i := plainLen + 1 to length(plainBytes) - 1 do
      begin
        plainBytes[i] := plainBytes[length(plainBytes) - Padding]; // 填充padding
      end;
    end;
    plainLen := length(plainBytes); // 更新plainLen为包含padding的长度
  end;
  // 设置密文长度
  setLength(cipherBytes, plainLen);
  // 128位密钥长度
  keyLen := 128;
  if edAeskyeLen.Text = '192' then
  begin
    keyLen := 192;
    setLength(keyBytes, 24);
  end
  else
    if edAeskyeLen.Text = '256' then
  begin
    keyLen := 256;
    setLength(keyBytes, 32);
  end
  else
  begin
    keyLen := 128;
    setLength(keyBytes, 16);
  end;
  if length(ivBytes) = 0 then
  begin
    setLength(ivBytes, 1);
    ivBytes[0] := 0;
  end;

  AES_set_encrypt_key(@keyBytes[0], keyLen, @aesKey);
  if edAesMode.Text = 'ECB' then
  begin
    i := 0;
    while i <= plainLen - 1 do
    begin
      AES_ecb_encrypt(@plainBytes[i], @cipherBytes[i], @aesKey, ssl_const.AES_ENCRYPT);
      i := i + AES_BLOCK_SIZE;
    end;
  end
  else
  begin
    AES_cbc_encrypt(@plainBytes[0], @cipherBytes[0],
      plainLen, @aesKey, @ivBytes[0], ssl_const.AES_ENCRYPT);
  end;
  tempStr := '';
  for i := 0 to plainLen - 1 do
  begin
    tempStr := tempStr + IntToHex(cipherBytes[i], 2);
  end;
  edAesOut.Text := tempStr;
end;

procedure TForm1.tbBase64DecodeClick(Sender: TObject);
var
  InputBytes: TBytes;
  deCodedLength: Integer;
  deCodedData: TBytes;
  iOutLen: Integer;
begin
  editOut.Lines.Clear;
  SSL_InitEncode();
  InputBytes := TEncoding.UTF8.GetBytes(editIn.Text);
  if length(InputBytes) = 0 then
  begin
    showMessage('请输入要解密的字符串');
    exit;
  end;
  // 计算解码后数据的长度，直接和加码长度一样，肯定够用。懒得去算
  // 一般算长度反解码长度它还法,+50长度预防下
  // iOutLen := Length(InputBytes)*3 div 4+50;
  iOutLen := length(InputBytes);
  setLength(deCodedData, iOutLen);
  deCodedLength := EVP_DecodeBlock(@deCodedData[0], @InputBytes[0], length(InputBytes));
  // 分配缓冲区,进行栽减数据
  setLength(deCodedData, deCodedLength);
  // 进行编码
  editOut.Text := TEncoding.UTF8.GetString(deCodedData);
  // 也可以用下面方案要么用SetLength分配大小要么直接读长度
  // editOut.Text := TEncoding.UTF8.GetString(deCodedData, 0, deCodedLength);
end;

procedure TForm1.tbBase64EncodeClick(Sender: TObject);
var
  InputBytes: TBytes;
  EncodedLength: Integer;
  EncodedData: TBytes;
  iOutLen: Integer;
begin
  editOut.Lines.Clear;
  SSL_InitEncode();
  InputBytes := TEncoding.UTF8.GetBytes(editIn.Text);
  if length(InputBytes) = 0 then
  begin
    showMessage('请输入要加密的字符串');
    exit;
  end;
  // 计算编码后数据的长度
  iOutLen := (length(InputBytes) + 2) div 3 * 4;
  // 保险点预加50个长度
  iOutLen := iOutLen + 50;
  setLength(EncodedData, iOutLen);
  EncodedLength := EVP_EncodeBlock(@EncodedData[0], @InputBytes[0], length(InputBytes));
  // 分配缓冲区,进行栽减数据
  setLength(EncodedData, EncodedLength);
  // 进行编码
  editOut.Text := TEncoding.UTF8.GetString(EncodedData);
  // 也可以用下面方案要么用SetLength分配大小要么直接读长度
  // editOut.Text :=  TEncoding.UTF8.GetString(EncodedData,0,EncodedLength);
end;

procedure TForm1.tbFileMD5Click(Sender: TObject);
var
  lFileName: string;
  outByte: array [0 .. MD5_DIGEST_LENGTH - 1] of Byte;
  i: Integer;
  fileStream: TFileStream;
  mdContext: MD5_CTX;
  bytes: Integer;
  data: array [0 .. 1023] of Byte;
  tempStr: string;
begin
  if not OpenDialog1.Execute() then
    exit;
  editOut.Lines.Clear;
  SSL_InitMD5();
  lFileName := OpenDialog1.FileName;
  fileStream := TFileStream.Create(lFileName, fmOpenRead or fmShareDenyNone);
  try
    MD5_Init(@mdContext);
    repeat
      bytes := fileStream.Read(data, SizeOf(data));
      MD5_Update(@mdContext, @data, bytes);
    until bytes = 0;
    MD5_Final(@outByte, @mdContext);
    tempStr := '';
    for i := 0 to MD5_DIGEST_LENGTH - 1 do
    begin
      tempStr := tempStr + IntToHex(outByte[i], 2);
    end;
    editOut.Text := tempStr;
  finally
    fileStream.Free;
  end;
end;

procedure TForm1.tbMD4Click(Sender: TObject);
var
  InputBytes, MD5Result: TBytes;
  MD5Digest: array [0 .. 15] of Byte;
  i: Integer;
  tempStr: string;
begin
  SSL_InitMD4();
  editOut.Lines.Clear;
  InputBytes := TEncoding.UTF8.GetBytes(editIn.Text);
  if length(InputBytes) = 0 then
  begin
    showMessage('请输入要加密的字符串');
    exit;
  end;
  MD4(@InputBytes[0], length(InputBytes), @MD5Digest[0]);
  tempStr := '';
  for i := 0 to 15 do
  begin
    tempStr := tempStr + IntToHex(MD5Digest[i], 2);
  end;
  editOut.Text := tempStr;
end;

procedure TForm1.tbMD5Click(Sender: TObject);
var
  InputBytes, MD5Result: TBytes;
  MD5Digest: array [0 .. 15] of Byte;
  i: Integer;
  tempStr: string;
begin
  SSL_InitMD5();
  editOut.Lines.Clear;
  InputBytes := TEncoding.UTF8.GetBytes(editIn.Text);
  if length(InputBytes) = 0 then
  begin
    showMessage('请输入要加密的字符串');
    exit;
  end;
  MD5(@InputBytes[0], length(InputBytes), @MD5Digest[0]);
  tempStr := '';
  for i := 0 to 15 do
  begin
    tempStr := tempStr + IntToHex(MD5Digest[i], 2);
  end;
  editOut.Text := tempStr;
end;

end.
