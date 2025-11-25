cmake_minimum_required(VERSION 3.10)
#set(ProjectName ficha)

project(BaseProject VERSION 0.1.1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20)

### DEPS ###
        # So ImGui-SFML can find ImGui...
        set(IMGUI_DIR ${PROJECT_SOURCE_DIR}/deps/imgui)

        # SFML
        add_subdirectory(${PROJECT_SOURCE_DIR}/deps/SFML)

        # Disable find_package for SFML since we're building it as subdirectory
        set(IMGUI_SFML_FIND_SFML OFF)

        # IMGUI-SFML
        add_subdirectory(${PROJECT_SOURCE_DIR}/deps/imgui-sfml)

        # GLFW
        set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "Disable GLFW examples")
        set(GLFW_BUILD_TESTS OFF CACHE BOOL "Disable GLFW tests")
        set(GLFW_BUILD_DOCS OFF CACHE BOOL "Disable GLFW docs")

        # Glfw, glad, OpenGL
        add_subdirectory(${PROJECT_SOURCE_DIR}/deps/glfw)
        add_subdirectory(${PROJECT_SOURCE_DIR}/deps/glad)
        find_package(OpenGL REQUIRED)
### End DEPS ###

#Search for all projects in the projects folder
file(GLOB CHILD_PROJECTS RELATIVE ${PROJECT_SOURCE_DIR}/projects ${PROJECT_SOURCE_DIR}/projects/*)

foreach(PROJECT ${CHILD_PROJECTS})
        set(PROJECT_NAME ${PROJECT})
        set(PROJECT_INCLUDE_DIRS "")

        # Incluir configuración del proyecto
        include("${PROJECT_SOURCE_DIR}/projects/${PROJECT}/project_config.cmake")

        # Gather source and header files
        file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/*.cpp"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/*.cc"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/*.c")
                
        file(GLOB_RECURSE INC_FILES CONFIGURE_DEPENDS
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/*.h"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/*.hpp")

        # Create executable for each project
        add_executable(${PROJECT_NAME} ${SRC_FILES} ${INC_FILES})

        # Include directories for each project
        if(PROJECT_INCLUDE_DIRS)
                target_include_directories(${PROJECT_NAME} PRIVATE 
                        ${PROJECT_INCLUDE_DIRS}
                        )
        endif()

        set(PROJECT_LIBS "")  # clean
        if(USE_SFML) # SFML
                target_include_directories(${PROJECT_NAME} PRIVATE
                        "${PROJECT_SOURCE_DIR}/deps/SFML/include"
                )
                list(APPEND PROJECT_LIBS sfml-graphics sfml-window sfml-system)
        endif()

        if(USE_IMGUI_SFML) # IMGUI
                list(APPEND PROJECT_LIBS ImGui-SFML)
        endif()

        if(USE_GLFW)
              list(APPEND PROJECT_LIBS glfw)  
        endif()

        if(USE_OPENGL)
              list(APPEND PROJECT_LIBS glad OpenGL::GL)  
        endif()     

        # Linkear solo si hay algo
        if(PROJECT_LIBS)
                target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_LIBS})
        endif()
endforeach()

