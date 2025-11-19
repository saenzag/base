cmake_minimum_required(VERSION 3.10)
#set(ProjectName ficha)

project(BaseProject VERSION 0.1.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20)

# So ImGui-SFML can find ImGui...
set(IMGUI_DIR ${PROJECT_SOURCE_DIR}/deps/imgui)

# SFML
add_subdirectory(${PROJECT_SOURCE_DIR}/deps/SFML)

# Disable find_package for SFML since we're building it as subdirectory
set(IMGUI_SFML_FIND_SFML OFF)

# IMGUI-SFML
add_subdirectory(${PROJECT_SOURCE_DIR}/deps/imgui-sfml)

#Search for all projects in the projects folder
file(GLOB CHILD_PROJECTS RELATIVE ${PROJECT_SOURCE_DIR}/projects ${PROJECT_SOURCE_DIR}/projects/*)

foreach(PROJECT ${CHILD_PROJECTS})
        set(PROJECT_NAME ${PROJECT})

        # Incluir configuración del proyecto
        include("${PROJECT_SOURCE_DIR}/projects/${PROJECT}/project_config.cmake")

        # Gather source and header files
        file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/src/*.cpp"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/src/*.cc"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/src/*.c")
                
        file(GLOB_RECURSE INC_FILES CONFIGURE_DEPENDS
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/include/*.h"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/include/*.hpp")

        # Create executable for each project
        add_executable(${PROJECT_NAME} ${SRC_FILES} ${INC_FILES})

        # Include directories for each project
        target_include_directories(${PROJECT_NAME} PRIVATE
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/include"
        )

        set(PROJECT_LIBS "")  # limpiamos
        if(USE_SFML) # SFML
                target_include_directories(${PROJECT_NAME} PRIVATE
                        "${PROJECT_SOURCE_DIR}/deps/SFML/include"
                )
                list(APPEND PROJECT_LIBS sfml-graphics sfml-window sfml-system)
        endif()

        if(USE_IMGUI_SFML) # IMGUI
                list(APPEND PROJECT_LIBS ImGui-SFML)
        endif()

        # Linkear solo si hay algo
        if(PROJECT_LIBS)
                target_link_libraries(${PROJECT_NAME} ${PROJECT_LIBS})
        endif()
        #TODO: adjust what libraries are linked per project if needed
        #target_link_libraries(${PROJECT_NAME} sfml-graphics sfml-window sfml-system ImGui-SFML)
endforeach()

