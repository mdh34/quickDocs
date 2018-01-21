# project name
    project (com.github.mdh34.quickdocs)

    # the oldest stable cmake version we support
    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.mdh34.quickdocs")

    set (EXEC_NAME "com.github.mdh34.quickdocs")
    set (RELEASE_NAME "")
    set (VERSION "1.1.1")
    set (VERSION_INFO "")
    set (DEPS_PKG
      gtk+-3.0
      webkit2gtk-4.0
    )
    # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED ${DEPS_PKG})

    add_definitions(${DEPS_CFLAGS})
    link_libraries(${DEPS_LIBRARIES})
    link_directories(${DEPS_LIBRARY_DIRS})

    # make sure we have vala
    find_package(Vala REQUIRED)
    # make sure we use vala
    include(ValaVersion)
    # make sure it's the desired version of vala
    ensure_vala_version("0.16" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/quickDocs.vala

    # tell what libraries to use when compiling
    PACKAGES
        gtk+-3.0
        webkit2gtk-4.0
    )

    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

    #install icons
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/16/com.github.mdh34.quickdocs.svg DESTINATION share/icons/hicolor/16x16/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/24/com.github.mdh34.quickdocs.svg DESTINATION share/icons/hicolor/24x24/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/com.github.mdh34.quickdocs.svg DESTINATION share/icons/hicolor/32x32/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/48/com.github.mdh34.quickdocs.svg DESTINATION share/icons/hicolor/48x48/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/com.github.mdh34.quickdocs.svg DESTINATION share/icons/hicolor/64x64/apps)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/com.github.mdh34.quickdocs.svg DESTINATION share/icons/hicolor/128x128/apps)

    # install gschema
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.mdh34.quickdocs.gschema.xml DESTINATION ${DATADIR}/glib-2.0/schemas/)
    install (CODE "execute_process (COMMAND glib-compile-schemas ${DATADIR}/glib-2.0/schemas/)")
    # install our .desktop file so the Applications menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.mdh34.quickdocs.desktop DESTINATION ${DATADIR}/applications/)

    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/offline.sh DESTINATION share/com.github.mdh34.quickdocs/)
    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.mdh34.quickdocs.appdata.xml DESTINATION ${DATADIR}/metainfo/)
