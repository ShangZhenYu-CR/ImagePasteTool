@echo off
cd /d "%~dp0"
py tools\assemble_source.py
if errorlevel 1 (
  echo Source assembly failed.
  pause
  exit /b 1
)
start "" pyw image_paste_v2_3_6.pyw
