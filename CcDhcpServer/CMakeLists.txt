
set ( CURRENT_PROJECT CcDhcpServer )

########
# Add Source Files
########
file (GLOB SOURCE_FILES
      "src/*.c"
      "src/*.cpp"
      "*.h")
      

include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )
                     
if(WINDOWS)
  CcDhcpServerGenerateRcFileToCurrentDir(${CURRENT_PROJECT} SOURCE_FILES)
endif()

add_executable( ${CURRENT_PROJECT} ${SOURCE_FILES} )

# To keep Header an Source together, display them in same Directory
# It will only work with IDE's wich are supporting this features
SOURCE_GROUP( ""        FILES ${SOURCE_FILES})

target_link_libraries ( ${CURRENT_PROJECT} LINK_PUBLIC
                              CcKernel
                              CcDhcp
                              CcTftp
                              CcDocuments  )

                              

#################
# Post configuration steps
#################
CcDhcpServerTargetIncludeDirs( ${CURRENT_PROJECT} ${CMAKE_CURRENT_SOURCE_DIR})
CcDhcpServerLibSettings(${CURRENT_PROJECT} TRUE TRUE ${SOURCE_FILES})
