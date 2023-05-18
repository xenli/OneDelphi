Rem Delete Delphi tmp,*.db,*.mb,
Rem ****************************
@dir/w/s *.~*,*.dcu
@echo The above is the current directory and subdirectory temporary files, please press any key to confirm deletion!
@pause
@for /r . %%a in (.) do @if exist "%%a\*.~*" del "%%a\*.~*"
@for /r . %%a in (.) do @if exist "%%a\*.dcu" del "%%a\*.dcu"
::@for /r . %%a in (.) do @if exist "%%a\*.db" del "%%a\*.db"
::@for /r . %%a in (.) do @if exist "%%a\*.mb" del "%%a\*.mb"

::删除D10中临时文件
@for /r . %%a in (__history) do  @if exist "%%a" rd /s /q "%%a" 
@for /r . %%a in (__recovery) do  @if exist "%%a" rd /s /q "%%a" 
@echo successfully delete!
