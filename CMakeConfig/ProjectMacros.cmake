set(CCDHCPSERVER_CMAKECONFIG_DIR ${CMAKE_CURRENT_SOURCE_DIR}/CMakeConfig)

################################################################################
# Setup default installation targets for a project
################################################################################
macro (CcDhcpServerSetInstall ProjectName )
  set_property( TARGET ${ProjectName} APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
              )

  install( TARGETS  ${ProjectName}
           EXPORT  "${ProjectName}Config"
           RUNTIME DESTINATION bin
           LIBRARY DESTINATION lib
           ARCHIVE DESTINATION lib/static
           PUBLIC_HEADER DESTINATION include/${ProjectName}
         )
     
  # If we are building just CcOS Framework we have to package all headers and configs
  if("${CMAKE_PROJECT_NAME}" STREQUAL "CcOS")
    set_property( TARGET ${ProjectName} APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
                )
    install(EXPORT "${ProjectName}Config" DESTINATION "lib/${ProjectName}")
    
    install( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include
             FILES_MATCHING PATTERN "*.h"
             PATTERN "*/src"  EXCLUDE
             PATTERN "*/test" EXCLUDE)
  endif()
endmacro()

################################################################################
# Add Xml Configurations to cmake install
################################################################################
macro (CcDhcpServerSetInstallConfig ProjectName )
  install( DIRECTORY    ${CMAKE_CURRENT_SOURCE_DIR}/config/
           DESTINATION  config/${ProjectName}
           PATTERN "*.xml" )
endmacro()

################################################################################
# Set Cmake Version Info to Project
################################################################################
macro (CcSetOSVersion ProjectName )
  set_target_properties(  ${ProjectName}
                          PROPERTIES
                          VERSION ${CCDHCPSERVER_VERSION_CMAKE}
                          SOVERSION ${CCDHCPSERVER_VERSION_CMAKE})
endmacro()

################################################################################
# Setup Include Directorys for importing CcDhcpServer
################################################################################
macro( CcDhcpServerTargetIncludeDirs ProjectName )
  foreach(DIR ${ARGN})
    LIST(APPEND DIRS ${DIR} )
    target_include_directories(${ProjectName} PUBLIC $<BUILD_INTERFACE:${DIR}> )
  ENDFOREACH()
  target_include_directories( ${ProjectName} PUBLIC
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                                $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/${ProjectName}> )
endmacro()

################################################################################
# Generate RC-File for MSVC Builds, output is a Version.h File in current dir
################################################################################
macro( CcDhcpServerGenerateRcFileToCurrentDir ProjectName )
  SET(PROJECT_NAME "${ProjectName}")
  configure_file( ${CCDHCPSERVER_CMAKECONFIG_DIR}/InputFiles/ProjectVersion.rc.in ${CMAKE_CURRENT_SOURCE_DIR}/CcDhcpServerVersion.rc.tmp @ONLY)
  CcCopyFile(${CMAKE_CURRENT_SOURCE_DIR}/CcDhcpServerVersion.rc.tmp ${CMAKE_CURRENT_SOURCE_DIR}/CcDhcpServerVersion.rc)
endmacro()

################################################################################
# Rename Endings of Project output file to CcDhcpServer default.
# CURRENTLY NOT IN USE!!
################################################################################
macro( CcDhcpServerProjectNaming ProjectName )
  set_target_properties(${ProjectName} PROPERTIES OUTPUT_NAME "${ProjectName}" )
  # Debug becomes and d at the end.
  set_target_properties(${ProjectName} PROPERTIES OUTPUT_NAME_DEBUG "${ProjectName}d" )
endmacro()

################################################################################
# Set Version info for library.
# If Linux, set SOVERSION too.
################################################################################
macro( CcDhcpServerLibVersion ProjectName )
  set_target_properties(${ProjectName} PROPERTIES 
                                        VERSION ${CCDHCPSERVER_VERSION_CMAKE})
  if(LINUX)
    set_target_properties(${ProjectName} PROPERTIES 
                                          SOVERSION ${CCDHCPSERVER_VERSION_CMAKE} )
  endif(LINUX)
endmacro()

################################################################################
# Post config Steps afert add_library:
# Usage CcDhcpServerLibSettings( ProjectName [bSetupInstall] [bSetupVersion] [sSetFiltersByFolders])
################################################################################
macro( CcDhcpServerLibSettings ProjectName )
  if(${ARGC} GREATER 1)
    if(${ARGV1} STREQUAL "TRUE")
      CcDhcpServerSetInstall(${ProjectName})
    endif(${ARGV1} STREQUAL "TRUE")
  endif(${ARGC} GREATER 1)
  
  if(${ARGC} GREATER 2)
    if(${ARGV2} STREQUAL "TRUE")
      CcDhcpServerLibVersion(${ProjectName})
    endif(${ARGV2} STREQUAL "TRUE")
  endif(${ARGC} GREATER 2)
  
  if(${ARGC} GREATER 3)
    set(FILES ${ARGN})
    list(REMOVE_AT FILES 0)
    list(REMOVE_AT FILES 0)
    list(REMOVE_AT FILES 0)
    CcSetFiltersByFolders(${FILES})
  endif(${ARGC} GREATER 3)
endmacro()
