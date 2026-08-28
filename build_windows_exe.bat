@echo off
setlocal
cd /d "%~dp0"

where py >nul 2>nul
if errorlevel 1 (
  echo.
  echo [ERROR] Building the EXE requires Python on THIS build PC only.
  echo The finished dist\ImagePasteTool.exe does NOT require Python.
  echo.
  pause
  exit /b 1
)

py -m pip install --upgrade pip
py -m pip install -r requirements.txt pyinstaller

py -m PyInstaller ^
  --noconfirm ^
  --clean ^
  --onefile ^
  --windowed ^
  --name ImagePasteTool ^
  --collect-all pystray ^
  --collect-all pywinauto ^
  --hidden-import pystray._win32 ^
  --hidden-import PIL.ImageTk ^
  image_paste_v2_3_6.pyw

echo.
echo Finished:
echo %~dp0dist\ImagePasteTool.exe
echo The target PC does NOT need Python.
pause
