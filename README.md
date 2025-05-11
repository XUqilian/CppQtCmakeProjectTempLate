# CppQtCmakeProjectTempLate
<<<<<<< HEAD
CppQtCmakeProjectTempLate 是一个基于 CMake 构建系统的 C/C++ Qt 项目模板，旨在简化 Qt 应用程序的开发和部署流程。
=======

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

CppQtCmakeProjectTempLate 是一个基于 CMake 构建系统的 C/C++ Qt 项目模板，旨在简化 Qt 应用程序的开发和部署流程。

## 目录结构

```bash
CppQtCmakeProjectTempLate/
├── CMakeLists.txt
├── LICENSE
├── README.md
├── main.cpp
├── main.h
├── MainView.cpp
├── MainView.h
└── MainView.ui
```


## 安装与构建

### Prerequisites

- CMake 3.14 或更高版本
- Qt 5 或 Qt 6
- GCC 或 Clang 编译器（Linux）
- MSVC 编译器（Windows，默认）
- [MinGW](https://www.mingw-w64.org/) 或 [MSYS2](https://www.msys2.org/)（如果希望在 Windows 上使用 GCC）

### 获取项目

```bash
git clone https://github.com/XUqilian/CppQtCmakeProjectTempLate.git
cd CppQtCmakeProjectTempLate
```

### 构建项目

#### Linux 和 macOS

```bash
mkdir build && cd build
cmake ..
make
Windows
cmd
```

#### Windows (使用 MSVC)

```bash
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019"
cmake --build .
```

#### Windows (使用 MinGW)

首先，确保 MinGW 或 MSYS2 已正确安装并且其 bin 目录已添加到系统的 PATH 环境变量中。

然后，可以使用如下命令来构建项目：

```cmd
mkdir build
cd build
cmake .. -G "MinGW Makefiles" -DCMAKE_MAKE_PROGRAM=mingw32-make
mingw32-make
```

如果你使用的是 MSYS2，请确保你已经安装了 mingw-w64-x86_64-toolchain 包，并使用相应的 make 命令：

```bash
pacman -S mingw-w64-x86_64-toolchain
mkdir build
cd build
cmake .. -G "MSYS Makefiles"
make
```

## 使用说明

自动部署 Qt 依赖
在构建过程中，CMake 脚本会自动调用 windeployqt（Windows）、macdeployqt（macOS）或自定义的 patchelf（Linux）来部署所需的 Qt 依赖项，您需要根据实际情况配置该工具。

### 配置选项

你可以通过设置以下变量来自定义项目配置：

```bash
USER_PROJECT_NAME: 可执行文件名，默认为 CppQtCmakeProjectTempLate
USER_C_STANDARD: 使用的 C 标准，默认为 11
USER_CXX_STANDARD: 使用的 C++ 标准，默认为 17
USER_QT_MODULES: 使用的 Qt 模块列表，默认为 Widgets
USER_EXTRA_LIBS: 其他需要链接的库，默认为空字符串
```

例如，在命令行中指定这些变量：

```bash
cmake .. -DUSER_PROJECT_NAME=MyApp -DUSER_C_STANDARD=17 -DUSER_CXX_STANDARD=20 -DUSER_QT_MODULES="Widgets;Network" -DUSER_EXTRA_LIBS="ws2_32"
```

### 贡献指南
欢迎任何形式的贡献！请先 fork 本项目并在本地进行修改，然后提交 pull request。

### Fork 仓库

```bash
创建新分支 (git checkout -b feature/AmazingFeature)
提交更改 (git commit -m 'Add some AmazingFeature')
推送到分支 (git push origin feature/AmazingFeature)
打开 Pull Request
```

### 许可证

该项目采用 MIT 许可证，请参阅 LICENSE 文件了解更多信息。
>>>>>>> 7395de8 (first commit)
