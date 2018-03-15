set(PLATFORM "")
set(dirscript ${CMAKE_CURRENT_LIST_DIR})
IF(WIN32)
	find_program(path cmaki_identifier.exe ${dirscript})
else()
	find_program(path cmaki_identifier.sh ${dirscript})
endif()
execute_process(COMMAND ${path}
			WORKING_DIRECTORY ${dirscript}
			OUTPUT_VARIABLE PLATFORM
			OUTPUT_STRIP_TRAILING_WHITESPACE)
MESSAGE("${PLATFORM}")

