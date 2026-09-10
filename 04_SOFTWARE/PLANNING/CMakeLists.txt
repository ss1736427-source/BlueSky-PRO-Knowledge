cmake_minimum_required(VERSION 3.20)
project(BlueSkyPlanning LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_library(bluesky_planning
    solvers/astar_solver.cpp
    solvers/dijkstra_solver.cpp
    benchmarks/solver_benchmark_runner.cpp
)

target_include_directories(bluesky_planning PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_compile_features(bluesky_planning PUBLIC cxx_std_20)

add_executable(astar_dijkstra_benchmark
    tests/astar_dijkstra_benchmark.cpp
)

target_link_libraries(astar_dijkstra_benchmark PRIVATE bluesky_planning)

enable_testing()
add_test(NAME astar_dijkstra_benchmark COMMAND astar_dijkstra_benchmark)
