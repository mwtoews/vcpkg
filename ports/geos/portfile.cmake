set(GEOS_VERSION 3.7.3)

vcpkg_download_distfile(ARCHIVE
    URLS "http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2"
    FILENAME "geos-${GEOS_VERSION}.tar.bz2"
    SHA512 3799d36ed6a56f049446429a879cb06d59f2d0b5abd1810866f6c296fd534034bfbe61330928c6ee8728b47678133065b8057c4315666ae36a41eb4d1c98faf6
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${GEOS_VERSION}
    PATCHES geos_c-static-support.patch
)

# NOTE: GEOS provides CMake as optional build configuration, it might not be actively
# maintained, so CMake build issues may happen between releases.

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DEBUG_POSTFIX=d
        -DGEOS_ENABLE_TESTS=False
)
vcpkg_install_cmake()

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

if(EXISTS ${CURRENT_PACKAGES_DIR}/bin/geos-config)
    file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/geos)
    file(RENAME ${CURRENT_PACKAGES_DIR}/bin/geos-config ${CURRENT_PACKAGES_DIR}/share/geos/geos-config)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/geos-config)
endif()

# Handle copyright
configure_file(${SOURCE_PATH}/COPYING ${CURRENT_PACKAGES_DIR}/share/geos/copyright COPYONLY)

vcpkg_copy_pdbs()
