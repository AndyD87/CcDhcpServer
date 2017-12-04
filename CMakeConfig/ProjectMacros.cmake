SET(CCOSEXAMPLEPROJECT_CMAKECONFIG_DIR ${CMAKE_CURRENT_SOURCE_DIR}/CMakeConfig)

################################################################################
# Setup default installation targets for a project
################################################################################
MACRO (CcOSExampleProjectSetInstall ProjectName )
  set_property( TARGET ${ProjectName} APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR}>
              )

  INSTALL( TARGETS  ${ProjectName}
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
    
    INSTALL( DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} DESTINATION include
             FILES_MATCHING PATTERN "*.h"
             PATTERN "*/src"  EXCLUDE
             PATTERN "*/test" EXCLUDE)
  endif()
ENDMACRO()

################################################################################
# Add Xml Configurations to cmake install
################################################################################
MACRO (CcOSExampleProjectSetInstallConfig ProjectName )
  INSTALL( DIRECTORY    ${CMAKE_CURRENT_SOURCE_DIR}/config/
           DESTINATION  config/${ProjectName}
           PATTERN "*.xml" )
ENDMACRO()

################################################################################
# Set Cmake Version Info to Project
################################################################################
MACRO (CcSetOSVersion ProjectName )
  SET_TARGET_PROPERTIES(  ${ProjectName}
                          PROPERTIES
                          VERSION ${CCOSEXAMPLEPROJECT_VERSION_CMAKE}
                          SOVERSION ${CCOSEXAMPLEPROJECT_VERSION_CMAKE})
ENDMACRO()

################################################################################
# Setup Include Directorys for importing CcOSExampleProject
################################################################################
MACRO( CcOSExampleProjectTargetIncludeDirs ProjectName )
  foreach(DIR ${ARGN})
    LIST(APPEND DIRS ${DIR} )
    target_include_directories(${ProjectName} PUBLIC $<BUILD_INTERFACE:${DIR}> )
  ENDFOREACH()
  target_include_directories( ${ProjectName} PUBLIC
                                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                                $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/${ProjectName}> )
ENDMACRO()

################################################################################
# Generate RC-File for MSVC Builds, output is a Version.h File in current dir
################################################################################
MACRO( CcOSExampleProjectGenerateRcFileToCurrentDir ProjectName )
  SET(PROJECT_NAME "${ProjectName}")
  configure_file( ${CCOSEXAMPLEPROJECT_CMAKECONFIG_DIR}/InputFiles/ProjectVersion.rc.in ${CMAKE_CURRENT_SOURCE_DIR}/CcOSExampleProjectVersion.rc.tmp @ONLY)
  CcCopyFile(${CMAKE_CURRENT_SOURCE_DIR}/CcOSExampleProjectVersion.rc.tmp ${CMAKE_CURRENT_SOURCE_DIR}/CcOSExampleProjectVersion.rc)
ENDMACRO()

################################################################################
# Rename Endings of Project output file to CcOSExampleProject default.
# CURRENTLY NOT IN USE!!
################################################################################
MACRO( CcOSExampleProjectProjectNaming ProjectName )
  set_target_properties(${ProjectName} PROPERTIES OUTPUT_NAME "${ProjectName}" )
  # Debug becomes and d at the end.
  set_target_properties(${ProjectName} PROPERTIES OUTPUT_NAME_DEBUG "${ProjectName}d" )
ENDMACRO()