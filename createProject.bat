
@echo off
setlocal enabledelayedexpansion

:createProject
set /p PROJECT_NAME=Enter project name: 
set "PROJECTS_DIR=projects"

if exist "%PROJECTS_DIR%\%PROJECT_NAME%" (
    echo Project "%PROJECT_NAME%" already exists.
    choice /C YN /M "Create a different project?"

    REM No selected
    if errorlevel 2 (
        exit /b 1
    )

    REM Yes selected
    if errorlevel 1 (
        goto :createProject
    )
)
echo Generating "%PROJECT_NAME%"...
REM Create the projects directory if it doesn't exist
if not exist "%PROJECTS_DIR%" (
    mkdir "%PROJECTS_DIR%"
)
mkdir "%PROJECTS_DIR%\%PROJECT_NAME%"
mkdir "%PROJECTS_DIR%\%PROJECT_NAME%\src"
mkdir "%PROJECTS_DIR%\%PROJECT_NAME%\include"
REM CREATE THE MAIN CPP FILE
set "PROJECT_MAIN=%PROJECTS_DIR%\%PROJECT_NAME%\src\%PROJECT_NAME%.cpp"
> "%PROJECT_MAIN%" (
    echo #include ^<iostream^>
    echo.
    echo int main^(^) {
    echo     std::cout ^<^< "Hello world %PROJECT_NAME%!";
    echo     return 0;
    echo }
)

if exist "%PROJECT_MAIN%" (
    echo Project main file created at "%PROJECT_MAIN%"
) else (
    echo Failed to create project main file.
)

REM CREATE THE CONFIG FILE
set "PROJECT_CONFIG_FILE=%PROJECTS_DIR%\%PROJECT_NAME%\project_config.cmake"
> "%PROJECT_CONFIG_FILE%" (
    echo # Project configuration for %PROJECT_NAME%
    echo set^(USE_SFML ON^)
    echo set^(USE_IMGUI_SFML ON^)
)

if exist "%PROJECT_CONFIG_FILE%" (
    echo Project configuration file created at "%PROJECT_CONFIG_FILE%"
) else (
    echo Failed to create project configuration file.
)

choice /C YN /M "Create another project?"
  REM No selected
  if errorlevel 2 (
      exit /b 1
  )

  REM Yes selected
  if errorlevel 1 (
      goto :createProject
  )

