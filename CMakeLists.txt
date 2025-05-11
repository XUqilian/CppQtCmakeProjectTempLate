# 本文件用于简单配置 C++ QT 项目的模板
# by XUqilian

# CMake 最低版本要求
cmake_minimum_required(VERSION 3.20)

### 用户配置开始 ###
### 请根据实际情况修改以下变量 ###
set(USER_PROJECT_NAME "CppQtCmakeProjectTempLate")         # 可执行文件名
set(USER_C_STANDARD 11)                  # 使用的 C 标准（例如 90, 99, 11, 17）
set(USER_CXX_STANDARD 17)                # 使用的 C++ 标准（例如 11, 14, 17, 20）

set(USER_SOURCES_FILES
    main.h
    main.cpp
    MainView.h
    MainView.cpp
    MainView.ui
)                                        # 源文件列表  可不设置，依赖自动收集
set(USER_UI_FILES MainView.ui )          # UI 文件列表  可不设置，依赖自动收集
set(USER_QRC_FILES)                      # 资源文件列表  可不设置，依赖自动收集
set(USER_MOC_HEADERS)                    # MOC 文件列表  可不设置，依赖自动收集

set(USER_QT_MODULES Widgets)             # 使用的 Qt 模块（如 Widgets、Core、Gui 等）
set(USER_EXTRA_LIBS "")                  # 其他需要链接的库（如 ws2_32）

# 请在你需要的时候设置它 用于指定当前QT构建套件，防止多个构建套件冲突
# set(QT_BASE_DIR "$ENV{QT_BASE_DIR}")                    # 可设置为系统的环境变量 QT_BASE_DIR (名称可根据环境变量名修改)
# set(QT_BASE_DIR "D:/Code/QT/6.8.0/msvc2022_64")        # 也可以指定特定位置

### 用户配置结束 谢谢！ ###

# 请注意！！！以下内容无特殊需求无需修改 

# 检查必须定义的变量是否存在
foreach(var IN ITEMS
    USER_PROJECT_NAME
    USER_C_STANDARD
    USER_CXX_STANDARD
    USER_QT_MODULES
    USER_EXTRA_LIBS
)
    if(NOT DEFINED ${var})
        message(FATAL_ERROR
            "Required variable '${var}' is not defined. "
            "Please check your configuration before proceeding."
        )
    endif()
endforeach()

# 设置项目名称和语言
project(${USER_PROJECT_NAME} VERSION 0.1 LANGUAGES C CXX)

# 设置模块路径（Cmake构建模块组件目录）
set(CMAKE_MODULE_DIR "${CMAKE_SOURCE_DIR}/cmake")

# 全局设置
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 默认 C/C++ 标准
set(CMAKE_C_STANDARD ${USER_C_STANDARD})
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD ${USER_CXX_STANDARD})
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 启用策略 CMP0141（MSVC 调试格式）
if(POLICY CMP0141)
    cmake_policy(SET CMP0141 NEW)
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT
        "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>"
    )
endif()

# 非宽容模式（MSVC）
if(MSVC)
    add_compile_options(/permissive- /Zc:__cplusplus)
endif()

# 如果没设置，则使用默认CMAKE_PREFIX_PATH的路径 查找 Qt6 或 Qt5
if(NOT QT_BASE_DIR OR NOT EXISTS "${QT_BASE_DIR}")
    message(STATUS "QT_BASE_DIR is empty or invalid. Falling back to system-wide Qt detection.")
    find_package(Qt6 COMPONENTS ${USER_QT_MODULES} QUIET)
else()
    message(STATUS "Using custom Qt base directory: ${QT_BASE_DIR}")
    list(APPEND CMAKE_PREFIX_PATH "${QT_BASE_DIR}")
    find_package(Qt6 COMPONENTS ${USER_QT_MODULES} QUIET PATHS "${QT_BASE_DIR}")
endif()

if(Qt6_FOUND)
    set(QT_VERSION_MAJOR 6)
    message(STATUS "Found Qt6 at: ${Qt6_DIR}")
else()
    find_package(Qt5 COMPONENTS ${USER_QT_MODULES} QUIET)
    if(Qt5_FOUND)
        set(QT_VERSION_MAJOR 5)
        message(STATUS "Found Qt5 at: ${Qt5_DIR}")
    else()
        message(FATAL_ERROR "Neither Qt6 nor Qt5 (with ${USER_QT_MODULES} module) could be found.")
    endif()
endif()

# 提取全局 .cpp 文件并处理
if(NOT USER_SOURCES_FILES)
    file(GLOB_RECURSE SOURCES_FILES "*.[cC]" "*.[cC][pP][pP]")
else()
    set(SOURCES_FILES ${USER_SOURCES_FILES})
endif()

# 提取全局 .ui 文件并处理 UI 文件
if(NOT USER_UI_FILES)
    file(GLOB_RECURSE UI_FILES "*.ui")
else()
    set(UI_FILES ${USER_UI_FILES})
endif()

# 提取全局 .qrc 文件并处理 QRC 文件
if(NOT USER_QRC_FILES)
    file(GLOB_RECURSE QRC_FILES "*.qrc")
else()
    set(QRC_FILES ${USER_QRC_FILES})
endif()

# 提取全局 .h 文件并处理 MOC 文件
if(NOT USER_MOC_HEADERS)
    file(GLOB_RECURSE MOC_HEADERS "*.[hH]" "*.[hH][pP][pP]")
else()
    set(MOC_HEADERS ${USER_MOC_HEADERS})
endif()

# 根据 Qt 版本选择合适的 wrap_ui 命令
if(Qt6_FOUND)
    qt6_wrap_ui(UI_HEADERS ${UI_FILES})
    qt6_add_resources(QRC_SRCS ${QRC_FILES})
    qt6_wrap_cpp(MOC_SRCS ${MOC_HEADERS})
elseif(Qt5_FOUND)
    qt5_wrap_ui(UI_HEADERS ${UI_FILES})
    qt5_add_resources(QRC_SRCS ${QRC_FILES})
    qt5_wrap_cpp(MOC_SRCS ${MOC_HEADERS})
else()
    message(FATAL_ERROR "Qt not found. Cannot process UI, resource files or enable MOC.")
endif()

# 创建可执行文件
add_executable(${USER_PROJECT_NAME}
    ${SOURCES_FILES}      # 实际的 .cpp 文件
    ${QRC_SRCS}           # 资源生成的 .cpp 文件
    ${MOC_SRCS}           # MOC 生成的 .cpp 文件
    ${UI_FILES}           # UI 生成的 .h 文件
)

# 设置 C/C++ 标准
target_compile_features(${USER_PROJECT_NAME} PRIVATE cxx_std_${USER_CXX_STANDARD} c_std_${USER_C_STANDARD})

# 包含目录
target_include_directories(${USER_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

# 链接 Qt 模块和其他库
if(USER_QT_MODULES)
    foreach(module IN LISTS USER_QT_MODULES)
        if(Qt6_FOUND)
            if(TARGET Qt6::${module})
                target_link_libraries(${USER_PROJECT_NAME} PRIVATE Qt6::${module})
            else()
                message(WARNING "Qt6 module '${module}' not found. Skipped.")
            endif()
        elseif(Qt5_FOUND)
            if(TARGET Qt5::${module})
                target_link_libraries(${USER_PROJECT_NAME} PRIVATE Qt5::${module})
            else()
                message(WARNING "Qt5 module '${module}' not found. Skipped.")
            endif()
        endif()
    endforeach()
endif()

# 如果有额外的库需要链接
if(USER_EXTRA_LIBS)
    target_link_libraries(${USER_PROJECT_NAME} ${USER_EXTRA_LIBS})
endif()

# 包含 DeployQt.cmake
if(NOT EXISTS "${CMAKE_MODULE_DIR}/DeployQt.cmake")
    message(FATAL_ERROR "Could not find DeployQt.cmake in the directory CMAKE_MODULE_DIR:${CMAKE_MODULE_DIR}.")
endif()
include(cmake/DeployQt.cmake)

# 调用 deploy_qt 函数   添加运行依赖
deploy_qt(${USER_PROJECT_NAME})