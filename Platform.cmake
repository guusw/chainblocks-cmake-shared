# Note: Can't use PLATFORM global since it's used bit the ios-cmake toolchain file

if(IOS)
    if(PLATFORM MATCHES "SIMULATOR.*")
        set(X86_IOS_SIMULATOR ON)
    endif()
endif()

if(EMSCRIPTEN)
    set(_ARCH "wasm32")
    set(_OS "unknown")
    set(_ABI "emscripten")
elseif(WIN32)
    set(_PLATFORM "pc")
    set(_OS "windows")
elseif(UNIX AND NOT APPLE)
    set(_PLATFORM "pc")
    set(_OS "linux")
elseif(X86_IOS_SIMULATOR)
    set(_ARCH "x86_64")
    set(_OS "apple")
    set(_ABI "ios")
elseif(IOS)
    set(_ARCH "aarch64")
    set(_OS "apple")
    set(_ABI "ios")
elseif(APPLE)
    set(_PLATFORM "pc")
    set(_OS "apple")
else()
    set(_PLATFORM "unknown")
    set(_OS "unknown")
endif()

if(NOT _ARCH) 
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(_ARCH "x86")
    else()
        set(_ARCH "x86_64")
    endif()
endif()

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" AND "${CMAKE_CXX_SIMULATE_ID}" STREQUAL "MSVC")
    set(CLANG_MSVC ON)
endif()

set(LIB_PREFIX "lib")
if(CLANG_MSVC OR MSVC)
    set(LIB_PREFIX "")
    set(_ABI "msvc")
endif()

if(NOT _ABI)
    if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
        set(_ABI "gnu")
    else()
        set(_ABI "unknown")
    endif()
endif()

if(VALGRIND)
    set(_EXTRA_FLAGS ${_EXTRA_FLAGS} "valgrind")
endif()

set(TARGET_PARTS ${_ARCH} ${_PLATFORM} ${_OS} ${_ABI} ${_EXTRA_FLAGS})
list(JOIN TARGET_PARTS "-" TARGET_ID)
message(STATUS "TARGET_ID = ${TARGET_ID}")
