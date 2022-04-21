@echo off

IF NOT EXIST ./SDL2.dll ECHO "Put SDL dll in root of this directory"

if "%1" == "release" (
  mkdir ..\bin\sdl2_example\release
  cp .\SDL2.dll ..\bin\sdl2_example\release
  odin build main.odin -out:..\bin\sdl2_example\release\sdl2_example.exe -show-timings
  ..\bin\sdl2_example\release\sdl2_example.exe

) else (
  mkdir ..\bin\sdl2_example\debug
  cp .\SDL2.dll ..\bin\sdl2_example\release
  odin build main.odin -out:..\bin\sdl2_example\debug\sdl2_example.exe -debug -show-timings
  ..\bin\sdl2_example\debug\sdl2_example.exe
)
