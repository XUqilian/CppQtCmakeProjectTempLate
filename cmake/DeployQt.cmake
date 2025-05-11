# DeployQt.cmake
# 用于部署Qt依赖
# by XUqilain

# 依赖
# windows & mac 需要 windeployqt
# linux 需要 patchelf

function(deploy_qt target)
    if(Qt6_FOUND)
        get_target_property(QT_BIN_DIR Qt6::qmake IMPORTED_LOCATION)
    elseif(Qt5_FOUND)
        get_target_property(QT_BIN_DIR Qt5::qmake IMPORTED_LOCATION)
    else()
        message(WARNING "Qt is not found. Skipping deployment step.")
        return()
    endif()

    if(QT_BIN_DIR)
        get_filename_component(QT_BIN_DIR ${QT_BIN_DIR} DIRECTORY)

        if(WIN32 AND NOT MSYS)
            if(EXISTS "${QT_BIN_DIR}/windeployqt.exe")
                add_custom_command(TARGET ${target} POST_BUILD
                    COMMAND "${QT_BIN_DIR}/windeployqt.exe" "$<TARGET_FILE:${target}>" --no-translations --no-opengl-sw
                    COMMENT "Deploying Qt dependencies with windeployqt"
                )
            else()
                message(WARNING "windeployqt.exe not found in Qt bin directory. Skipping deployment step.")
            endif()
        elseif(APPLE) # macOS
            if(EXISTS "${QT_BIN_DIR}/macdeployqt")
                add_custom_command(TARGET ${target} POST_BUILD
                    COMMAND "${QT_BIN_DIR}/macdeployqt" "$<TARGET_FILE_DIR:${target}>"
                    COMMENT "Deploying Qt dependencies with macdeployqt"
                )
            else()
                message(WARNING "macdeployqt not found in Qt bin directory. Skipping deployment step.")
            endif()
        elseif(UNIX) # Linux
            # Find the required Qt libraries and plugins
            find_program(PATCHELF_EXECUTABLE patchelf)
            if(NOT PATCHELF_EXECUTABLE)
                message(WARNING "patchelf not found. Skipping deployment step.")
                return()
            endif()

            # Get the list of Qt libraries used by the target
            execute_process(
                COMMAND ldd "$<TARGET_FILE:${target}>"
                OUTPUT_VARIABLE LDD_OUTPUT
            )

            string(REGEX MATCHALL "(libQt[0-9]+[^ ]*\\.[0-9]+)" QT_LIBS "${LDD_OUTPUT}")

            # Copy each Qt library to the target's directory and update its rpath
            foreach(lib IN LISTS QT_LIBS)
                get_filename_component(LIB_NAME ${lib} NAME)
                file(COPY ${lib} DESTINATION "$<TARGET_FILE_DIR:${target}>")
                add_custom_command(TARGET ${target} POST_BUILD
                    COMMAND ${PATCHELF_EXECUTABLE} --set-rpath '$ORIGIN' "$<TARGET_FILE_DIR:${target}>/${LIB_NAME}"
                    COMMENT "Setting rpath for ${LIB_NAME}"
                )
            endforeach()

            # Deploy Qt plugins (optional, based on your application needs)
            set(QT_PLUGINS_PATH "${QT_BIN_DIR}/../plugins")
            if(EXISTS "${QT_PLUGINS_PATH}")
                file(GLOB_RECURSE QT_PLUGINS LIST_DIRECTORIES false "${QT_PLUGINS_PATH}/*.so")
                foreach(plugin IN LISTS QT_PLUGINS)
                    get_filename_component(PLUGIN_NAME ${plugin} NAME)
                    file(COPY ${plugin} DESTINATION "$<TARGET_FILE_DIR:${target}>/plugins/${PLUGIN_NAME}")
                endforeach()
            endif()

            message(STATUS "Linux deployment completed.")
        endif()
    else()
        message(WARNING "Could not find qmake executable for deployment tools.")
    endif()
endfunction()