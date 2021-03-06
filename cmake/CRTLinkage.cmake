if(NOT MSVC)
  message(FATAL_ERROR "CRT options are available only for MSVC")
endif()

# Ignore warning: This object file does not define any previously undefined public symbols, ...
set(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} /IGNORE:4221")

if(NOT BUILD_SHARED_LIBS AND BUILD_WITH_STATIC_CRT)
  foreach(flag_var
          CMAKE_Fortran_FLAGS CMAKE_Fortran_FLAGS_DEBUG CMAKE_Fortran_FLAGS_RELEASE
          CMAKE_Fortran_FLAGS_MINSIZEREL CMAKE_Fortran_FLAGS_RELWITHDEBINFO)
    if (${flag_var} MATCHES "/libs:dll")
      string (REGEX REPLACE "/libs:dll" "/libs:static" ${flag_var} "${${flag_var}}")
    endif()
  endforeach(flag_var)
else()
  foreach(flag_var
          CMAKE_Fortran_FLAGS CMAKE_Fortran_FLAGS_DEBUG CMAKE_Fortran_FLAGS_RELEASE
          CMAKE_Fortran_FLAGS_MINSIZEREL CMAKE_Fortran_FLAGS_RELWITHDEBINFO)
    if (${flag_var} MATCHES "/libs:static")
      string (REGEX REPLACE "/libs:static" "/libs:dll" ${flag_var} "${${flag_var}}")
    endif()
  endforeach(flag_var)
endif()

if(CMAKE_VERSION VERSION_GREATER "2.8.6")
  include(ProcessorCount)
  ProcessorCount(NN)
  math(EXPR N "${NN}/2")
  if(NOT N EQUAL 0)
    MESSAGE(STATUS "Using half of the processors to compiling: ${N}")
    SET(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   /MP${N} ")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /MP${N} ")
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} /MP${N} ")
    LIST(REMOVE_DUPLICATES CMAKE_C_FLAGS)
    LIST(REMOVE_DUPLICATES CMAKE_CXX_FLAGS)
    LIST(REMOVE_DUPLICATES CMAKE_Fortran_FLAGS)
  endif()
endif()

if(NOT BUILD_WITH_DEBUG_INFO AND NOT MSVC)
  string(REPLACE "/debug" "" CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/DEBUG" "" CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/INCREMENTAL:YES" "/INCREMENTAL:NO" CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/INCREMENTAL " "/INCREMENTAL:NO " CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG}")

  string(REPLACE "/debug" "" CMAKE_MODULE_LINKER_FLAGS_DEBUG "${CMAKE_MODULE_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/DEBUG" "" CMAKE_MODULE_LINKER_FLAGS_DEBUG "${CMAKE_MODULE_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/INCREMENTAL:YES" "/INCREMENTAL:NO" CMAKE_MODULE_LINKER_FLAGS_DEBUG "${CMAKE_MODULE_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/INCREMENTAL " "/INCREMENTAL:NO " CMAKE_MODULE_LINKER_FLAGS_DEBUG "${CMAKE_MODULE_LINKER_FLAGS_DEBUG}")

  string(REPLACE "/debug" "" CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/DEBUG" "" CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/INCREMENTAL:YES" "/INCREMENTAL:NO" CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
  string(REPLACE "/INCREMENTAL " "/INCREMENTAL:NO " CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")

  string(REPLACE "/Zi" "" CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
  string(REPLACE "/Zi" "" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
endif()
