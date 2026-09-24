cmake_minimum_required(VERSION 3.20)
project(BlueSkyPlanning LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(bluesky_planning
    command_lifecycle_runtime.cpp
    mission_transfer_runtime.cpp
    capability_execution_integration.cpp
    parameter_configuration_runtime.cpp
    solvers/astar_solver.cpp
    solvers/dijkstra_solver.cpp
    orchestrator/algorithm_orchestrator.cpp
    benchmarks/solver_benchmark_runner.cpp
    adapter/universal_adapter_registry.cpp
    compiler/mission_compiler.cpp
)

target_include_directories(bluesky_planning PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_compile_features(bluesky_planning PUBLIC cxx_std_20)

add_executable(astar_dijkstra_benchmark
    tests/astar_dijkstra_benchmark.cpp
)
target_link_libraries(astar_dijkstra_benchmark PRIVATE bluesky_planning)

add_executable(orchestrator_integration_test
    orchestrator/algorithm_orchestrator_test.cpp
)
target_link_libraries(orchestrator_integration_test PRIVATE bluesky_planning)

add_executable(orchestrator_route_validation_test
    orchestrator/algorithm_orchestrator_route_validation_test.cpp
)
target_link_libraries(orchestrator_route_validation_test PRIVATE bluesky_planning)

add_executable(orchestrator_determinism_test
    orchestrator/algorithm_orchestrator_determinism_test.cpp
)
target_link_libraries(orchestrator_determinism_test PRIVATE bluesky_planning)

add_executable(orchestrator_objective_test
    orchestrator/algorithm_orchestrator_objective_test.cpp
)
target_link_libraries(orchestrator_objective_test PRIVATE bluesky_planning)

add_executable(orchestrator_rejection_reason_test
    orchestrator/algorithm_orchestrator_rejection_reason_test.cpp
)
target_link_libraries(orchestrator_rejection_reason_test PRIVATE bluesky_planning)

add_executable(route_constraint_validator_test
    route_constraint_validator_test.cpp
    route_constraint_validator.cpp
)
target_link_libraries(route_constraint_validator_test PRIVATE bluesky_planning)

add_executable(route_model_contract_test
    model/route_model_contract_test.cpp
)
target_link_libraries(route_model_contract_test PRIVATE bluesky_planning)

add_executable(mission_model_contract_test
    model/mission_model_contract_test.cpp
)
target_link_libraries(mission_model_contract_test PRIVATE bluesky_planning)

add_executable(vehicle_equipment_capability_contract_test
    model/vehicle_equipment_capability_contract_test.cpp
)
target_link_libraries(vehicle_equipment_capability_contract_test PRIVATE bluesky_planning)

add_executable(universal_adapter_contract_test
    adapter/universal_adapter_contract_test.cpp
)
target_link_libraries(universal_adapter_contract_test PRIVATE bluesky_planning)

add_executable(universal_adapter_registry_test
    adapter/universal_adapter_registry_test.cpp
)
target_link_libraries(universal_adapter_registry_test PRIVATE bluesky_planning)

add_executable(adapter_service_resolver_test
    adapter/adapter_service_resolver_test.cpp
)
target_link_libraries(adapter_service_resolver_test PRIVATE bluesky_planning)

add_executable(command_authority_gate_contract_stub_test
    command_authority_gate_contract_stub_test.cpp
)
target_link_libraries(command_authority_gate_contract_stub_test PRIVATE bluesky_planning)

add_executable(command_lifecycle_contract_stub_test
    command_lifecycle_contract_stub_test.cpp
)
target_link_libraries(command_lifecycle_contract_stub_test PRIVATE bluesky_planning)

add_executable(command_lifecycle_runtime_test
    command_lifecycle_runtime_test.cpp
)
target_link_libraries(command_lifecycle_runtime_test PRIVATE bluesky_planning)

add_executable(mission_compiler_test
    compiler/mission_compiler_test.cpp
)
target_link_libraries(mission_compiler_test PRIVATE bluesky_planning)

add_executable(mission_compiler_multi_test
    compiler/mission_compiler_multi_test.cpp
)
target_link_libraries(mission_compiler_multi_test PRIVATE bluesky_planning)

add_executable(mission_transfer_runtime_test
    mission_transfer_runtime_test.cpp
    ../AUTOPILOT_ADAPTER/core/autopilot_adapter_baseline.cpp
)
target_link_libraries(mission_transfer_runtime_test PRIVATE bluesky_planning)

add_executable(parameter_configuration_runtime_test
    parameter_configuration_runtime_test.cpp
    ../AUTOPILOT_ADAPTER/core/autopilot_adapter_baseline.cpp
)
target_link_libraries(parameter_configuration_runtime_test PRIVATE bluesky_planning)

add_executable(capability_execution_integration_test
    capability_execution_integration_test.cpp
    ../AUTOPILOT_ADAPTER/core/autopilot_adapter_baseline.cpp
    ../OPERATIONS/core/capability_admission_boundary.cpp
    ../OPERATIONS/core/capability_compatibility_gate.cpp
    ../OPERATIONS/core/device_capability_runtime.cpp
)
target_link_libraries(capability_execution_integration_test PRIVATE bluesky_planning)

enable_testing()
add_test(NAME astar_dijkstra_benchmark COMMAND astar_dijkstra_benchmark)
add_test(NAME orchestrator_integration_test COMMAND orchestrator_integration_test)
add_test(NAME orchestrator_route_validation_test COMMAND orchestrator_route_validation_test)
add_test(NAME orchestrator_determinism_test COMMAND orchestrator_determinism_test)
add_test(NAME orchestrator_objective_test COMMAND orchestrator_objective_test)
add_test(NAME orchestrator_rejection_reason_test COMMAND orchestrator_rejection_reason_test)
add_test(NAME route_constraint_validator_test COMMAND route_constraint_validator_test)
add_test(NAME route_model_contract_test COMMAND route_model_contract_test)
add_test(NAME mission_model_contract_test COMMAND mission_model_contract_test)
add_test(NAME vehicle_equipment_capability_contract_test COMMAND vehicle_equipment_capability_contract_test)
add_test(NAME universal_adapter_contract_test COMMAND universal_adapter_contract_test)
add_test(NAME universal_adapter_registry_test COMMAND universal_adapter_registry_test)
add_test(NAME adapter_service_resolver_test COMMAND adapter_service_resolver_test)
add_test(NAME command_authority_gate_contract_stub_test COMMAND command_authority_gate_contract_stub_test)
add_test(NAME command_lifecycle_contract_stub_test COMMAND command_lifecycle_contract_stub_test)
add_test(NAME command_lifecycle_runtime_test COMMAND command_lifecycle_runtime_test)
add_test(NAME mission_compiler_test COMMAND mission_compiler_test)
add_test(NAME mission_compiler_multi_test COMMAND mission_compiler_multi_test)
add_test(NAME mission_transfer_runtime_test COMMAND mission_transfer_runtime_test)
add_test(NAME parameter_configuration_runtime_test COMMAND parameter_configuration_runtime_test)
add_test(NAME capability_execution_integration_test COMMAND capability_execution_integration_test)

# JournalService validation test
add_executable(journal_service_test
    ../COMMON/journal/journal_service_test.cpp
    ../COMMON/journal/journal_service.cpp
    ../COMMON/journal/journal_store_memory.cpp
)
target_include_directories(journal_service_test PRIVATE ../COMMON/journal)
target_compile_features(journal_service_test PRIVATE cxx_std_20)
add_test(NAME journal_service_test COMMAND journal_service_test)
