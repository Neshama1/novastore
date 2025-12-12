remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_STRICT_ITERATORS -DQT_NO_CAST_FROM_BYTEARRAY -DQT_NO_URL_CAST_FROM_STRING)

# CREATE AND FINALIZES AN APPLICATION TARGET BIN/NOVASTORE (CMAKE TARGET + LINK QT CORE + HANDLE FINALIZATION)

qt_add_executable(${PROJECT_NAME}
    main.cpp
	code/appbackend.cpp
	code/async.cpp
	code/repodata.cpp
	code/systeminfo.cpp
	qml.qrc
    assets.qrc)

# DEFINE QML MODULE: LINK TO THE BACKING TARGET. THERE WILL BE NO PLUGIN ADDING THE NO_PLUGIN OPTION.

qt_add_qml_module(${PROJECT_NAME} URI org.kde.novastore
    NO_PLUGIN
    QML_FILES
    main.qml
	controls/Details.qml
	controls/Home.qml
	controls/Search.qml
	controls/Applications.qml
	controls/Packages.qml
	controls/Requires.qml
	controls/Provides.qml
	controls/Password.qml
	controls/Management.qml)

# ADD PREPROCESSOR DEFINITIONS (MACROS) SUCH AS DEBUG, RELEASE OR MY_VERSION TO THE APP TARGET

target_compile_definitions(${PROJECT_NAME}
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

# ADD COMPILE OPTIONS SUCH AS: -Wall, -Wextra, -g or std=c++17

# target_compile_options(${PROJECT_NAME} PRIVATE -fexceptions)

# SPECIFY LIBRARIES LINKED TO GIVEN TARGET BIN/NOVASTORE

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit4
    MauiKit4::FileBrowsing
    MauiMan4
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Quick
    Qt6::Qml
	Qt6::Xml
	Qt6::Core5Compat
    KF6::I18n
    KF6::CoreAddons
    KF6::ConfigCore
    Plasma
    PlasmaQuick)

# FILES TO BE INSTALLED

install(FILES data/project.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR} RENAME ${PROJECT_URI}.appdata.xml)
install(FILES data/project.desktop DESTINATION ${KDE_INSTALL_APPDIR} RENAME ${PROJECT_URI}.desktop)
install(FILES assets/logo.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps RENAME ${PROJECT_NAME}.svg)
