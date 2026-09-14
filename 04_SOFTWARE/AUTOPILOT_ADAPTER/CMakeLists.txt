cmake_minimum_required(VERSION 3.20)
project(BlueSkyAutopilotAdapter LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

enable_testing()

add_library(bluesky_autopilot_contract INTERFACE)
target_include_directories(bluesky_autopilot_contract INTERFACE
    ${CMAKE_CURRENT_SOURCE_DIR}/core
    ${CMAKE_CURRENT_SOURCE_DIR}/../PLANNING
)
target_compile_features(bluesky_autopilot_contract INTERFACE cxx_std_20)

add_executable(universal_autopilot_adapter_contract_test
    core/universal_autopilot_adapter_contract_test.cpp
)

target_link_libraries(universal_autopilot_adapter_contract_test PRIVATE
    bluesky_autopilot_contract
)

add_test(
    NAME universal_autopilot_adapter_contract_test
    COMMAND universal_autopilot_adapter_contract_test
)

add_executable(universal_equipment_adapter_contract_test
    core/universal_equipment_adapter_contract_test.cpp
)

target_link_libraries(universal_equipment_adapter_contract_test PRIVATE
    bluesky_autopilot_contract
)

add_test(
    NAME universal_equipment_adapter_contract_test
    COMMAND universal_equipment_adapter_contract_test
)

add_executable(flight_evidence_recorder_test
    core/flight_evidence_recorder_test.cpp
)

target_link_libraries(flight_evidence_recorder_test PRIVATE
    bluesky_autopilot_contract
)

add_test(
    NAME flight_evidence_recorder_test
    COMMAND flight_evidence_recorder_test
)

add_executable(evidence_source_adapter_test
    core/evidence_source_adapter_test.cpp
)

target_link_libraries(evidence_source_adapter_test PRIVATE
    bluesky_autopilot_contract
)

add_test(
    NAME evidence_source_adapter_test
    COMMAND evidence_source_adapter_test
)
