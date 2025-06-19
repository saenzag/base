cmake_minimum_required(VERSION 3.10)
#set(ProjectName ficha)
project(BaseProject VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)

# Include directory
include_directories(
        #${PROJECT_SOURCE_DIR}/include # we'll do this per project
        #${PROJECT_SOURCE_DIR}/src
        ${PROJECT_SOURCE_DIR}/deps/SFML/include
)

#Search for all projects in the projects folder
file(GLOB CHILD_PROJECTS RELATIVE ${PROJECT_SOURCE_DIR}/projects ${PROJECT_SOURCE_DIR}/projects/*)

foreach(PROJECT ${CHILD_PROJECTS})
        set(PROJECT_NAME ${PROJECT})

        file(GLOB_RECURSE SRC_FILES CONFIGURE_DEPENDS
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/src/*.cpp"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/src/*.cc"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/src/*.c")
                
        file(GLOB_RECURSE INC_FILES CONFIGURE_DEPENDS
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/include/*.h"
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/include/*.hpp")

        add_executable(${PROJECT_NAME} ${SRC_FILES} ${INC_FILES})

        target_include_directories(${PROJECT_NAME} PRIVATE
                "${PROJECT_SOURCE_DIR}/projects/${PROJECT}/include"
        )

        target_link_libraries(${PROJECT_NAME} sfml-graphics sfml-window sfml-system ImGui-SFML)
endforeach()


# SFML
add_subdirectory(${PROJECT_SOURCE_DIR}/deps/SFML)

# IMGUI-SFML
add_subdirectory(${PROJECT_SOURCE_DIR}/deps/imgui-sfml)

# Make sure imgui-sfml can find SFML Headers
#target_include_directories(ImGui-SFML PUBLIC ${PROJECT_SOURCE_DIR}/deps/SFML/include)

#include(FetchContent)
#FetchContent_Declare(
#        SFML
#        GIT_REPOSITORY https://github.com/SFML/SFML.git
#        GIT_TAG        2.6.0 # or any other latest stable version
#)
#FetchContent_MakeAvailable(SFML)
# !SFML

#file(GLOB_RECURSE all_SRCS
#        "${PROJECT_SOURCE_DIR}/projects/*.h"
#        "${PROJECT_SOURCE_DIR}/projects/*.hpp"
#        "${PROJECT_SOURCE_DIR}/projects/*.cpp"
#        "${PROJECT_SOURCE_DIR}/projects/*.cc"
#        "${PROJECT_SOURCE_DIR}/projects/*.c"
#        )

# Add the executable
#add_executable(${ProjectName} ${all_SRCS})

#target_link_libraries(${ProjectName} sfml-graphics sfml-window sfml-system ImGui-SFML)
