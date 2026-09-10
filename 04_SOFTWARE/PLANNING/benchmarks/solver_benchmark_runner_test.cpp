#include "../solvers/astar_solver.hpp"
#include "../solvers/dijkstra_solver.hpp"
#include "../model/planning_graph.hpp"
#include <cassert>
#include <cmath>
#include <iostream>

using namespace bluesky::planning;

static PlanningGraph make_graph() {
    PlanningGraph g;
    g.add_node({"A", 0.0, 0.0});
    g.add_node({"B", 1.0, 0.0});
    g.add_node({"C", 2.0, 0.0});
    g.add_node({"D", 1.0, 1.0});
    g.add_node({"E", 2.0, 1.0});
    g.add_edge({"A", "B", 1.0});
    g.add_edge({"B", "C", 1.0});
    g.add_edge({"A", "D", 1.5});
    g.add_edge({"D", "E", 0.5});
    g.add_edge({"E", "C", 1.0});
    return g;
}

int main() {
    // Deterministic reference case: both solvers must find cost 2.5.
    const auto graph = make_graph();
    const auto result = run_solver_comparison(graph, "A", "C");

    assert(result.astar.feasibility == Feasibility::Feasible);
    assert(result.dijkstra.feasibility == Feasibility::Feasible);
    assert(std::abs(result.astar.route_cost - result.dijkstra.route_cost) < 1e-9);
    assert(std::abs(result.dijkstra.route_cost - 2.5) < 1e-9);

    // A* with the admissible Euclidean heuristic must not return a route
    // more expensive than the Dijkstra reference optimum.
    assert(result.astar.route_cost <= result.dijkstra.route_cost + 1e-9);

    std::cout << "solver benchmark: PASS\n";
    std::cout << "A*: " << result.astar.route_cost << "\n";
    std::cout << "Dijkstra: " << result.dijkstra.route_cost << "\n";
    return 0;
}
