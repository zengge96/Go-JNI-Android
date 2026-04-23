cmake_minimum_required(VERSION 3.22.1)

SET(C_LIB native-lib)
SET(GO_LIB native-lib-go)

# Build Go library first using custom command
SET(GO_OUTPUT_DIR ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
SET(GO_SONAME lib${GO_LIB}.so)

# Custom command to build Go library
ADD_CUSTOM_COMMAND(
    OUTPUT ${GO_OUTPUT_DIR}/${GO_SONAME}
    COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/go/build.sh ${GO_OUTPUT_DIR} ${GO_SONAME} ${ANDROID_ARCH_NAME} ${ANDROID_C_COMPILER} ${ANDROID_TOOLCHAIN_ROOT} ${ANDROID_LLVM_TRIPLE} ${ANDROID_SYSROOT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/go
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/go/test.go
    COMMENT "Building Go library"
    VERBATIM
)

# Create imported library for Go
ADD_LIBRARY(${GO_LIB} SHARED IMPORTED)
SET_TARGET_PROPERTIES(${GO_LIB} PROPERTIES
    IMPORTED_LOCATION ${GO_OUTPUT_DIR}/${GO_SONAME}
)

# Add C library
ADD_library(${C_LIB} SHARED c_android.c)
ADD_DEPENDENCIES(${C_LIB} ${GO_LIB})

# Link libraries
find_library(log-lib log)
TARGET_LINK_LIBRARIES(${C_LIB} ${log-lib} ${GO_LIB})

# Also include the Go library in the APK
ADD_CUSTOM_TARGET(${GO_LIB}_all ALL
    DEPENDS ${GO_OUTPUT_DIR}/${GO_SONAME}
)
