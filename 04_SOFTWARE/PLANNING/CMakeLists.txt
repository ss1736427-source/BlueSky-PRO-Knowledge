cmake_minimum_required(VERSION 3.20)
project(BlueSkyPlanning LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(bluesky_planning
    solvers/astar_solver.cpp
    solvers/dijkstra_solver.cpp
    orchestrator/algorithm_orchestrator.cpp
    benchmarks/solver_benchmark_runner.cpp
    adapter/universal_adapter_registry.cpp
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

enable_testing()
add_test(NAME astar_dijkstra_benchmark COMMAND astar_dijkstra_benchmark)
add_test(NAME orchestrator_integration_test COMMAND orchestrator_integration_test)
add_test(NAME orchestrator_route_validation_test COMMAND orchestrator_route_validation_test)
add_test(NAME orchestrator_determinism_test COMMAND orchestrator_determinism_test)
add_test(NAME orchestrator_objective_test COMMAND orchestrator_objective_test)
add_test(NAME orchestrator_rejection_reason_test COMMAND orchestrator_rejection_reason_test)
add_test(NAME mission_model_contract_test COMMAND mission_model_contract_test)
add_test(NAME vehicle_equipment_capability_contract_test COMMAND vehicle_equipment_capability_contract_test)
add_test(NAME universal_adapter_contract_test COMMAND universal_adapter_contract_test)
add_test(NAME universal_adapter_registry_test COMMAND universal_adapter_registry_test)
