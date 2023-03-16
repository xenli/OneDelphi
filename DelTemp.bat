::删除D7中临时文件
Rem 删除Delphi临时文件,*.db,*.mb,
Rem ****************************
@dir/w/s *.~*,*.dcu
@echo 以上为当前目录及子目录临时文件,请按任意键确认删除!
@pause
@for /r . %%a in (.) do @if exist "%%a\*.~*" del "%%a\*.~*"
::@for /r . %%a in (.) do @if exist "%%a\*.db" del "%%a\*.db"
::@for /r . %%a in (.) do @if exist "%%a\*.mb" del "%%a\*.mb"
@for /r . %%a in (.) do @if exist "%%a\*.dcu" del "%%a\*.dcu"
@echo 删除成功!  
::删除D10中临时文件
del __recovery /s
del __history /s
pause