cmake_minimum_required(VERSION 3.21)
project(BlueSkyPRO_HMI VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

set_source_files_properties(qml/Theme.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_executable(appBlueSkyPRO
    src/main.cpp
)

qt_add_qml_module(appBlueSkyPRO
    URI BlueSky.PRO
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/Theme.qml
)

target_link_libraries(appBlueSkyPRO PRIVATE Qt6::Quick)

set_target_properties(appBlueSkyPRO PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)
