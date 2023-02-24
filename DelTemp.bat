::刪除D7中臨時文件
Rem 刪除Delphi臨時文件,*.db,*.mb,
Rem ****************************
@dir/w/s *.~*,*.dcu
@echo 以上為當前目錄及子目錄臨時文件,請按任意鍵確認刪除!
@pause
@for /r . %%a in (.) do @if exist "%%a\*.~*" del "%%a\*.~*"
::@for /r . %%a in (.) do @if exist "%%a\*.db" del "%%a\*.db"
::@for /r . %%a in (.) do @if exist "%%a\*.mb" del "%%a\*.mb"
@for /r . %%a in (.) do @if exist "%%a\*.dcu" del "%%a\*.dcu"
@echo 刪除成功!
::刪除D10中臨時文件
del /s/f/q __history


