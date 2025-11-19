for /f "tokens=*" %%i in ('dir /s /a /b
*.~*
*.dcu
*.ddp
*.stat
*.bkm

*.local
*.identcache
*.rsm
*.drc
*.vrc
*.tvsconfig

*.ncb
*.opt
*.aps
*.plg

*.sdf
*.suo
*.pdb
*.pch
*.tlog
*.exp

*.ipdb
*.ipch

*.VC.db

Thumbs.db'
) do ( attrib -s -h -r "%%i" 
          del /f /s /q "%%i" )

for /f "tokens=*" %%i in ('dir /a /s /b
__history
__recovery
.vs
ipch
') do rd /s /q "%%i"


:delete_path
rd /s /q "%~dp0__history"
rd /s /q "%~dp0__recovery"
rd /s /q "%~dp0.vs"
rd /s /q "%~dp0ipch"

if exist "%~dp0__history" goto delete_path
if exist "%~dp0__recovery" goto delete_path
if exist "%~dp0.vs" goto delete_path
if exist "%~dp0ipch" goto delete_path
