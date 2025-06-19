@echo off
echo Cleaning build directory...

REM Change this if your build folder is named differently
IF EXIST build (
    rmdir /s /q build
    echo Removed build directory.
) ELSE (
    echo Build directory does not exist.
)

echo Done.