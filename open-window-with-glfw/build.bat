@echo off

IF NOT EXIST ./glfw3.dll ECHO "Put GLFW dll in root of this directory"

if "%1" == "release" (
  mkdir ..\bin\glfw_example\release
  cp .\glfw3.dll ..\bin\glfw_example\release
  odin build main.odin -out:..\bin\glfw_example\release\glfw_example.exe -show-timings
  ..\bin\glfw_example\release\glfw_example.exe

) else (
  mkdir ..\bin\glfw_example\debug
  cp .\glfw3.dll ..\bin\glfw_example\release
  odin build main.odin -out:..\bin\glfw_example\debug\glfw_example.exe -debug -show-timings
  ..\bin\glfw_example\debug\glfw_example.exe
)
