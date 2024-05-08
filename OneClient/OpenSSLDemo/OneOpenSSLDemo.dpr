﻿program OneOpenSSLDemo;

uses
  Vcl.Forms,
  FormOpenSSL in 'FormOpenSSL.pas' {Form1},
  ssl_aes in 'OpenSSL\ssl_aes.pas',
  ssl_asn in 'OpenSSL\ssl_asn.pas',
  ssl_bf in 'OpenSSL\ssl_bf.pas',
  ssl_bio in 'OpenSSL\ssl_bio.pas',
  ssl_bn in 'OpenSSL\ssl_bn.pas',
  ssl_buffer in 'OpenSSL\ssl_buffer.pas',
  ssl_camellia in 'OpenSSL\ssl_camellia.pas',
  ssl_cast in 'OpenSSL\ssl_cast.pas',
  ssl_cmac in 'OpenSSL\ssl_cmac.pas',
  ssl_cms in 'OpenSSL\ssl_cms.pas',
  ssl_comp in 'OpenSSL\ssl_comp.pas',
  ssl_conf in 'OpenSSL\ssl_conf.pas',
  ssl_const in 'OpenSSL\ssl_const.pas',
  ssl_des in 'OpenSSL\ssl_des.pas',
  ssl_dh in 'OpenSSL\ssl_dh.pas',
  ssl_dsa in 'OpenSSL\ssl_dsa.pas',
  ssl_ec in 'OpenSSL\ssl_ec.pas',
  ssl_ecdh in 'OpenSSL\ssl_ecdh.pas',
  ssl_ecdsa in 'OpenSSL\ssl_ecdsa.pas',
  ssl_engine in 'OpenSSL\ssl_engine.pas',
  ssl_err in 'OpenSSL\ssl_err.pas',
  ssl_evp in 'OpenSSL\ssl_evp.pas',
  ssl_hmac in 'OpenSSL\ssl_hmac.pas',
  ssl_idea in 'OpenSSL\ssl_idea.pas',
  ssl_init in 'OpenSSL\ssl_init.pas',
  ssl_lhash in 'OpenSSL\ssl_lhash.pas',
  ssl_lib in 'OpenSSL\ssl_lib.pas',
  ssl_md4 in 'OpenSSL\ssl_md4.pas',
  ssl_md5 in 'OpenSSL\ssl_md5.pas',
  ssl_mdc2 in 'OpenSSL\ssl_mdc2.pas',
  ssl_obj_id in 'OpenSSL\ssl_obj_id.pas',
  ssl_objects in 'OpenSSL\ssl_objects.pas',
  ssl_ocsp in 'OpenSSL\ssl_ocsp.pas',
  ssl_pem in 'OpenSSL\ssl_pem.pas',
  ssl_pkcs7 in 'OpenSSL\ssl_pkcs7.pas',
  ssl_pkcs12 in 'OpenSSL\ssl_pkcs12.pas',
  ssl_rand in 'OpenSSL\ssl_rand.pas',
  ssl_rc2 in 'OpenSSL\ssl_rc2.pas',
  ssl_rc4 in 'OpenSSL\ssl_rc4.pas',
  ssl_rc5 in 'OpenSSL\ssl_rc5.pas',
  ssl_ripemd in 'OpenSSL\ssl_ripemd.pas',
  ssl_rsa in 'OpenSSL\ssl_rsa.pas',
  ssl_sha in 'OpenSSL\ssl_sha.pas',
  ssl_sk in 'OpenSSL\ssl_sk.pas',
  ssl_types in 'OpenSSL\ssl_types.pas',
  ssl_util in 'OpenSSL\ssl_util.pas',
  ssl_x509 in 'OpenSSL\ssl_x509.pas',
  ssl_encode in 'OpenSSL\ssl_encode.pas',
  ssl_sm4 in 'OpenSSL\ssl_sm4.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
