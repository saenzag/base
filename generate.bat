
@echo off
setlocal enabledelayedexpansion

set "BUILD_DIR=build"
:: Ensure build directory exists
if not exist "%BUILD_DIR%" (
    mkdir "%BUILD_DIR%"
)

:: Configurable Paths
set "PROJECTS_DIR=projects"
set "BUILD_DIR=build"
set "VSCODE_DIR=.vscode"
set "OUTPUT_LAUNCH_FILE=%VSCODE_DIR%\launch.json"
set "OUTPUT_TASKS_FILE=%VSCODE_DIR%\tasks.json"
::set "MIMODE=cppvsdbg" :: Use "gdb" formigw, "lldb" for macos/wsl"

:: Ensure .vscode directory exists
if not exist "%VSCODE_DIR%" (
    mkdir "%VSCODE_DIR%"
)

:: Ensure projects directory exists
if not exist "%PROJECTS_DIR%" (
    mkdir "%PROJECTS_DIR%"
)

:: Start JSON file
(
    echo {
    echo     "version": "0.2.0",
    echo     "configurations": [
) > "%OUTPUT_LAUNCH_FILE%"

set "FIRST=true"

:: Let's go through each project
for /d %%D in (%PROJECTS_DIR%\*) do (
    set "PROJECT_NAME=%%~nxD"
    if not "!FIRST!"== "true" (
        echo , >> "%OUTPUT_LAUNCH_FILE%"
    )
    set "FIRST=false"

    (
        echo        {
        echo            "name": "Debug !PROJECT_NAME!",
        echo            "type": "cppvsdbg",
        echo            "request": "launch",
        echo            "program": "${workspaceFolder}/%BUILD_DIR%/Debug/!PROJECT_NAME!.exe",
        echo            "args": [],
        echo            "stopAtEntry": false,
        echo            "cwd": "${workspaceFolder}",
        echo            "environment": [],
        echo            "console": "integratedTerminal", // internalConsole, externalTerminal
        echo            "preLaunchTask": "build !PROJECT_NAME! Debug",
        echo        },
    ) >> "%OUTPUT_LAUNCH_FILE%"

    (
        echo        {
        echo            "name": "Release !PROJECT_NAME!",
        echo            "type": "cppvsdbg",
        echo            "request": "launch",
        echo            "program": "${workspaceFolder}/%BUILD_DIR%/Release/!PROJECT_NAME!.exe",
        echo            "args": [],
        echo            "stopAtEntry": false,
        echo            "cwd": "${workspaceFolder}",
        echo            "environment": [],
        echo            "console": "integratedTerminal", // internalConsole, externalTerminal
        echo            "preLaunchTask": "build !PROJECT_NAME! Release",
        echo        }
    ) >> "%OUTPUT_LAUNCH_FILE%"
)

:: End JSON file
(
    echo     ]
    echo }
) >> "%OUTPUT_LAUNCH_FILE%"

echo Generated %OUTPUT_LAUNCH_FILE% successfully.

:: TASKS

:: Start JSON file
(
    echo {
    echo     "version": "2.0.0",
    echo     "tasks": [
    echo     {
    echo         "label": "cmake configure",
    echo         "type": "shell",
    echo         "command": "cmake",
    echo         "args": ["-S", ".", "-B", "build"],//"-G", "Visual Studio 17 2022", "-A", "x64"
    echo         "group": "build",
    echo         "problemMatcher": []
    echo     }
    echo     ,
    echo     {
    echo         "label": "cmake build",
    echo         "type": "shell",
    echo         "command": "cmake",
    echo         "args": ["--build", "build"],
    echo         "group": "build",
    echo         "dependsOn": "cmake configure",
    echo         "problemMatcher": []
    echo     }
) > "%OUTPUT_TASKS_FILE%"

for /d %%D in (%PROJECTS_DIR%\*) do (
    set "PROJECT_NAME=%%~nxD"
    (
        echo     ,
        echo     {
        echo         "label": "build !PROJECT_NAME! Debug",
        echo         "type": "shell",
        echo         "command": "cmake",
        echo         "args": ["--build", "build", "--target", "!PROJECT_NAME!"],
        echo         "group": "build",
        echo         "problemMatcher": []
        echo     }
        
    ) >> "%OUTPUT_TASKS_FILE%"

    (
        echo     ,
        echo     {
        echo         "label": "build !PROJECT_NAME! Release",
        echo         "type": "shell",
        echo         "command": "cmake",
        echo         "args": ["--build", "build", "--config", "Release", "--target", "!PROJECT_NAME!"],
        echo         "group": "build",
        echo         "problemMatcher": []
        echo     }
        
    ) >> "%OUTPUT_TASKS_FILE%"
)

(
    echo    ]
    echo }
) >> "%OUTPUT_TASKS_FILE%"

echo Generated %OUTPUT_TASKS_FILE% successfully.

echo Configuring CMAKE
cmake -S . -B build

echo Building CMAKE
cmake --build build

pause
