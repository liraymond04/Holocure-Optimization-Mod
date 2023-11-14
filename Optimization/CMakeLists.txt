set(PROJECT_NAME Optimization)

################################################################################
# Source groups
################################################################################
set(Header_Files
    "DllMain.hpp"
    "Features/API/API.hpp"
    "Features/API/Internal.hpp"
    "Features/Console/Console.hpp"
    "Features/PluginManager/PluginManager.hpp"
    "Features/PluginManager/Structures/PmStructures.hpp"
    "Features/UnitTests/UnitTests.hpp"
    "framework.h"
    "SDK/Enums/Enums.hpp"
    "SDK/FwdDecls/FwdDecls.hpp"
    "SDK/Plugins/API Definitions/APIDefs.hpp"
    "SDK/Plugins/Plugins.hpp"
    "SDK/Plugins/YYTKEvent/YYTKEvent.hpp"
    "SDK/SDK.hpp"
    "SDK/Structures/Documented/APIVars/APIVars.hpp"
    "SDK/Structures/Documented/CCode/CCode.hpp"
    "SDK/Structures/Documented/CDynamicArray/CDynamicArray.hpp"
    "SDK/Structures/Documented/CHashMap/CHashMap.hpp"
    "SDK/Structures/Documented/FunctionInfo/FunctionInfo.hpp"
    "SDK/Structures/Documented/Math/Math.hpp"
    "SDK/Structures/Documented/RefThing/RefThing.hpp"
    "SDK/Structures/Documented/RToken/RToken.hpp"
    "SDK/Structures/Documented/VMBuffer/VMBuffer.hpp"
    "SDK/Structures/Documented/YYRValue/YYRValue.hpp"
    "SDK/Structures/Undocumented/CScript/CScript.hpp"
    "SDK/Structures/Undocumented/VMExec/VMExec.hpp"
    "SDK/Structures/Undocumented/YYGMLFuncs/YYGMLFuncs.hpp"
    "SDK/Structures/Undocumented/YYObjectBase/YYObjectBase.hpp"
    "SDK/Structures/Undocumented/YYVAR/YYVAR.hpp"
    "Utils/D3D11 Hooker/D3D11Hooker.hpp"
    "Utils/Hashing/MurMurHash.hpp"
    "Utils/Logging/Logging.hpp"
    "Utils/MH/buffer.h"
    "Utils/MH/hde/hde32.h"
    "Utils/MH/hde/hde64.h"
    "Utils/MH/hde/pstdint.h"
    "Utils/MH/hde/table32.h"
    "Utils/MH/hde/table64.h"
    "Utils/MH/MinHook.h"
    "Utils/MH/trampoline.h"
    "Utils/PE Parser/PEParser.hpp"
    "Utils/PortableFileDialog/PFD.hpp"
    "Utils/WinAPI/WinAPI.hpp"
)
source_group("Header Files" FILES ${Header_Files})

set(Source_Files
    "DllMain.cpp"
    "Features/API/API.cpp"
    "Features/API/Internal.cpp"
    "Features/Console/Console.cpp"
    "Features/PluginManager/PluginManager.cpp"
    "Features/UnitTests/UnitTests.cpp"
    "SDK/Plugins/API Definitions/APIDefs.cpp"
    "SDK/Plugins/Plugins.cpp"
    "SDK/Structures/Documented/CDynamicArray/CDynamicArray.cpp"
    "SDK/Structures/Documented/RefThing/RefThing.cpp"
    "SDK/Structures/Documented/YYRValue/YYRValue.cpp"
    "Utils/D3D11 Hooker/D3D11Hooker.cpp"
    "Utils/Hashing/MurMurHash.cpp"
    "Utils/Logging/Logging.cpp"
    "Utils/MH/buffer.c"
    "Utils/MH/hde/hde32.c"
    "Utils/MH/hde/hde64.c"
    "Utils/MH/hook.c"
    "Utils/MH/trampoline.c"
    "Utils/PE Parser/PEParser.cpp"
    "Utils/WinAPI/WinAPI.cpp"
)
source_group("Source Files" FILES ${Source_Files})

set(ALL_FILES
    ${Header_Files}
    ${Source_Files}
)

################################################################################
# Target
################################################################################
add_library(${PROJECT_NAME} SHARED ${ALL_FILES})

use_props(${PROJECT_NAME} "${CMAKE_CONFIGURATION_TYPES}" "${DEFAULT_CXX_PROPS}")
set(ROOT_NAMESPACE Optimization)

set_target_properties(${PROJECT_NAME} PROPERTIES
    VS_GLOBAL_KEYWORD "Win32Proj"
)
if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
    set_target_properties(${PROJECT_NAME} PROPERTIES
        INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
    )
elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
    set_target_properties(${PROJECT_NAME} PROPERTIES
        INTERPROCEDURAL_OPTIMIZATION_RELEASE "TRUE"
    )
endif()
################################################################################
# Compile definitions
################################################################################
if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        "$<$<CONFIG:Debug>:"
            "_DEBUG"
        ">"
        "$<$<CONFIG:Release>:"
            "NDEBUG"
        ">"
        "OPTIMIZATION_EXPORTS;"
        "_WINDOWS;"
        "_USRDLL;"
        "UNICODE;"
        "_UNICODE"
    )
elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        "$<$<CONFIG:Debug>:"
            "_DEBUG"
        ">"
        "$<$<CONFIG:Release>:"
            "NDEBUG"
        ">"
        "WIN32;"
        "OPTIMIZATION_EXPORTS;"
        "_WINDOWS;"
        "_USRDLL;"
        "UNICODE;"
        "_UNICODE"
    )
endif()

################################################################################
# Compile and link options
################################################################################
if(MSVC)
    if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
        target_compile_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Release>:
                /Oi;
                /Gy
            >
            /permissive-;
            /sdl;
            /W3;
            ${DEFAULT_CXX_DEBUG_INFORMATION_FORMAT};
            ${DEFAULT_CXX_EXCEPTION_HANDLING}
        )
    elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
        target_compile_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Release>:
                /Oi;
                /Gy
            >
            /permissive-;
            /sdl;
            /W3;
            ${DEFAULT_CXX_DEBUG_INFORMATION_FORMAT};
            ${DEFAULT_CXX_EXCEPTION_HANDLING}
        )
    endif()
    if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x64")
        target_link_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Release>:
                /OPT:REF;
                /OPT:ICF
            >
            /DEBUG;
            /SUBSYSTEM:WINDOWS
        )
    elseif("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "x86")
        target_link_options(${PROJECT_NAME} PRIVATE
            $<$<CONFIG:Release>:
                /OPT:REF;
                /OPT:ICF
            >
            /DEBUG;
            /SUBSYSTEM:WINDOWS
        )
    endif()
endif()

